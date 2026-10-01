package com.healthconsult.exception;

import java.time.LocalDate;
import java.time.LocalTime;

/** The requested consultation slot is taken, outside working hours, or otherwise not bookable (BR-1 to BR-5). */
@SuppressWarnings("serial")
public class SlotUnavailableException extends AppException {

    public SlotUnavailableException(String message) {
        super(message);
    }

    public SlotUnavailableException(int professionalId, LocalDate date, LocalTime start) {
        super("The slot on " + date + " at " + start + " is no longer available.");
    }
}
