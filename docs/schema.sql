-- =====================================================================
-- Online Health Consultation Platform - schema.sql  (MySQL 8.0+)
-- Run:  mysql -u root -p < schema.sql     then     mysql -u root -p healthdb < seed.sql
-- Design: 3NF, InnoDB, utf8mb4. Role-specific data lives in profile tables.
-- =====================================================================
DROP DATABASE IF EXISTS healthdb;
CREATE DATABASE healthdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE healthdb;

-- ---------- users (all three roles) ----------
CREATE TABLE users (
  user_id        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name      VARCHAR(100)  NOT NULL,
  email          VARCHAR(120)  NOT NULL,
  password_hash  VARCHAR(100)  NOT NULL,              -- BCrypt, never plain text
  role           ENUM('ADMIN','PROFESSIONAL','PATIENT') NOT NULL,
  phone          VARCHAR(15)   NULL,
  status         ENUM('ACTIVE','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_users_email UNIQUE (email)
) ENGINE=InnoDB;

-- ---------- role profiles (1:0..1 with users) ----------
CREATE TABLE patient_profiles (
  patient_id         INT UNSIGNED PRIMARY KEY,
  date_of_birth      DATE         NULL,
  gender             ENUM('MALE','FEMALE','OTHER') NULL,
  blood_group        VARCHAR(3)   NULL,
  address            VARCHAR(255) NULL,
  emergency_contact  VARCHAR(15)  NULL,
  CONSTRAINT fk_pp_user FOREIGN KEY (patient_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE professional_profiles (
  professional_id   INT UNSIGNED PRIMARY KEY,
  specialization    VARCHAR(80)  NOT NULL,
  license_no        VARCHAR(40)  NOT NULL,
  qualification     VARCHAR(120) NULL,
  experience_years  TINYINT UNSIGNED NOT NULL DEFAULT 0,
  bio               VARCHAR(500) NULL,
  CONSTRAINT uq_prof_license UNIQUE (license_no),
  CONSTRAINT fk_prof_user FOREIGN KEY (professional_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------- weekly working hours ----------
CREATE TABLE availability (
  availability_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  professional_id  INT UNSIGNED NOT NULL,
  day_of_week      TINYINT UNSIGNED NOT NULL,          -- 1=Monday ... 7=Sunday (ISO, matches java.time.DayOfWeek)
  start_time       TIME NOT NULL,
  end_time         TIME NOT NULL,
  CONSTRAINT chk_av_day  CHECK (day_of_week BETWEEN 1 AND 7),
  CONSTRAINT chk_av_time CHECK (end_time > start_time),
  CONSTRAINT uq_av UNIQUE (professional_id, day_of_week, start_time),
  CONSTRAINT fk_av_prof FOREIGN KEY (professional_id) REFERENCES professional_profiles(professional_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------- appointments ----------
-- active_flag is 1 only while BOOKED, NULL otherwise. MySQL unique indexes allow many NULLs, so the
-- UNIQUE key below blocks double-booking of a live slot but lets a cancelled slot be booked again.
CREATE TABLE appointments (
  appointment_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  patient_id        INT UNSIGNED NOT NULL,
  professional_id   INT UNSIGNED NOT NULL,
  appointment_date  DATE NOT NULL,
  start_time        TIME NOT NULL,
  end_time          TIME NOT NULL,
  status            ENUM('BOOKED','COMPLETED','CANCELLED') NOT NULL DEFAULT 'BOOKED',
  reason            VARCHAR(255) NULL,
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  active_flag       TINYINT GENERATED ALWAYS AS (IF(status = 'BOOKED', 1, NULL)) STORED,
  CONSTRAINT chk_ap_time CHECK (end_time > start_time),
  CONSTRAINT uq_ap_live_slot UNIQUE (professional_id, appointment_date, start_time, active_flag),
  CONSTRAINT fk_ap_patient FOREIGN KEY (patient_id)      REFERENCES patient_profiles(patient_id),
  CONSTRAINT fk_ap_prof    FOREIGN KEY (professional_id) REFERENCES professional_profiles(professional_id),
  INDEX idx_ap_patient (patient_id, appointment_date),
  INDEX idx_ap_prof_day (professional_id, appointment_date)
) ENGINE=InnoDB;

-- ---------- consultation outcome (0..1 per appointment) ----------
CREATE TABLE consultations (
  consultation_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  appointment_id   INT UNSIGNED NOT NULL,
  advice           TEXT NOT NULL,                      -- visible to the patient
  prescription     TEXT NULL,                          -- visible to the patient
  private_notes    TEXT NULL,                          -- professional only, never shown to patient
  follow_up_date   DATE NULL,
  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_cons_appt UNIQUE (appointment_id),
  CONSTRAINT fk_cons_appt FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------- patient health records ----------
CREATE TABLE health_records (
  record_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  patient_id   INT UNSIGNED NOT NULL,
  record_type  ENUM('ALLERGY','CONDITION','MEDICATION','LAB_RESULT','VACCINATION','OTHER') NOT NULL,
  title        VARCHAR(120) NOT NULL,
  description  TEXT NULL,
  recorded_on  DATE NOT NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_hr_patient FOREIGN KEY (patient_id) REFERENCES patient_profiles(patient_id) ON DELETE CASCADE,
  INDEX idx_hr_patient (patient_id, recorded_on)
) ENGINE=InnoDB;

-- ---------- messages, threaded per appointment ----------
CREATE TABLE messages (
  message_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  appointment_id  INT UNSIGNED NOT NULL,
  sender_id       INT UNSIGNED NOT NULL,
  body            VARCHAR(1000) NOT NULL,
  sent_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_read         BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT fk_msg_appt   FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE,
  CONSTRAINT fk_msg_sender FOREIGN KEY (sender_id)      REFERENCES users(user_id),
  INDEX idx_msg_thread (appointment_id, sent_at)
) ENGINE=InnoDB;

-- ---------- admin-configurable settings ----------
CREATE TABLE system_settings (
  setting_key    VARCHAR(50)  PRIMARY KEY,
  setting_value  VARCHAR(100) NOT NULL,
  description    VARCHAR(200) NULL,
  updated_by     INT UNSIGNED NULL,
  updated_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_set_user FOREIGN KEY (updated_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------- audit trail (logins, record access, bookings) ----------
CREATE TABLE activity_log (
  log_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id     INT UNSIGNED NULL,
  action      VARCHAR(50)  NOT NULL,                   -- e.g. LOGIN, BOOK, VIEW_RECORDS
  details     VARCHAR(255) NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_log_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
  INDEX idx_log_action (action, created_at)
) ENGINE=InnoDB;

-- =====================================================================
-- Reference queries the DAOs are expected to use (for the team)
-- =====================================================================
-- Booking transaction (inside one JDBC transaction, autoCommit=false):
--   SELECT appointment_id FROM appointments
--    WHERE professional_id=? AND appointment_date=? AND start_time=? AND status='BOOKED' FOR UPDATE;
--   -> if a row exists: rollback + throw SlotUnavailableException
--   INSERT INTO appointments (patient_id, professional_id, appointment_date, start_time, end_time, reason) VALUES (...);
--   INSERT INTO activity_log (user_id, action, details) VALUES (?, 'BOOK', ?);
--   commit. The UNIQUE key is the final safety net if two requests race past the SELECT.
--
-- Professional may open patient history only if they share an appointment:
--   SELECT 1 FROM appointments WHERE professional_id=? AND patient_id=? LIMIT 1;
--
-- Analytics: SELECT status, COUNT(*) FROM appointments GROUP BY status;
--            SELECT professional_id, COUNT(*) FROM appointments GROUP BY professional_id;
