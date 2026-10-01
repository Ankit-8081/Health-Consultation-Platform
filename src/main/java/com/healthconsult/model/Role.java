package com.healthconsult.model;

import java.util.Optional;

/**
 * The three user roles. Each role owns a URL prefix, which {@code RoleFilter} uses for access control,
 * and a dashboard path used after login.
 */
public enum Role {
    ADMIN("/admin/", "/admin/dashboard"),
    PROFESSIONAL("/pro/", "/pro/dashboard"),
    PATIENT("/patient/", "/patient/dashboard");

    private final String urlPrefix;
    private final String dashboardPath;

    Role(String urlPrefix, String dashboardPath) {
        this.urlPrefix = urlPrefix;
        this.dashboardPath = dashboardPath;
    }

    public String getUrlPrefix() {
        return urlPrefix;
    }

    public String getDashboardPath() {
        return dashboardPath;
    }

    /** Which role owns this path, e.g. "/pro/schedule" gives PROFESSIONAL. Empty for shared or public paths. */
    public static Optional<Role> forPath(String path) {
        if (path == null) {
            return Optional.empty();
        }
        String p = path.endsWith("/") ? path : path + "/";
        for (Role r : values()) {
            if (p.startsWith(r.urlPrefix)) {
                return Optional.of(r);
            }
        }
        return Optional.empty();
    }

    /** Safe version of valueOf: null or unknown text gives empty. */
    public static Optional<Role> fromName(String name) {
        if (name == null) {
            return Optional.empty();
        }
        try {
            return Optional.of(valueOf(name));
        } catch (IllegalArgumentException e) {
            return Optional.empty();
        }
    }
}
