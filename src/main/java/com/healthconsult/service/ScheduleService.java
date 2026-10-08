package com.healthconsult.service;

import com.healthconsult.dao.AvailabilityDao;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Availability;
import com.healthconsult.util.Validator;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/** F3: a professional's weekly working hours (SRS FR-H1). */
public class ScheduleService {

    private final AvailabilityDao availabilityDao;

    public ScheduleService(AvailabilityDao availabilityDao) {
        this.availabilityDao = availabilityDao;
    }

    public List<Availability> list(int professionalId) throws AppException {
        return availabilityDao.findByProfessional(professionalId);
    }

    /**
     * @param day   "1" (Monday) to "7" (Sunday)
     * @param start "HH:mm"
     * @param end   "HH:mm"
     * @throws ValidationException bad input, end not after start, or overlapping an existing block of that day
     */
    public Availability add(int professionalId, String day, String start, String end) throws AppException {
        Map<String, String> errors = new LinkedHashMap<>();
        DayOfWeek dayOfWeek = null;
        try {
            dayOfWeek = DayOfWeek.of(Integer.parseInt(Validator.trim(day)));
        } catch (NumberFormatException | java.time.DateTimeException e) {
            errors.put("day", "Choose a day of the week.");
        }
        LocalTime startTime = parseTime(start, "start", "Enter a start time.", errors);
        LocalTime endTime = parseTime(end, "end", "Enter an end time.", errors);
        if (startTime != null && endTime != null && !endTime.isAfter(startTime)) {
            errors.put("end", "The end time must be after the start time.");
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }

        for (Availability existing : availabilityDao.findByProfessionalAndDay(professionalId, dayOfWeek)) {
            boolean overlaps = startTime.isBefore(existing.getEndTime()) && endTime.isAfter(existing.getStartTime());
            if (overlaps) {
                throw new ValidationException("start", "These hours overlap your hours "
                        + existing.getStartTime() + " to " + existing.getEndTime() + ".");
            }
        }
        return availabilityDao.save(new Availability(0, professionalId, dayOfWeek, startTime, endTime));
    }

    /** Removes one block. A professional can only remove their own. */
    public void remove(int professionalId, int availabilityId) throws AppException {
        Availability a = availabilityDao.findById(availabilityId).orElse(null);
        if (a == null || a.getProfessionalId() != professionalId) {
            throw new AppException("Working hours not found.");
        }
        availabilityDao.delete(availabilityId);
    }

    private static LocalTime parseTime(String value, String field, String message, Map<String, String> errors) {
        try {
            return LocalTime.parse(Validator.trim(value));
        } catch (DateTimeParseException e) {
            errors.put(field, message);
            return null;
        }
    }
}
