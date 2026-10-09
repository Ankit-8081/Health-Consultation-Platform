package com.healthconsult.thread;

import com.healthconsult.dao.ReminderDaoImpl;
import com.healthconsult.service.ReminderService;
import java.time.Clock;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Background job that runs once a minute (rubric: Threads). Each run asks {@link ReminderService} to log a
 * reminder for BOOKED appointments starting within the next hour. Any exception is caught, because an
 * uncaught one would silently stop all later runs. {@link #stop()} is called when the application stops.
 */
public final class ReminderScheduler {

    private static final Logger LOG = Logger.getLogger(ReminderScheduler.class.getName());

    private final Runnable job;
    private ScheduledExecutorService executor;

    /** Production use: the real reminder job on the real database. */
    public ReminderScheduler() {
        this(new ReminderService(new ReminderDaoImpl(), Clock.systemDefaultZone())::sendDueReminders);
    }

    /** For tests: run any job on the schedule. */
    public ReminderScheduler(Runnable job) {
        this.job = job;
    }

    public synchronized void start() {
        if (executor != null) {
            return;
        }
        executor = Executors.newSingleThreadScheduledExecutor(task -> {
            Thread t = new Thread(task, "reminder-scheduler");
            t.setDaemon(true);
            return t;
        });
        executor.scheduleAtFixedRate(this::tick, 0, 1, TimeUnit.MINUTES);
        LOG.info("ReminderScheduler started");
    }

    public synchronized void stop() {
        if (executor == null) {
            return;
        }
        executor.shutdown();
        try {
            if (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
                executor.shutdownNow();
            }
        } catch (InterruptedException e) {
            executor.shutdownNow();
            Thread.currentThread().interrupt();
        }
        executor = null;
        LOG.info("ReminderScheduler stopped");
    }

    private void tick() {
        try {
            job.run();
        } catch (RuntimeException e) {
            LOG.log(Level.SEVERE, "Reminder job failed", e);
        }
    }
}
