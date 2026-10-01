package com.healthconsult.model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Optional;
import org.junit.jupiter.api.Test;

class RoleTest {

    @Test
    void mapsPathsToRoles() {
        assertEquals(Optional.of(Role.ADMIN), Role.forPath("/admin/users"));
        assertEquals(Optional.of(Role.PROFESSIONAL), Role.forPath("/pro/schedule"));
        assertEquals(Optional.of(Role.PATIENT), Role.forPath("/patient/book"));
        assertEquals(Optional.of(Role.PATIENT), Role.forPath("/patient"));
    }

    @Test
    void sharedAndPublicPathsHaveNoRole() {
        assertTrue(Role.forPath("/login").isEmpty());
        assertTrue(Role.forPath("/messages").isEmpty());
        assertTrue(Role.forPath("/administrator/x").isEmpty());
        assertTrue(Role.forPath(null).isEmpty());
    }

    @Test
    void fromNameIsSafe() {
        assertEquals(Optional.of(Role.PATIENT), Role.fromName("PATIENT"));
        assertTrue(Role.fromName(null).isEmpty());
        assertTrue(Role.fromName("DOCTOR").isEmpty());
    }

    @Test
    void everyRoleHasADashboardInsideItsPrefix() {
        for (Role r : Role.values()) {
            assertTrue(r.getDashboardPath().startsWith(r.getUrlPrefix()));
        }
    }
}
