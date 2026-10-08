package com.healthconsult.util;

import java.util.regex.Pattern;

/** Server-side input rules from docs/UI_Handoff_Spec.md section 5. Pure functions, easy to test. */
public final class Validator {

    private static final Pattern EMAIL = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern PHONE = Pattern.compile("^[0-9]{10}$");

    private Validator() {
    }

    /** Null becomes an empty string, otherwise the trimmed text. */
    public static String trim(String s) {
        return s == null ? "" : s.trim();
    }

    public static boolean lengthBetween(String s, int min, int max) {
        return s != null && s.length() >= min && s.length() <= max;
    }

    public static boolean isValidEmail(String s) {
        return s != null && s.length() <= 120 && EMAIL.matcher(s).matches();
    }

    /** Ten digits. Callers treat an empty phone as "not provided" before calling this. */
    public static boolean isValidPhone(String s) {
        return s != null && PHONE.matcher(s).matches();
    }

    /** 8 to 64 characters with at least one letter and one digit. */
    public static boolean isStrongPassword(String s) {
        return lengthBetween(s, 8, 64)
                && s.chars().anyMatch(Character::isLetter)
                && s.chars().anyMatch(Character::isDigit);
    }
}
