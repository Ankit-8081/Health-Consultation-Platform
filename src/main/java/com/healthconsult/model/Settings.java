package com.healthconsult.model;

/** The admin-configurable settings that booking depends on (table system_settings). */
public class Settings {

    private final int slotMinutes;
    private final int maxBookingsPerDay;
    private final int bookingWindowDays;
    private final int cancelBeforeHours;

    public Settings(int slotMinutes, int maxBookingsPerDay, int bookingWindowDays, int cancelBeforeHours) {
        this.slotMinutes = slotMinutes;
        this.maxBookingsPerDay = maxBookingsPerDay;
        this.bookingWindowDays = bookingWindowDays;
        this.cancelBeforeHours = cancelBeforeHours;
    }

    /** Same values as seed.sql, used when a setting is missing. */
    public static Settings defaults() {
        return new Settings(30, 10, 30, 2);
    }

    public int getSlotMinutes() { return slotMinutes; }
    public int getMaxBookingsPerDay() { return maxBookingsPerDay; }
    public int getBookingWindowDays() { return bookingWindowDays; }
    public int getCancelBeforeHours() { return cancelBeforeHours; }
}
