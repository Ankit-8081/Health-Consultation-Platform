package com.healthconsult.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.healthconsult.dao.ReminderDao;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.model.Appointment;
import com.healthconsult.model.AppointmentStatus;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class ReminderServiceTest {

    private static final ZoneId ZONE = ZoneId.of("Asia/Kolkata");
    private static final Clock CLOCK = Clock.fixed(Instant.parse("2026-10-12T04:00:00Z"), ZONE); // 09:30 IST

    /** Returns whatever it is given and remembers the window it was asked for. */
    private static class FakeReminderDao implements ReminderDao {
        List<Appointment> rows = new ArrayList<>();
        boolean fail;
        LocalDateTime askedFrom;
        LocalDateTime askedTo;

        @Override
        public List<Appointment> findBookedStartingBetween(LocalDateTime from, LocalDateTime to) throws AppException {
            askedFrom = from;
            askedTo = to;
            if (fail) {
                throw new DataAccessException("down");
            }
            return rows;
        }
    }

    private static Appointment appt(int id, String patient, String doctor, int hour, int minute) {
        Appointment a = new Appointment(id, 4, 2, LocalDate.of(2026, 10, 12), LocalTime.of(hour, minute),
                LocalTime.of(hour, minute).plusMinutes(30), AppointmentStatus.BOOKED, "Checkup");
        a.setPatientName(patient);
        a.setProfessionalName(doctor);
        return a;
    }

    @Test
    void asksForTheNextSixtyMinutes() {
        FakeReminderDao dao = new FakeReminderDao();
        new ReminderService(dao, CLOCK).sendDueReminders();
        assertEquals(LocalDateTime.of(2026, 10, 12, 9, 30), dao.askedFrom);
        assertEquals(LocalDateTime.of(2026, 10, 12, 10, 30), dao.askedTo);
    }

    @Test
    void remindsOncePerAppointmentEvenIfTheJobRunsAgain() {
        FakeReminderDao dao = new FakeReminderDao();
        dao.rows.add(appt(1, "Priya", "Dr. Asha", 10, 0));
        dao.rows.add(appt(2, "Arjun", "Dr. Rohan", 10, 15));
        ReminderService service = new ReminderService(dao, CLOCK);

        assertEquals(2, service.sendDueReminders());
        assertEquals(0, service.sendDueReminders());

        dao.rows.add(appt(3, "Neha", "Dr. Asha", 10, 20));
        assertEquals(1, service.sendDueReminders());
    }

    @Test
    void anAppointmentThatLeftTheWindowAndComesBackIsRemindedAgain() {
        FakeReminderDao dao = new FakeReminderDao();
        dao.rows.add(appt(1, "Priya", "Dr. Asha", 10, 0));
        ReminderService service = new ReminderService(dao, CLOCK);
        assertEquals(1, service.sendDueReminders());

        dao.rows.clear();
        assertEquals(0, service.sendDueReminders());

        dao.rows.add(appt(1, "Priya", "Dr. Asha", 10, 0));
        assertEquals(1, service.sendDueReminders());
    }

    @Test
    void aDatabaseProblemIsSwallowedSoTheThreadKeepsRunning() {
        FakeReminderDao dao = new FakeReminderDao();
        dao.fail = true;
        assertEquals(0, new ReminderService(dao, CLOCK).sendDueReminders());
    }

    @Test
    void messageNamesPatientDoctorAndTime() {
        String text = ReminderService.describe(appt(7, "Priya", "Dr. Asha", 10, 0));
        assertTrue(text.contains("Priya"));
        assertTrue(text.contains("Dr. Asha"));
        assertTrue(text.contains("12 Oct 2026 10:00"));
    }
}
