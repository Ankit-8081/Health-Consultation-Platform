package com.healthconsult.model;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;

/**
 * Something that has weekly working hours and can be booked (rubric: interfaces).
 * Implemented by {@link HealthcareProfessional}. The default method means every implementer gets the
 * "is this person working at that time" check without copying it.
 */
public interface Schedulable {

    /** The weekly working-hour blocks (never null). */
    List<Availability> getWeeklyHours();

    /** Replaces the weekly working hours. */
    void setWeeklyHours(List<Availability> hours);

    /** True if {@code time} on {@code day} lies inside one of the working-hour blocks (end is exclusive). */
    default boolean isWorkingAt(DayOfWeek day, LocalTime time) {
        for (Availability block : getWeeklyHours()) {
            if (block.getDayOfWeek() == day && !time.isBefore(block.getStartTime()) && time.isBefore(block.getEndTime())) {
                return true;
            }
        }
        return false;
    }
}
