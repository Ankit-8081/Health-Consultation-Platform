package com.healthconsult.model;

public class Admin extends User {

    public Admin(int userId, String fullName, String email, String passwordHash, String phone, UserStatus status) {
        super(userId, fullName, email, passwordHash, phone, status);
    }

    @Override
    public Role getRole() {
        return Role.ADMIN;
    }

    @Override
    public String getDashboardPath() {
        return Role.ADMIN.getDashboardPath();
    }
}
