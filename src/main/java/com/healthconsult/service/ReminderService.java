package com.healthconsult.service;

import com.healthconsult.dao.ReminderDao;
import com.healthconsult.exception.AppException;
import com.healthconsult.model.Appointment;
import java.time.Clock;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * The work done by the reminder thread once a minute: find BOOKED appointments that start within the
 * next {@value #WINDOW_MINUTES} minutes and log one reminder for each. A reminder is logged only once per
 * appointment, even though the job runs every minute. Reminders are shown in the log, not sent outside the
 * application (see SRS scope).
 */
public class ReminderService {

    public static final int WINDOW_MINUTES = 60;
    private static final Logger LOG = Logger.getLogger(ReminderService.class.getName());
    private static final DateTimeFormatter WHEN = DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");

    private final ReminderDao dao;
    private final Clock clock;
    /** Appointment ids already reminded. Thread-safe because the scheduler thread owns it. */
    private final Set<Integer> reminded = ConcurrentHashMap.newKeySet();

    public ReminderService(ReminderDao dao, Clock clock) {
        this.dao = dao;
        this.clock = clock;
    }

    /**
     * Logs a reminder for every appointment starting within the window that has not been reminded yet.
     * Never throws: a database problem is logged and the next run tries again.
     *
     * @return how many new reminders were logged
     */
    public int sendDueReminders() {
        LocalDateTime now = LocalDateTime.now(clock);
        List<Appointment> due;
        try {
            due = dao.findBookedStartingBetween(now, now.plusMinutes(WINDOW_MINUTES));
        } catch (AppException e) {
            LOG.log(Level.WARNING, "Reminder job could not read appointments: " + e.getMessage());
            return 0;
        }

        int sent = 0;
        Set<Integer> stillDue = new HashSet<>();
        for (Appointment a : due) {
            stillDue.add(a.getAppointmentId());
            if (reminded.add(a.getAppointmentId())) {
                LOG.info(describe(a));
                sent++;
            }
        }
        // Forget appointments that left the window (cancelled or already started) so the set stays small.
        reminded.retainAll(stillDue);
        return sent;
    }

    static String describe(Appointment a) {
        return "Reminder: " + a.getPatientName() + " has an appointment with " + a.getProfessionalName()
                + " at " + a.startsAt().format(WHEN) + " (appointment #" + a.getAppointmentId() + ")";
    }
}
