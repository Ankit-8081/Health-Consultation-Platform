package com.healthconsult.thread;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Background job that runs once a minute (rubric: Threads). The job body is a placeholder; the owner
 * (DevOps/QA) replaces {@link #tick()} with: find BOOKED appointments starting soon and record a
 * reminder. Any exception is caught, because an uncaught one would silently stop all later runs.
 */
public final class ReminderScheduler {

    private static final Logger LOG = Logger.getLogger(ReminderScheduler.class.getName());

    private ScheduledExecutorService executor;

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
            LOG.fine("Reminder tick (placeholder, no job yet)");
        } catch (RuntimeException e) {
            LOG.log(Level.SEVERE, "Reminder job failed", e);
        }
    }
}
