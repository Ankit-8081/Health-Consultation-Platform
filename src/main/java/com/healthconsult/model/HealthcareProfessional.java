package com.healthconsult.model;

import java.util.ArrayList;
import java.util.List;

public class HealthcareProfessional extends User implements Schedulable {

    private List<Availability> weeklyHours = new ArrayList<>();

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

    @Override
    public List<Availability> getWeeklyHours() {
        return List.copyOf(weeklyHours);
    }

    @Override
    public void setWeeklyHours(List<Availability> hours) {
        this.weeklyHours = hours == null ? new ArrayList<>() : new ArrayList<>(hours);
    }
}
