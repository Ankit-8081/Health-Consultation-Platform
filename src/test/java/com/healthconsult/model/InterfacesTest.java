package com.healthconsult.model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;
import org.junit.jupiter.api.Test;

class InterfacesTest {

    private static HealthcareProfessional doctor() {
        HealthcareProfessional p = new HealthcareProfessional(2, "Dr. Asha", "a@x.com", "h", null, UserStatus.ACTIVE);
        p.setWeeklyHours(List.of(
                new Availability(1, 2, DayOfWeek.MONDAY, LocalTime.of(9, 0), LocalTime.of(13, 0)),
                new Availability(2, 2, DayOfWeek.WEDNESDAY, LocalTime.of(14, 0), LocalTime.of(18, 0))));
        return p;
    }

    @Test
    void professionalIsSchedulable() {
        Schedulable s = doctor();
        assertTrue(s.isWorkingAt(DayOfWeek.MONDAY, LocalTime.of(9, 0)));
        assertTrue(s.isWorkingAt(DayOfWeek.MONDAY, LocalTime.of(12, 59)));
        assertTrue(s.isWorkingAt(DayOfWeek.WEDNESDAY, LocalTime.of(15, 30)));
    }

    @Test
    void endTimeIsExclusiveAndOtherDaysAreClosed() {
        Schedulable s = doctor();
        assertFalse(s.isWorkingAt(DayOfWeek.MONDAY, LocalTime.of(13, 0)));
        assertFalse(s.isWorkingAt(DayOfWeek.MONDAY, LocalTime.of(8, 59)));
        assertFalse(s.isWorkingAt(DayOfWeek.TUESDAY, LocalTime.of(10, 0)));
    }

    @Test
    void weeklyHoursAreCopiedAndNeverNull() {
        HealthcareProfessional p = doctor();
        p.setWeeklyHours(null);
        assertEquals(0, p.getWeeklyHours().size());
        assertFalse(p.isWorkingAt(DayOfWeek.MONDAY, LocalTime.of(10, 0)));
    }

    @Test
    void patientOwnsOnlyTheirOwnRecords() {
        Patient priya = new Patient(4, "Priya", "p@x.com", "h", null, UserStatus.ACTIVE);
        Patient arjun = new Patient(5, "Arjun", "a@x.com", "h", null, UserStatus.ACTIVE);
        RecordHolder holder = priya;
        assertEquals(4, holder.getRecordOwnerId());
        assertTrue(holder.isOwnedBy(priya));
        assertFalse(holder.isOwnedBy(arjun));
        assertFalse(holder.isOwnedBy(null));
    }
}
