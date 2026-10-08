package com.healthconsult.service;

import com.healthconsult.dao.AppointmentDao;
import com.healthconsult.dao.AvailabilityDao;
import com.healthconsult.dao.AppointmentDaoImpl;
import com.healthconsult.dao.AvailabilityDaoImpl;
import com.healthconsult.dao.ProfessionalDao;
import com.healthconsult.dao.ProfessionalDaoImpl;
import com.healthconsult.dao.SettingsDao;
import com.healthconsult.dao.SettingsDaoImpl;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.SlotUnavailableException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Appointment;
import com.healthconsult.model.AppointmentStatus;
import com.healthconsult.model.Availability;
import com.healthconsult.model.ProfessionalSummary;
import com.healthconsult.model.Settings;
import com.healthconsult.model.Slot;
import com.healthconsult.util.DbTransactor;
import com.healthconsult.util.Transactor;
import com.healthconsult.util.Validator;
import java.time.Clock;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

/**
 * F2: booking (SRS FR-P1, FR-P2, rules BR-1 to BR-7).
 * The checks that need the database run inside ONE transaction (BR-6): lock and check the slot,
 * check the daily limit, check the patient is free, insert. Any failure rolls everything back.
 */
public class BookingService {

    static final ZoneId APP_ZONE = ZoneId.of("Asia/Kolkata");

    private final AppointmentDao appointmentDao;
    private final AvailabilityDao availabilityDao;
    private final ProfessionalDao professionalDao;
    private final SettingsDao settingsDao;
    private final Transactor transactor;
    private final Clock clock;

    public BookingService() {
        this(new AppointmentDaoImpl(), new AvailabilityDaoImpl(), new ProfessionalDaoImpl(), new SettingsDaoImpl(),
                new DbTransactor(), Clock.system(APP_ZONE));
    }

    public BookingService(AppointmentDao appointmentDao, AvailabilityDao availabilityDao, ProfessionalDao professionalDao,
                          SettingsDao settingsDao, Transactor transactor, Clock clock) {
        this.appointmentDao = appointmentDao;
        this.availabilityDao = availabilityDao;
        this.professionalDao = professionalDao;
        this.settingsDao = settingsDao;
        this.transactor = transactor;
        this.clock = clock;
    }

    public List<ProfessionalSummary> professionals() throws AppException {
        return professionalDao.findAllActive();
    }

    public List<Appointment> appointmentsOf(int patientId) throws AppException {
        return appointmentDao.findByPatient(patientId);
    }

    public int bookingWindowDays() throws AppException {
        return settingsDao.load().getBookingWindowDays();
    }

    /** Free slots grouped by date (sorted), from today up to {@code days} days ahead, never beyond the booking window. */
    public Map<LocalDate, List<Slot>> upcomingSlots(int professionalId, int days) throws AppException {
        Settings settings = settingsDao.load();
        int span = Math.min(days, settings.getBookingWindowDays());
        LocalDateTime now = LocalDateTime.now(clock);
        Map<LocalDate, List<Slot>> result = new TreeMap<>();
        for (int i = 0; i <= span; i++) {
            LocalDate date = now.toLocalDate().plusDays(i);
            List<Availability> windows = availabilityDao.findByProfessionalAndDay(professionalId, date.getDayOfWeek());
            if (windows.isEmpty()) {
                continue;
            }
            List<Slot> free = SlotCalculator.freeSlots(windows, settings.getSlotMinutes(),
                    new HashSet<>(appointmentDao.findBookedStarts(professionalId, date)), date, now);
            if (!free.isEmpty()) {
                result.put(date, free);
            }
        }
        return result;
    }

    /**
     * @param slotValue "yyyy-MM-dd|HH:mm", the value of the chosen radio button
     * @throws ValidationException      missing or badly formed input
     * @throws SlotUnavailableException the slot cannot be booked (taken, past, outside hours, limit reached)
     */
    public Appointment book(int patientId, int professionalId, String slotValue, String reason) throws AppException {
        Map<String, String> errors = new LinkedHashMap<>();
        String cleanReason = Validator.trim(reason);
        if (!Validator.lengthBetween(cleanReason, 5, 255)) {
            errors.put("reason", "Describe the reason in 5 to 255 characters.");
        }
        if (professionalDao.findActiveById(professionalId).isEmpty()) {
            errors.put("professionalId", "Choose a healthcare professional.");
        }
        LocalDate date = null;
        LocalTime start = null;
        String[] parts = slotValue == null ? new String[0] : slotValue.split("\\|");
        if (parts.length == 2) {
            try {
                date = LocalDate.parse(parts[0]);
                start = LocalTime.parse(parts[1]);
            } catch (DateTimeParseException e) {
                date = null;
            }
        }
        if (date == null || start == null) {
            errors.put("slot", "Choose one of the free slots.");
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }

        final LocalDate day = date;
        final LocalTime from = start;
        Settings settings = settingsDao.load();
        LocalDateTime now = LocalDateTime.now(clock);
        LocalTime to = from.plusMinutes(settings.getSlotMinutes());

        if (!day.atTime(from).isAfter(now)) {
            throw new SlotUnavailableException("That time has already passed.");
        }
        if (day.isAfter(now.toLocalDate().plusDays(settings.getBookingWindowDays()))) {
            throw new SlotUnavailableException("You can book up to " + settings.getBookingWindowDays() + " days ahead.");
        }
        boolean insideHours = !to.isAfter(from) ? false : availabilityDao.findByProfessionalAndDay(professionalId, day.getDayOfWeek())
                .stream().anyMatch(a -> !from.isBefore(a.getStartTime()) && !to.isAfter(a.getEndTime())
                        && Duration.between(a.getStartTime(), from).toMinutes() % settings.getSlotMinutes() == 0);
        if (!insideHours) {
            throw new SlotUnavailableException("That slot is not within the professional's working hours.");
        }

        return transactor.run(c -> {
            if (appointmentDao.slotTaken(c, professionalId, day, from)) {
                throw new SlotUnavailableException(professionalId, day, from);
            }
            if (appointmentDao.countBooked(c, professionalId, day) >= settings.getMaxBookingsPerDay()) {
                throw new SlotUnavailableException("This professional is fully booked on that day.");
            }
            if (appointmentDao.patientBusy(c, patientId, day, from)) {
                throw new SlotUnavailableException("You already have an appointment at that time.");
            }
            return appointmentDao.save(c,
                    new Appointment(0, patientId, professionalId, day, from, to, AppointmentStatus.BOOKED, cleanReason));
        });
    }

    /** BR-7: a patient may cancel their own BOOKED appointment until cancel_before_hours before it starts. */
    public void cancel(int patientId, int appointmentId) throws AppException {
        Appointment a = appointmentDao.findById(appointmentId).orElse(null);
        if (a == null || a.getPatientId() != patientId) {
            throw new AppException("Appointment not found.");
        }
        if (a.getStatus() != AppointmentStatus.BOOKED) {
            throw new AppException("Only booked appointments can be cancelled.");
        }
        int hours = settingsDao.load().getCancelBeforeHours();
        if (a.startsAt().minusHours(hours).isBefore(LocalDateTime.now(clock))) {
            throw new AppException("Appointments can be cancelled up to " + hours + " hours before they start.");
        }
        appointmentDao.updateStatus(appointmentId, AppointmentStatus.CANCELLED);
    }
}
