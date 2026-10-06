package com.healthconsult.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class ValidatorTest {

    @Test
    void trimHandlesNull() {
        assertEquals("", Validator.trim(null));
        assertEquals("a b", Validator.trim("  a b "));
    }

    @Test
    void emailRules() {
        assertTrue(Validator.isValidEmail("priya@health.example"));
        assertFalse(Validator.isValidEmail("priya@"));
        assertFalse(Validator.isValidEmail("not an email"));
        assertFalse(Validator.isValidEmail(null));
        assertFalse(Validator.isValidEmail("a".repeat(120) + "@x.com"));
    }

    @Test
    void phoneRules() {
        assertTrue(Validator.isValidPhone("9000000004"));
        assertFalse(Validator.isValidPhone("12345"));
        assertFalse(Validator.isValidPhone("90000000AB"));
        assertFalse(Validator.isValidPhone(null));
    }

    @Test
    void passwordRules() {
        assertTrue(Validator.isStrongPassword("Password@123"));
        assertFalse(Validator.isStrongPassword("short1"));
        assertFalse(Validator.isStrongPassword("onlyletters"));
        assertFalse(Validator.isStrongPassword("12345678"));
        assertFalse(Validator.isStrongPassword("a1".repeat(33)));
        assertFalse(Validator.isStrongPassword(null));
    }
}
