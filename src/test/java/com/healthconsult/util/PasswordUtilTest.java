package com.healthconsult.util;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

class PasswordUtilTest {

    @Test
    void hashedPasswordMatchesOnlyTheOriginal() {
        String hash = PasswordUtil.hash("Password@123");
        assertTrue(PasswordUtil.matches("Password@123", hash));
        assertFalse(PasswordUtil.matches("password@123", hash));
    }

    @Test
    void sameInputGivesDifferentHashes() {
        assertNotEquals(PasswordUtil.hash("Password@123"), PasswordUtil.hash("Password@123"));
    }

    @Test
    void badInputNeverThrows() {
        assertFalse(PasswordUtil.matches(null, "x"));
        assertFalse(PasswordUtil.matches("x", null));
        assertFalse(PasswordUtil.matches("x", "not-a-bcrypt-hash"));
    }
}
