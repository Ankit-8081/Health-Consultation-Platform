package com.healthconsult.model;

public class Patient extends User {

    public Patient(int userId, String fullName, String email, String passwordHash, String phone, UserStatus status) {
        super(userId, fullName, email, passwordHash, phone, status);
    }

    @Override
    public Role getRole() {
        return Role.PATIENT;
    }

    @Override
    public String getDashboardPath() {
        return Role.PATIENT.getDashboardPath();
    }
}
