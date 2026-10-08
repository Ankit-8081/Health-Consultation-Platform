package com.healthconsult.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/** A booked consultation. Matches the {@code appointments} table. */
public class Appointment {

    private int appointmentId;
    private final int patientId;
    private final int professionalId;
    private final LocalDate date;
    private final LocalTime startTime;
    private final LocalTime endTime;
    private AppointmentStatus status;
    private final String reason;
    /** Filled by queries that join the users table, for display only. */
    private String professionalName;
    private String patientName;

    public Appointment(int appointmentId, int patientId, int professionalId, LocalDate date, LocalTime startTime,
                       LocalTime endTime, AppointmentStatus status, String reason) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.professionalId = professionalId;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.reason = reason;
    }

    public LocalDateTime startsAt() { return date.atTime(startTime); }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }
    public int getPatientId() { return patientId; }
    public int getProfessionalId() { return professionalId; }
    public LocalDate getDate() { return date; }
    public LocalTime getStartTime() { return startTime; }
    public LocalTime getEndTime() { return endTime; }
    public AppointmentStatus getStatus() { return status; }
    public void setStatus(AppointmentStatus status) { this.status = status; }
    public String getReason() { return reason; }
    public String getProfessionalName() { return professionalName; }
    public void setProfessionalName(String professionalName) { this.professionalName = professionalName; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
}
