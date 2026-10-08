package com.healthconsult.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Availability;
import java.time.DayOfWeek;
import java.time.LocalTime;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class ScheduleServiceTest {

    private Fakes.FakeAvailabilityDao dao;
    private ScheduleService service;

    @BeforeEach
    void setUp() {
        dao = new Fakes.FakeAvailabilityDao();
        service = new ScheduleService(dao);
    }

    @Test
    void addsValidWorkingHours() throws Exception {
        Availability a = service.add(2, "1", "09:00", "13:00");
        assertEquals(DayOfWeek.MONDAY, a.getDayOfWeek());
        assertEquals(LocalTime.of(9, 0), a.getStartTime());
        assertEquals(1, service.list(2).size());
    }

    @Test
    void rejectsBadDayAndMissingTimes() {
        ValidationException e = assertThrows(ValidationException.class, () -> service.add(2, "9", "", ""));
        assertTrue(e.getErrors().containsKey("day"));
        assertTrue(e.getErrors().containsKey("start"));
        assertTrue(e.getErrors().containsKey("end"));
    }

    @Test
    void rejectsEndNotAfterStart() {
        ValidationException e = assertThrows(ValidationException.class, () -> service.add(2, "1", "13:00", "09:00"));
        assertTrue(e.getErrors().containsKey("end"));
        assertThrows(ValidationException.class, () -> service.add(2, "1", "09:00", "09:00"));
    }

    @Test
    void rejectsOverlappingHoursOnTheSameDay() throws Exception {
        service.add(2, "1", "09:00", "13:00");
        ValidationException e = assertThrows(ValidationException.class, () -> service.add(2, "1", "12:00", "15:00"));
        assertTrue(e.getErrors().containsKey("start"));
    }

    @Test
    void allowsBackToBackHoursAndOtherDays() throws Exception {
        service.add(2, "1", "09:00", "11:00");
        service.add(2, "1", "11:00", "13:00");
        service.add(2, "2", "09:00", "13:00");
        assertEquals(3, service.list(2).size());
    }

    @Test
    void otherProfessionalsHoursDoNotClash() throws Exception {
        service.add(2, "1", "09:00", "13:00");
        service.add(3, "1", "09:00", "13:00");
        assertEquals(1, service.list(3).size());
    }

    @Test
    void removesOnlyYourOwnHours() throws Exception {
        Availability mine = service.add(2, "1", "09:00", "13:00");
        assertThrows(AppException.class, () -> service.remove(3, mine.getAvailabilityId()));
        assertEquals(1, service.list(2).size());
        service.remove(2, mine.getAvailabilityId());
        assertEquals(0, service.list(2).size());
    }

    @Test
    void removingAnUnknownIdIsRefused() {
        assertThrows(AppException.class, () -> service.remove(2, 999));
    }
}
