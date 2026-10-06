package com.healthconsult.model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class UserTest {

    private static User make(Role role) {
        return switch (role) {
            case ADMIN -> new Admin(1, "A", "a@x.com", "h", null, UserStatus.ACTIVE);
            case PROFESSIONAL -> new HealthcareProfessional(2, "P", "p@x.com", "h", null, UserStatus.ACTIVE);
            case PATIENT -> new Patient(3, "S", "s@x.com", "h", null, UserStatus.ACTIVE);
        };
    }

    @Test
    void eachSubclassKnowsItsRoleAndDashboard() {
        for (Role r : Role.values()) {
            User u = make(r);
            assertEquals(r, u.getRole());
            assertEquals(r.getDashboardPath(), u.getDashboardPath());
        }
    }

    @Test
    void canAccessFollowsTheRoleOfThePath() {
        User patient = make(Role.PATIENT);
        assertTrue(patient.canAccess("/patient/book"));
        assertFalse(patient.canAccess("/admin/users"));
        assertFalse(patient.canAccess("/pro/schedule"));
        assertTrue(patient.canAccess("/messages"));
    }

    @Test
    void toStringNeverShowsThePasswordHash() {
        assertFalse(make(Role.PATIENT).toString().contains("h,"));
        assertTrue(make(Role.PATIENT).toString().contains("s@x.com"));
    }
}
