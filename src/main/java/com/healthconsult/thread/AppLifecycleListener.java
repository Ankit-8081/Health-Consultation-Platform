package com.healthconsult.thread;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/** Starts background threads when the app starts and stops them when it shuts down (no thread leaks). */
@WebListener
public class AppLifecycleListener implements ServletContextListener {

    private final ReminderScheduler reminderScheduler = new ReminderScheduler();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        reminderScheduler.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        reminderScheduler.stop();
    }
}
