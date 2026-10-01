-- =====================================================================
-- seed.sql - demo data. Every seeded account uses the password:  Password@123
-- Emails are .example domains on purpose. Run after schema.sql:  mysql -u root -p healthdb < seed.sql
-- =====================================================================
USE healthdb;
SET @pw = '$2a$10$cYs7chlCU3Xrs06r6SzWV.bqITHAjIMFCr.04wwmb9TjIax0iJxsi';

INSERT INTO users (user_id, full_name, email, password_hash, role, phone) VALUES
 (1, 'System Admin',       'admin@health.example',   @pw, 'ADMIN',        '9000000001'),
 (2, 'Dr. Asha Verma',     'asha@health.example',    @pw, 'PROFESSIONAL', '9000000002'),
 (3, 'Dr. Rohan Mehta',    'rohan@health.example',   @pw, 'PROFESSIONAL', '9000000003'),
 (4, 'Priya Sharma',       'priya@health.example',   @pw, 'PATIENT',      '9000000004'),
 (5, 'Arjun Singh',        'arjun@health.example',   @pw, 'PATIENT',      '9000000005'),
 (6, 'Neha Gupta',         'neha@health.example',    @pw, 'PATIENT',      '9000000006');

INSERT INTO professional_profiles (professional_id, specialization, license_no, qualification, experience_years) VALUES
 (2, 'General Physician', 'LIC-DEMO-0001', 'MBBS, MD', 8),
 (3, 'Dermatologist',     'LIC-DEMO-0002', 'MBBS, DVD', 5);

INSERT INTO patient_profiles (patient_id, date_of_birth, gender, blood_group) VALUES
 (4, '2001-04-12', 'FEMALE', 'B+'),
 (5, '1998-09-30', 'MALE',   'O+'),
 (6, '2003-01-18', 'FEMALE', 'A+');

-- Dr. Verma: Mon-Fri 09:00-13:00 | Dr. Mehta: Mon, Wed, Fri 14:00-18:00   (1=Mon ... 7=Sun)
INSERT INTO availability (professional_id, day_of_week, start_time, end_time) VALUES
 (2,1,'09:00','13:00'),(2,2,'09:00','13:00'),(2,3,'09:00','13:00'),(2,4,'09:00','13:00'),(2,5,'09:00','13:00'),
 (3,1,'14:00','18:00'),(3,3,'14:00','18:00'),(3,5,'14:00','18:00');

INSERT INTO system_settings (setting_key, setting_value, description, updated_by) VALUES
 ('slot_minutes',          '30', 'Length of one consultation slot in minutes', 1),
 ('max_bookings_per_day',  '10', 'Max active bookings per professional per day', 1),
 ('booking_window_days',   '30', 'How many days ahead a patient may book', 1),
 ('cancel_before_hours',   '2',  'Patients may cancel up to this many hours before start', 1);

-- Both dates below are Mondays (inside the professionals' working hours)
SET @next_mon = DATE_ADD(CURDATE(), INTERVAL (7 - WEEKDAY(CURDATE())) DAY);
SET @past_mon = DATE_SUB(@next_mon, INTERVAL 14 DAY);

INSERT INTO appointments (appointment_id, patient_id, professional_id, appointment_date, start_time, end_time, status, reason) VALUES
 (1, 4, 2, @past_mon, '09:00', '09:30', 'COMPLETED', 'Recurring headache'),
 (2, 5, 2, @next_mon, '09:30', '10:00', 'BOOKED',    'Seasonal cold and cough'),
 (3, 6, 3, @next_mon, '14:00', '14:30', 'BOOKED',    'Skin rash on forearm');

INSERT INTO consultations (appointment_id, advice, prescription, private_notes, follow_up_date) VALUES
 (1, 'Hydrate well, keep a regular sleep schedule and reduce screen time before bed.',
     'Paracetamol 500 mg only if pain persists.', 'Possible tension headache. Review if it continues.', DATE_ADD(@past_mon, INTERVAL 14 DAY));

INSERT INTO health_records (patient_id, record_type, title, description, recorded_on) VALUES
 (4, 'ALLERGY',    'Dust allergy',     'Sneezing and itchy eyes in dusty environments.', '2024-02-10'),
 (4, 'VACCINATION','Flu vaccine',      'Annual flu shot.',                               '2025-10-05'),
 (5, 'CONDITION',  'Mild asthma',      'Uses inhaler occasionally.',                     '2023-06-21');

INSERT INTO messages (appointment_id, sender_id, body, is_read) VALUES
 (2, 5, 'Good morning doctor, should I bring my previous reports?', FALSE),
 (2, 2, 'Yes, please bring any recent prescriptions.',              TRUE);
