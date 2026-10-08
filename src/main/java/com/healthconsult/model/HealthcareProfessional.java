package com.healthconsult.model;

public class HealthcareProfessional extends User {

    public HealthcareProfessional(int userId, String fullName, String email, String passwordHash, String phone, UserStatus status) {
        super(userId, fullName, email, passwordHash, phone, status);
    }

    @Override
    public Role getRole() {
        return Role.PROFESSIONAL;
    }

    @Override
    public String getDashboardPath() {
        return Role.PROFESSIONAL.getDashboardPath();
    }
}
