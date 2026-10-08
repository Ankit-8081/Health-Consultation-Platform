package com.healthconsult.service;

import com.healthconsult.model.Availability;
import com.healthconsult.model.Slot;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;

/** Turns working hours into bookable slots. Pure logic, no database (rubric: collections, Comparator). */
public final class SlotCalculator {

    private SlotCalculator() {
    }

    /**
     * Cuts each working-hours block into slots of {@code slotMinutes}, starting at the block's start time,
     * and drops slots that are already booked or have already started.
     *
     * @param windows the professional's working hours for that weekday
     * @param booked  start times already taken on that date
     */
    public static List<Slot> freeSlots(List<Availability> windows, int slotMinutes, Set<LocalTime> booked,
                                       LocalDate date, LocalDateTime now) {
        List<Slot> free = new ArrayList<>();
        if (slotMinutes <= 0) {
            return free;
        }
        for (Availability window : windows) {
            LocalTime start = window.getStartTime();
            while (true) {
                LocalTime end = start.plusMinutes(slotMinutes);
                boolean wrapped = !end.isAfter(start);
                if (wrapped || end.isAfter(window.getEndTime())) {
                    break;
                }
                if (!booked.contains(start) && date.atTime(start).isAfter(now)) {
                    free.add(new Slot(start, end));
                }
                start = end;
            }
        }
        free.sort(Comparator.comparing(Slot::getStart));
        return free;
    }
}
