package com.healthconsult.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.healthconsult.model.Availability;
import com.healthconsult.model.Slot;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.junit.jupiter.api.Test;

class SlotCalculatorTest {

    private static final LocalDate MONDAY = LocalDate.of(2026, 10, 12);
    private static final LocalDateTime EARLY = LocalDateTime.of(2026, 10, 11, 8, 0);

    private static Availability window(String from, String to) {
        return new Availability(1, 2, DayOfWeek.MONDAY, LocalTime.parse(from), LocalTime.parse(to));
    }

    @Test
    void cutsAWindowIntoSlots() {
        List<Slot> slots = SlotCalculator.freeSlots(List.of(window("09:00", "11:00")), 30, Set.of(), MONDAY, EARLY);
        assertEquals(4, slots.size());
        assertEquals(LocalTime.of(9, 0), slots.get(0).getStart());
        assertEquals(LocalTime.of(10, 30), slots.get(3).getStart());
        assertEquals(LocalTime.of(11, 0), slots.get(3).getEnd());
    }

    @Test
    void skipsBookedSlots() {
        Set<LocalTime> booked = new HashSet<>(List.of(LocalTime.of(9, 30)));
        List<Slot> slots = SlotCalculator.freeSlots(List.of(window("09:00", "11:00")), 30, booked, MONDAY, EARLY);
        assertEquals(3, slots.size());
        assertTrue(slots.stream().noneMatch(s -> s.getStart().equals(LocalTime.of(9, 30))));
    }

    @Test
    void skipsSlotsThatAlreadyStarted() {
        LocalDateTime now = LocalDateTime.of(2026, 10, 12, 9, 45);
        List<Slot> slots = SlotCalculator.freeSlots(List.of(window("09:00", "11:00")), 30, Set.of(), MONDAY, now);
        assertEquals(LocalTime.of(10, 0), slots.get(0).getStart());
        assertEquals(2, slots.size());
    }

    @Test
    void dropsAPartialSlotAtTheEndOfTheWindow() {
        List<Slot> slots = SlotCalculator.freeSlots(List.of(window("09:00", "10:15")), 30, Set.of(), MONDAY, EARLY);
        assertEquals(2, slots.size());
    }

    @Test
    void mergesSeveralWindowsInTimeOrder() {
        List<Slot> slots = SlotCalculator.freeSlots(
                List.of(window("14:00", "15:00"), window("09:00", "10:00")), 30, Set.of(), MONDAY, EARLY);
        assertEquals(4, slots.size());
        assertEquals(LocalTime.of(9, 0), slots.get(0).getStart());
        assertEquals(LocalTime.of(14, 30), slots.get(3).getStart());
    }

    @Test
    void zeroSlotLengthGivesNothing() {
        assertTrue(SlotCalculator.freeSlots(List.of(window("09:00", "11:00")), 0, Set.of(), MONDAY, EARLY).isEmpty());
    }
}
