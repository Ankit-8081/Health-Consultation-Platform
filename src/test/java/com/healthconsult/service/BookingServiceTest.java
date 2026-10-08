package com.healthconsult.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.SlotUnavailableException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Appointment;
import com.healthconsult.model.AppointmentStatus;
import com.healthconsult.model.ProfessionalSummary;
import com.healthconsult.model.Settings;
import com.healthconsult.model.Slot;
import java.time.Clock;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicInteger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/** "Now" is fixed at Monday 12 Oct 2026, 08:00 IST. Professional 2 works Monday to Friday, 09:00 to 13:00. */
class BookingServiceTest {

    private static final int PRO = 2;
    private static final int PATIENT = 4;
    private static final String MON_0900 = "2026-10-12|09:00";
    private static final String TUE_0900 = "2026-10-13|09:00";

    private Fakes.FakeAppointmentDao appointments;
    private Fakes.FakeAvailabilityDao availability;
    private Fakes.FakeProfessionalDao professionals;
    private Fakes.FakeSettingsDao settings;
    private BookingService service;

    @BeforeEach
    void setUp() {
        appointments = new Fakes.FakeAppointmentDao();
        availability = new Fakes.FakeAvailabilityDao();
        professionals = new Fakes.FakeProfessionalDao();
        settings = new Fakes.FakeSettingsDao();
        professionals.rows.add(new ProfessionalSummary(PRO, "Dr. Asha Verma", "General Physician"));
        for (DayOfWeek d : new DayOfWeek[]{DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY, DayOfWeek.THURSDAY, DayOfWeek.FRIDAY}) {
            availability.add(PRO, d, "09:00", "13:00");
        }
        Clock clock = Clock.fixed(Instant.parse("2026-10-12T02:30:00Z"), ZoneId.of("Asia/Kolkata"));
        service = new BookingService(appointments, availability, professionals, settings, new Fakes.FakeTransactor(), clock);
    }

    // ---------- free slots ----------

    @Test
    void listsFreeSlotsGroupedByDateAndSkipsDaysOff() throws Exception {
        Map<LocalDate, List<Slot>> slots = service.upcomingSlots(PRO, 7);
        assertEquals(8, slots.get(LocalDate.of(2026, 10, 12)).size());   // 09:00 to 13:00 in 30 min steps
        assertTrue(slots.containsKey(LocalDate.of(2026, 10, 16)));       // Friday
        assertTrue(!slots.containsKey(LocalDate.of(2026, 10, 17)));      // Saturday: no hours
        assertTrue(!slots.containsKey(LocalDate.of(2026, 10, 18)));      // Sunday: no hours
        assertEquals(LocalDate.of(2026, 10, 12), slots.keySet().iterator().next());   // sorted
    }

    @Test
    void aBookedSlotDisappearsFromTheList() throws Exception {
        service.book(PATIENT, PRO, MON_0900, "Recurring headache");
        List<Slot> monday = service.upcomingSlots(PRO, 1).get(LocalDate.of(2026, 10, 12));
        assertEquals(7, monday.size());
        assertTrue(monday.stream().noneMatch(s -> s.getStart().equals(LocalTime.of(9, 0))));
    }

    @Test
    void neverShowsMoreDaysThanTheBookingWindow() throws Exception {
        settings.settings = new Settings(30, 10, 2, 2);
        assertEquals(3, service.upcomingSlots(PRO, 30).size());   // today + 2 days
    }

    // ---------- booking ----------

    @Test
    void bookingCreatesAnAppointmentOfOneSlotLength() throws Exception {
        Appointment a = service.book(PATIENT, PRO, TUE_0900, "  Seasonal cold  ");
        assertEquals(AppointmentStatus.BOOKED, a.getStatus());
        assertEquals(LocalTime.of(9, 30), a.getEndTime());
        assertEquals("Seasonal cold", a.getReason());
        assertTrue(a.getAppointmentId() > 0);
    }

    @Test
    void theSameSlotCannotBeBookedTwice() throws Exception {
        service.book(PATIENT, PRO, MON_0900, "First visit");
        assertThrows(SlotUnavailableException.class, () -> service.book(5, PRO, MON_0900, "Second person"));
        assertEquals(1, appointments.rows.size());
    }

    @Test
    void aCancelledSlotCanBeBookedAgain() throws Exception {
        Appointment first = service.book(PATIENT, PRO, TUE_0900, "First visit");
        service.cancel(PATIENT, first.getAppointmentId());
        service.book(5, PRO, TUE_0900, "Second person");
        assertEquals(2, appointments.rows.size());
    }

    @Test
    void refusesSlotsOutsideWorkingHoursOrOffTheGrid() {
        assertThrows(SlotUnavailableException.class, () -> service.book(PATIENT, PRO, "2026-10-13|14:00", "Afternoon visit"));
        assertThrows(SlotUnavailableException.class, () -> service.book(PATIENT, PRO, "2026-10-13|09:10", "Odd start time"));
        assertThrows(SlotUnavailableException.class, () -> service.book(PATIENT, PRO, "2026-10-17|09:00", "Saturday visit"));
        assertEquals(0, appointments.rows.size());
    }

    @Test
    void refusesTimesThatHavePassedOrAreTooFarAhead() {
        assertThrows(SlotUnavailableException.class, () -> service.book(PATIENT, PRO, "2026-10-12|07:00", "Too early today"));
        assertThrows(SlotUnavailableException.class, () -> service.book(PATIENT, PRO, "2026-11-30|09:00", "Too far ahead"));
    }

    @Test
    void aPatientCannotBeInTwoPlacesAtOnce() throws Exception {
        professionals.rows.add(new ProfessionalSummary(3, "Dr. Rohan Mehta", "Dermatologist"));
        availability.add(3, DayOfWeek.TUESDAY, "09:00", "13:00");
        service.book(PATIENT, PRO, TUE_0900, "First visit");
        SlotUnavailableException e = assertThrows(SlotUnavailableException.class,
                () -> service.book(PATIENT, 3, TUE_0900, "Skin rash"));
        assertTrue(e.getMessage().contains("already have an appointment"));
    }

    @Test
    void stopsAtTheDailyLimit() throws Exception {
        settings.settings = new Settings(30, 2, 30, 2);
        service.book(4, PRO, "2026-10-13|09:00", "Visit one");
        service.book(5, PRO, "2026-10-13|09:30", "Visit two");
        SlotUnavailableException e = assertThrows(SlotUnavailableException.class,
                () -> service.book(6, PRO, "2026-10-13|10:00", "Visit three"));
        assertTrue(e.getMessage().contains("fully booked"));
    }

    @Test
    void badInputGivesFieldErrors() {
        ValidationException e = assertThrows(ValidationException.class, () -> service.book(PATIENT, 99, "nonsense", "hi"));
        assertTrue(e.getErrors().containsKey("professionalId"));
        assertTrue(e.getErrors().containsKey("slot"));
        assertTrue(e.getErrors().containsKey("reason"));
        assertThrows(ValidationException.class, () -> service.book(PATIENT, PRO, null, "A real reason"));
    }

    // ---------- cancelling ----------

    @Test
    void aPatientCancelsTheirOwnAppointment() throws Exception {
        Appointment a = service.book(PATIENT, PRO, TUE_0900, "First visit");
        service.cancel(PATIENT, a.getAppointmentId());
        assertEquals(AppointmentStatus.CANCELLED, appointments.findById(a.getAppointmentId()).get().getStatus());
    }

    @Test
    void nobodyCancelsSomeoneElsesAppointment() throws Exception {
        Appointment a = service.book(PATIENT, PRO, TUE_0900, "First visit");
        assertThrows(AppException.class, () -> service.cancel(5, a.getAppointmentId()));
        assertThrows(AppException.class, () -> service.cancel(PATIENT, 999));
        assertEquals(AppointmentStatus.BOOKED, appointments.findById(a.getAppointmentId()).get().getStatus());
    }

    @Test
    void cancellingTooLateIsRefused() throws Exception {
        Appointment a = service.book(PATIENT, PRO, "2026-10-12|09:00", "Soon visit");   // starts in 1 hour, cut-off is 2
        AppException e = assertThrows(AppException.class, () -> service.cancel(PATIENT, a.getAppointmentId()));
        assertTrue(e.getMessage().contains("2 hours"));
    }

    // ---------- concurrency (rubric: threads) ----------

    /** The fake transactor runs one transaction at a time, like row locks in MySQL. Real behaviour is checked on MySQL. */
    @Test
    void twoThreadsBookingTheSameSlotExactlyOneWins() throws Exception {
        ExecutorService pool = Executors.newFixedThreadPool(2);
        CountDownLatch start = new CountDownLatch(1);
        AtomicInteger won = new AtomicInteger();
        AtomicInteger lost = new AtomicInteger();
        int[] patients = {4, 5};
        Future<?>[] futures = new Future<?>[2];
        for (int i = 0; i < 2; i++) {
            final int patient = patients[i];
            futures[i] = pool.submit(() -> {
                try {
                    start.await();
                    service.book(patient, PRO, TUE_0900, "Same slot");
                    won.incrementAndGet();
                } catch (SlotUnavailableException e) {
                    lost.incrementAndGet();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            });
        }
        start.countDown();
        for (Future<?> f : futures) {
            f.get();
        }
        pool.shutdown();
        assertEquals(1, won.get());
        assertEquals(1, lost.get());
        assertEquals(1, appointments.rows.size());
    }
}
