package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.model.Appointment;
import com.healthconsult.model.AppointmentStatus;
import java.sql.Connection;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Appointments. The methods that take a {@link Connection} run inside the caller's transaction
 * (see BookingService); the others open their own connection.
 */
public interface AppointmentDao extends GenericDao<Appointment, Integer> {

    /** Start times already BOOKED for this professional on this date. */
    List<LocalTime> findBookedStarts(int professionalId, LocalDate date) throws AppException;

    /** A patient's appointments, newest first, with the professional's name filled in. */
    List<Appointment> findByPatient(int patientId) throws AppException;

    /** True if a BOOKED appointment exists for this slot. Locks the rows (SELECT ... FOR UPDATE). */
    boolean slotTaken(Connection c, int professionalId, LocalDate date, LocalTime start) throws AppException;

    int countBooked(Connection c, int professionalId, LocalDate date) throws AppException;

    /** True if this patient already has a BOOKED appointment at that date and time (with anyone). */
    boolean patientBusy(Connection c, int patientId, LocalDate date, LocalTime start) throws AppException;

    Appointment save(Connection c, Appointment appointment) throws AppException;

    void updateStatus(int appointmentId, AppointmentStatus status) throws AppException;
}
