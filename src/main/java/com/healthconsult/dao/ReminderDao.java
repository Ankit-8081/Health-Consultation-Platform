package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.model.Appointment;
import java.time.LocalDateTime;
import java.util.List;

/** Read-only query used by the background reminder job. */
public interface ReminderDao {

    /**
     * BOOKED appointments that start at or after {@code from} and before {@code to}, soonest first,
     * with both the patient's and the professional's name filled in.
     */
    List<Appointment> findBookedStartingBetween(LocalDateTime from, LocalDateTime to) throws AppException;
}
