# Software Requirements Specification
## Online Health Consultation Platform
Java Programming Project | Galgotias University | Batch 2029 | Web-based project (Rubric B)
Version 1.0 | Prepared by: Team Lead | Status: for team sign-off

---

## 1. Introduction

### 1.1 Purpose
This document defines what the Online Health Consultation Platform must do. It is the agreed reference for design, coding, testing and evaluation by all four team members.

### 1.2 Scope
A web application where patients book consultations with healthcare professionals, receive medical advice and manage their health records. Professionals manage their working hours, give consultations and read the records of their own patients. Administrators manage users, appointments and system settings and view usage statistics.

**In scope:** login and role-based access, appointment booking, schedule management, consultation and advice, health records, messaging per appointment, admin management, settings and analytics.
**Out of scope:** video or audio calls, online payment, real prescriptions or legal medical use, email/SMS delivery, mobile app, integration with hospitals. (Reminders are shown in the application, not sent outside it.)

### 1.3 Definitions
| Term | Meaning |
|---|---|
| HP | Healthcare Professional (doctor or similar) |
| Slot | One consultation period. Its length comes from the `slot_minutes` setting (default 30). |
| Active booking | An appointment with status BOOKED |
| PRG | Post-Redirect-Get pattern, used after every successful form submission |
| DAO | Data Access Object, the class that talks to the database through JDBC |

### 1.4 Technology
Java 17, Servlets (Jakarta) and JSP/JSTL, JDBC, MySQL 8, Tomcat 10.1, Maven, JUnit 5, Git/GitHub.

## 2. Overall description

### 2.1 User classes
| User | Description | Key needs |
|---|---|---|
| Admin | Runs the platform. Created by seed data, not by public registration. | Manage users, appointments and settings, see statistics |
| Healthcare Professional | Created by an Admin. | Set availability, see their consultations, give advice, read their patients' records |
| Patient | Registers themselves. | Book, read advice, keep health records |

### 2.2 Assumptions and constraints
- Single hospital or clinic deployment, all times in one time zone (IST).
- A consultation is booked in fixed-length slots inside the professional's weekly working hours.
- Runs on a desktop browser first, usable on a phone.
- Project must be demonstrable from a fresh clone on a student laptop.
- Review 1 due 10 Oct 2026, Review 2 due 15 Nov 2026.

## 3. Functional requirements
Priority: **M** = must have, **S** = should have. Sprint = the sprint in the team plan. Ref = feature ID from the plan.

### 3.1 Common (all roles)
| ID | Requirement | Pri | Ref | Sprint |
|---|---|---|---|---|
| FR-C1 | A visitor can register as a Patient with name, email, phone and password. | M | F1 | S1 |
| FR-C2 | A user can log in with email and password and is sent to the dashboard for their role. | M | F1 | S1 |
| FR-C3 | A user can log out. The session is invalidated. | M | F1 | S1 |
| FR-C4 | A user who opens a URL that belongs to another role sees a 403 page. A user who is not logged in is sent to the login page. | M | F1 | S1 |
| FR-C5 | A user can view and change their profile and password. | S | F9 | S2 |

### 3.2 Admin
| ID | Requirement (input / output) | Pri | Ref | Sprint |
|---|---|---|---|---|
| FR-A1 | **User management.** Admin creates, edits, deactivates or deletes a user (input: name, email, role, phone). Output: confirmation message. An Admin cannot delete or deactivate their own account. | M | F4 | S2 |
| FR-A2 | **Appointment management.** Admin views all appointments, filters by date, professional or status, reschedules or cancels one. Output: confirmation message. | M | F10 | S3 |
| FR-A3 | **System settings.** Admin changes settings (slot length, max bookings per day, booking window, cancellation cut-off). Output: confirmation message. New values apply to later bookings. | M | F12 | S3 |
| FR-A4 | **System analytics.** Dashboard shows total users by role, appointments by status, appointments per professional, and appointments per day for the last 30 days. | S | F13 | S3 |

### 3.3 Healthcare Professional
| ID | Requirement (input / output) | Pri | Ref | Sprint |
|---|---|---|---|---|
| FR-H1 | **Schedule management.** HP adds, edits or removes weekly working hours (day, start, end). Output: confirmation. Hours of one day may not overlap. | M | F3 | S1 |
| FR-H2 | **Consultation list.** HP sees their own BOOKED and COMPLETED appointments, ordered by date. | M | F5 | S2 |
| FR-H3 | **Provide consultation.** HP enters advice, prescription, private notes and follow-up date for an appointment. Output: confirmation. The appointment becomes COMPLETED in the same transaction. | M | F5 | S2 |
| FR-H4 | **Patient record access.** HP opens the health records and consultation history of a patient (input: patient ID) only if they share at least one appointment. Each access is written to the activity log. | M | F8 | S2 |
| FR-H5 | **Communication.** HP reads and sends messages on an appointment thread. | S | F11 | S3 |

### 3.4 Patient
| ID | Requirement (input / output) | Pri | Ref | Sprint |
|---|---|---|---|---|
| FR-P1 | **Book consultation.** Patient picks an HP, a date and a free slot and gives a reason. Output: booking confirmation. See business rules BR-1 to BR-6. | M | F2 | S1 |
| FR-P2 | **My appointments.** Patient lists upcoming and past appointments and cancels an upcoming one before the cut-off. | M | F2 | S1 |
| FR-P3 | **Receive medical advice.** Patient views advice, prescription and follow-up date of their completed consultations. Private notes are never shown. | M | F6 | S2 |
| FR-P4 | **Health records.** Patient adds, edits and deletes their own records (type, title, description, date). | M | F7 | S2 |
| FR-P5 | **Communication.** Patient reads and sends messages on their appointment threads. | S | F11 | S3 |

## 4. Business rules
| ID | Rule |
|---|---|
| BR-1 | A slot is free only if it lies inside the HP's working hours for that weekday and has no active booking. |
| BR-2 | Booking must be in the future and not more than `booking_window_days` ahead. |
| BR-3 | Two active bookings may never share the same HP, date and start time. Enforced by the booking transaction and by a database UNIQUE key. |
| BR-4 | An HP may have at most `max_bookings_per_day` active bookings per day. |
| BR-5 | A patient cannot hold two active bookings at the same date and time. |
| BR-6 | A booking is created in one database transaction. On any failure the whole booking is rolled back. |
| BR-7 | Patients may cancel up to `cancel_before_hours` hours before the start time. |
| BR-8 | An HP can read a patient's records only while they share an appointment. A patient can read only their own data. |
| BR-9 | Email addresses are unique. Passwords are stored only as BCrypt hashes. |
| BR-10 | Deleting a user is blocked if they have appointments. Deactivate them instead. |

## 5. Non-functional requirements
| Area | Requirement |
|---|---|
| Security | BCrypt hashing. All SQL through `PreparedStatement`. Output escaped with JSTL `<c:out>`. New session ID at login. Session timeout 30 minutes. Role checked on the server for every request, not only hidden in the UI. |
| Validation | Every form is validated on the server. Field rules are in the UI spec. |
| Usability | Every action ends with a clear success or error message. Forms keep the user's input after an error. |
| Reliability | Errors show a friendly page. Stack traces never reach the browser and are logged. |
| Performance | Normal pages respond within 2 seconds on a student laptop with the demo data. |
| Maintainability | Layered packages (servlet, service, dao, model, util, exception, filter). No SQL in servlets or JSP. No scriptlets in JSP. |
| Testability | Services and DAOs are covered by JUnit tests. Build and tests run with one Maven command. |
| Portability | Works on Windows, Linux and macOS with Java 17 and MySQL 8. Setup is written in the README. |

## 6. Data requirements
Logical model in `diagrams/er.png`; physical model in `schema.sql`; demo data in `seed.sql`. Main entities: users, patient_profiles, professional_profiles, availability, appointments, consultations, health_records, messages, system_settings, activity_log.

## 7. Key use cases
| ID | Use case | Actor | Main flow | Alternative flows |
|---|---|---|---|---|
| UC-1 | Log in | All | Enter email and password, system checks, user lands on their dashboard | Wrong credentials: generic error. Inactive account: generic error. |
| UC-2 | Book consultation | Patient | Choose HP and date, see free slots, pick one, give reason, confirm, see confirmation | Slot taken meanwhile: rollback, message, choose again. Past date or outside window: validation error. |
| UC-3 | Set availability | HP | Open schedule, add day and hours, save | Overlap or end before start: validation error. |
| UC-4 | Give consultation | HP | Open booked appointment, optionally open patient history, enter advice, save | Empty advice: validation error. Appointment already completed: read only. |
| UC-5 | Manage health records | Patient | Add, edit or delete a record | Invalid date: validation error. |
| UC-6 | Manage users | Admin | Create or edit user, save, see confirmation | Duplicate email: error. Own account: blocked. |
| UC-7 | View analytics | Admin | Open analytics page, see counts and chart | No data: empty state message. |

Diagrams: `usecase.png`, `flow_login.png`, `flow_booking.png`, `flow_consultation.png`.

## 8. Mapping to the marking rubric (Rubric B)
| Rubric item | Where it is shown |
|---|---|
| Problem understanding and solution design (8) | This SRS, all diagrams, module and URL map |
| Core Java concepts (10) | OOP: `User` hierarchy and interfaces. Collections: slot grouping and sorting. Exceptions: custom exception classes. Threads: `ReminderScheduler` and the concurrent booking guard. |
| Database integration, JDBC (8) | `schema.sql`, DAOs with `PreparedStatement`, booking transaction |
| Servlets and web integration (7) | Servlet per feature, session and role filters, JSP views |
| Code quality and testing (10) | Layered packages, JUnit, CI |
| Teamwork and collaboration (5) | Pull requests, issue board, commit history |
| Innovation (2) | Printable consultation summary, analytics chart |

## 9. Open points for the team
1. Confirm the extras count for the Innovation marks (ask faculty).
2. Decide the demo database host (each laptop or one shared machine).
3. Confirm slot length default (30 min) and working-hour defaults in `seed.sql`.
