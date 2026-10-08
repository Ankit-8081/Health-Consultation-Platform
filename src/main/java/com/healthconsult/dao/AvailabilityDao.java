package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.model.Availability;
import java.time.DayOfWeek;
import java.util.List;

public interface AvailabilityDao extends GenericDao<Availability, Integer> {

    /** All working hours of one professional, ordered by day then start time. */
    List<Availability> findByProfessional(int professionalId) throws AppException;

    /** Working hours of one professional on one weekday, ordered by start time. */
    List<Availability> findByProfessionalAndDay(int professionalId, DayOfWeek day) throws AppException;
}
