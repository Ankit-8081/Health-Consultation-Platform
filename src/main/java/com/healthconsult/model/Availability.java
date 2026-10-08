package com.healthconsult.model;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.time.format.TextStyle;
import java.util.Locale;

/** One block of weekly working hours of a professional, e.g. Monday 09:00 to 13:00. */
public class Availability {

    private int availabilityId;
    private final int professionalId;
    private final DayOfWeek dayOfWeek;
    private final LocalTime startTime;
    private final LocalTime endTime;

    public Availability(int availabilityId, int professionalId, DayOfWeek dayOfWeek, LocalTime startTime, LocalTime endTime) {
        this.availabilityId = availabilityId;
        this.professionalId = professionalId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public int getAvailabilityId() { return availabilityId; }
    public void setAvailabilityId(int availabilityId) { this.availabilityId = availabilityId; }
    public int getProfessionalId() { return professionalId; }
    public DayOfWeek getDayOfWeek() { return dayOfWeek; }
    public LocalTime getStartTime() { return startTime; }
    public LocalTime getEndTime() { return endTime; }

    /** 1 = Monday ... 7 = Sunday, same as the database column. */
    public int getDayNumber() { return dayOfWeek.getValue(); }

    public String getDayName() { return dayOfWeek.getDisplayName(TextStyle.FULL, Locale.ENGLISH); }
}
