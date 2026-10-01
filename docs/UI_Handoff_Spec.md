# Handoff Spec: Web UI and Servlet/URL Contract
Online Health Consultation Platform | For: Frontend (C), Business Logic (B), QA (D) | Owner: Team Lead
Stack: JSP + JSTL/EL, plain CSS (no framework needed), tiny vanilla JS only for small conveniences.

## Overview
Three role dashboards (Admin, Healthcare Professional, Patient) share one layout. Every page is a JSP behind a servlet. JSP files live under `WEB-INF/views/` so they cannot be opened directly. Why: the role filter then protects every page, because the only way in is through a servlet.

## 1. Servlet / URL contract (frozen 1 Oct; changes only by PR to this file)
| Area | Method + URL | Role | Servlet | View (JSP) | Purpose |
|---|---|---|---|---|---|
| Auth | GET/POST `/login` | public | LoginServlet | `auth/login.jsp` | Log in |
| Auth | GET/POST `/register` | public | RegisterServlet | `auth/register.jsp` | Patient registration |
| Auth | POST `/logout` | any | LogoutServlet | redirect `/login` | Log out |
| Dash | GET `/patient/dashboard` | PATIENT | PatientDashboardServlet | `patient/dashboard.jsp` | Upcoming bookings, shortcuts |
| Dash | GET `/pro/dashboard` | PROFESSIONAL | ProDashboardServlet | `pro/dashboard.jsp` | Today's consultations |
| Dash | GET `/admin/dashboard` | ADMIN | AdminDashboardServlet | `admin/dashboard.jsp` | Counts and shortcuts |
| Patient | GET/POST `/patient/book` | PATIENT | BookingServlet | `patient/book.jsp` | Choose HP, date, slot |
| Patient | GET `/patient/appointments` | PATIENT | PatientAppointmentsServlet | `patient/appointments.jsp` | List |
| Patient | POST `/patient/appointments/cancel` | PATIENT | CancelAppointmentServlet | redirect | Cancel |
| Patient | GET `/patient/advice` | PATIENT | AdviceServlet | `patient/advice.jsp` | Advice received |
| Patient | GET/POST `/patient/records` | PATIENT | RecordServlet | `patient/records.jsp` | List, add, edit, delete records |
| Patient | GET/POST `/patient/profile` | PATIENT | ProfileServlet | `common/profile.jsp` | Profile and password |
| Pro | GET/POST `/pro/schedule` | PROFESSIONAL | ScheduleServlet | `pro/schedule.jsp` | Working hours |
| Pro | GET `/pro/consultations` | PROFESSIONAL | ConsultationListServlet | `pro/consultations.jsp` | List |
| Pro | GET/POST `/pro/consultations/provide` | PROFESSIONAL | ConsultationServlet | `pro/provide.jsp` | Enter advice |
| Pro | GET `/pro/patient-records?patientId=` | PROFESSIONAL | PatientRecordAccessServlet | `pro/patient-records.jsp` | Patient history |
| Shared | GET/POST `/messages?appointmentId=` | PATIENT, PROFESSIONAL | MessageServlet | `common/messages.jsp` | Thread |
| Admin | GET/POST `/admin/users` | ADMIN | AdminUserServlet | `admin/users.jsp` | User CRUD |
| Admin | GET/POST `/admin/appointments` | ADMIN | AdminAppointmentServlet | `admin/appointments.jsp` | Manage |
| Admin | GET/POST `/admin/settings` | ADMIN | SettingsServlet | `admin/settings.jsp` | Settings |
| Admin | GET `/admin/analytics` | ADMIN | AnalyticsServlet | `admin/analytics.jsp` | Statistics |
| Error | any | any | (error-page in web.xml) | `error/403.jsp`, `404.jsp`, `500.jsp` | Friendly errors |

Rules for every servlet: doPost validates, calls a service, then **redirects** (PRG) with a flash message in the session. Errors forward back to the same JSP with `errors` (Map) and `form` (entered values) request attributes. Filters: `AuthFilter` on `/*`, `RoleFilter` on `/admin/*`, `/pro/*`, `/patient/*`.

## 2. Layout
One shared layout `common/layout.jsp` (header, sidebar, content, footer), included by every page.
| Region | Content |
|---|---|
| Header | App name left, user name + role badge + Logout right |
| Sidebar | Links for the logged-in role only (see section 1). Active link highlighted. |
| Content | Page title (h1), flash message area, page body. Max width `layout-max`. |
| Footer | Project name, year |

Grid: CSS Grid, sidebar `sidebar-w` fixed, content flexible. Forms are a single column. Tables sit in a container with `overflow-x: auto`.

## 3. Design tokens (define once as CSS custom properties in `css/tokens.css`)
| Token | Value | Usage |
|---|---|---|
| `color-primary` | #1F6FB2 | Buttons, links, active nav |
| `color-primary-dark` | #164F80 | Button hover |
| `color-success` | #2E7D32 | Success message, COMPLETED badge |
| `color-warning` | #B26A00 | BOOKED badge, warnings |
| `color-danger` | #C62828 | Errors, delete, CANCELLED badge |
| `color-bg` | #F5F7FA | Page background |
| `color-surface` | #FFFFFF | Cards, tables, forms |
| `color-text` | #1B1F24 | Body text (contrast 15:1 on surface) |
| `color-muted` | #5B6573 | Hints, secondary text |
| `color-border` | #D5DBE3 | Inputs, table lines |
| `font-body` | system-ui, "Segoe UI", Arial, sans-serif 16px/1.5 | Everything |
| `font-heading-lg` | 24px / 600 | Page title |
| `font-heading-md` | 18px / 600 | Card and section titles |
| `spacing-xs/sm/md/lg` | 4 / 8 / 16 / 24 px | Gaps and padding |
| `radius` | 6px | Cards, inputs, buttons |
| `sidebar-w` | 220px | Sidebar width |
| `layout-max` | 1100px | Content max width |

## 4. Components
| Component | Variant | Props / fields | Notes |
|---|---|---|---|
| Button | primary, secondary, danger | label, type, disabled | Danger always asks confirmation (see states) |
| Text input | text, email, password, date, time, textarea | label, name, required, maxlength, hint, error | Label always visible above the field. Password has show/hide toggle. |
| Select | professional, record type, role | label, options | First option is a disabled placeholder |
| Slot picker | radio buttons as buttons | list of free slots `HH:mm` | Only free slots are rendered. Selected slot has `color-primary` fill. |
| Status badge | BOOKED, COMPLETED, CANCELLED | text | Colour AND text, never colour alone |
| Data table | list | columns, rows, empty message | Header row sticky. Actions column right aligned. |
| Flash message | success, error, info | text | Shown once after redirect, then removed from session |
| Card | stat, content | title, value | Used on dashboards |
| Confirm dialog | delete, cancel | message | Native `<dialog>` element, focus on the safe button |
| Message bubble | sent, received | body, time | Sent on the right, received on the left |

## 5. Forms and validation (server side always, browser attributes as a convenience)
| Form | Field | Rule |
|---|---|---|
| Register | Full name | Required, 2 to 100 characters |
| Register / Login | Email | Required, valid format, max 120, unique |
| Register | Phone | Optional, 10 digits |
| Register / Profile | Password | Required at register, 8 to 64 characters, at least one letter and one digit |
| Register | Confirm password | Must equal password |
| Book | Professional, date, slot | All required. Date today or later and within booking window. Slot must come from the free list. |
| Book | Reason | Required, 5 to 255 characters |
| Schedule | Day, start, end | Required, end after start, no overlap on the same day |
| Provide consultation | Advice | Required, 10 to 2000 characters |
| Provide consultation | Prescription, private notes | Optional, max 2000 characters each |
| Provide consultation | Follow-up date | Optional, must be after the appointment date |
| Health record | Type, title, date | Required. Title 2 to 120 characters. Date not in the future. |
| Health record | Description | Optional, max 2000 characters |
| Message | Body | Required, 1 to 1000 characters, trimmed |
| Admin user | Name, email, role | Required. Role from the allowed list. |
| Admin settings | slot_minutes | 10 to 120, multiple of 5 |
| Admin settings | max_bookings_per_day | 1 to 50 |
| Admin settings | booking_window_days | 1 to 90 |
| Admin settings | cancel_before_hours | 0 to 48 |

Error text format: one sentence, says what to fix ("Enter a date that is today or later"). Shown under the field and summarised at the top.

## 6. States and interactions
| Element | State | Behaviour |
|---|---|---|
| Button | Hover | Background `color-primary-dark` |
| Button | Focus | 3px outline `color-primary`, offset 2px. Never removed. |
| Button | Disabled | 50% opacity, `not-allowed` cursor |
| Submit button | After click | Disabled and label changes to "Saving..." so a double click cannot double submit |
| Input | Focus | Border `color-primary` |
| Input | Error | Border `color-danger`, message below in `color-danger`, `aria-invalid="true"` |
| Delete or Cancel | Click | Confirm dialog: "Delete this record? This cannot be undone." Buttons: Keep / Delete |
| Slot picker | No free slot | Text "No free slots on this date. Try another day." Submit disabled. |
| Slot picker | Slot just taken | Page reloads with error "That slot was just booked. Please choose another." and the form values kept |
| Table | Empty | Message plus the next action, e.g. "No appointments yet. Book your first consultation." |
| Page | Loading | Server rendered, so no spinner. Submit buttons show the "Saving..." state. |
| Page | Error | Friendly 500 page with a link back to the dashboard. No stack trace. |
| Session | Expired | Redirect to `/login?expired=1` with message "Your session expired. Please log in again." |

## 7. Responsive behaviour
| Breakpoint | Changes |
|---|---|
| Desktop (over 1024px) | Sidebar fixed left, content beside it, tables full width |
| Tablet (768 to 1024px) | Sidebar collapses to icons and labels below the icon row, stat cards two per row |
| Mobile (under 768px) | Sidebar becomes a menu button and top drawer. Stat cards one per row. Tables scroll sideways inside their container. Buttons full width. Why: patients are likely to use their phone to book and to read advice, so booking and advice must work at 360px wide. |

## 8. Edge cases
- **Long text**: names and titles truncate with an ellipsis in tables (full text in a `title` attribute). Advice and notes wrap and never truncate.
- **Many records**: lists over 20 rows use simple Previous / Next paging (`?page=`).
- **Missing data**: show "Not provided" in `color-muted`, never blank or "null".
- **Dates and times**: dates `dd MMM yyyy`, times 24 hour `HH:mm`. Use a single formatter so pages match.
- **Special characters and script tags**: all user text goes through `<c:out>`.
- **Back button after logout**: pages send `Cache-Control: no-store` so the old page is not shown.
- **Deep link while logged out**: log in, then return to the requested page.

## 9. Motion
Keep it minimal, to avoid distraction and extra work.
| Element | Trigger | Animation | Duration | Easing |
|---|---|---|---|---|
| Flash message | Page load | Fade in | 150ms | ease-out |
| Button | Hover | Background colour change | 120ms | ease |
| Confirm dialog | Open | Fade in | 150ms | ease-out |
Honour `prefers-reduced-motion`: remove all of the above.

## 10. Accessibility
- Landmarks: `header`, `nav` (aria-label "Main"), `main`, `footer`. One `h1` per page, headings in order.
- "Skip to content" link as the first focusable element.
- Focus order follows the visual order: skip link, header, sidebar, content.
- Every input has a `<label for>`. Errors are linked with `aria-describedby`. Flash messages use `role="status"` (success) or `role="alert"` (error).
- Tables use `<th scope>` and a `<caption>`.
- Slot picker is a radio group inside a `<fieldset><legend>`, operable with arrow keys.
- Status is shown by text as well as colour. Contrast at least 4.5:1 for text.
- Everything works with the keyboard alone. Dialog traps focus and Escape closes it.
- Touch targets at least 44 by 44px.

## 11. Screen checklist for Frontend
Login, Register, three dashboards, Book, My appointments, Advice, Health records, Profile, Schedule, Consultation list, Provide consultation, Patient records (HP), Messages, Admin users, Admin appointments, Admin settings, Admin analytics, 403, 404, 500. That is 22 pages. Build the first five in Sprint 1 (Login, Register, Patient dashboard, Book, Schedule), the rest by Sprint 3.
