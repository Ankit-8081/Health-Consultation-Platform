package com.healthconsult.util;

import org.mindrot.jbcrypt.BCrypt;

/** BCrypt hashing. Passwords are never stored or logged in plain text. */
public final class PasswordUtil {

    private static final int COST = 10;

    private PasswordUtil() {
    }

    public static String hash(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(COST));
    }

    /** True only if the raw password matches the stored hash. Never throws for bad input. */
    public static boolean matches(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(rawPassword, storedHash);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}
