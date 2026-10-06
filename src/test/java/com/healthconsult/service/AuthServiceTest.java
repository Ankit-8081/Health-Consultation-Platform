package com.healthconsult.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.healthconsult.dao.UserDao;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.AuthException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Patient;
import com.healthconsult.model.Role;
import com.healthconsult.model.User;
import com.healthconsult.model.UserStatus;
import com.healthconsult.util.PasswordUtil;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

/** Uses an in-memory fake DAO, so no database is needed. */
class AuthServiceTest {

    private FakeUserDao dao;
    private AuthService service;

    @BeforeEach
    void setUp() {
        dao = new FakeUserDao();
        service = new AuthService(dao);
    }

    private User saved(String email, String rawPassword, UserStatus status) throws AppException {
        return dao.save(new Patient(0, "Priya Sharma", email, PasswordUtil.hash(rawPassword), null, status));
    }

    // ---------- login ----------

    @Test
    void loginSucceedsWithCorrectPassword() throws Exception {
        User existing = saved("priya@health.example", "Password@123", UserStatus.ACTIVE);
        assertSame(existing, service.login("priya@health.example", "Password@123"));
    }

    @Test
    void loginIgnoresCaseAndSpacesInTheEmail() throws Exception {
        User existing = saved("priya@health.example", "Password@123", UserStatus.ACTIVE);
        assertSame(existing, service.login("  Priya@Health.Example ", "Password@123"));
    }

    @Test
    void wrongPasswordAndUnknownEmailGiveTheSameMessage() throws Exception {
        saved("priya@health.example", "Password@123", UserStatus.ACTIVE);
        AuthException wrongPassword = assertThrows(AuthException.class,
                () -> service.login("priya@health.example", "WrongPass1"));
        AuthException unknownEmail = assertThrows(AuthException.class,
                () -> service.login("nobody@health.example", "Password@123"));
        assertEquals(AuthService.BAD_LOGIN, wrongPassword.getMessage());
        assertEquals(wrongPassword.getMessage(), unknownEmail.getMessage());
    }

    @Test
    void inactiveUserCannotLogIn() throws Exception {
        saved("priya@health.example", "Password@123", UserStatus.INACTIVE);
        AuthException e = assertThrows(AuthException.class,
                () -> service.login("priya@health.example", "Password@123"));
        assertEquals(AuthService.BAD_LOGIN, e.getMessage());
    }

    @Test
    void blankFieldsGiveFieldErrors() {
        ValidationException e = assertThrows(ValidationException.class, () -> service.login("  ", ""));
        assertTrue(e.getErrors().containsKey("email"));
        assertTrue(e.getErrors().containsKey("password"));
    }

    // ---------- registration ----------

    @Test
    void registerCreatesAnActivePatientWithAHashedPassword() throws Exception {
        Patient p = service.registerPatient("Neha Gupta", "Neha@Health.Example", "9000000006", "Password@123", "Password@123");
        assertEquals(Role.PATIENT, p.getRole());
        assertEquals(UserStatus.ACTIVE, p.getStatus());
        assertEquals("neha@health.example", p.getEmail());
        assertNotEquals("Password@123", p.getPasswordHash());
        assertTrue(PasswordUtil.matches("Password@123", p.getPasswordHash()));
        assertTrue(p.getUserId() > 0);
    }

    @Test
    void emptyPhoneIsAllowedAndStoredAsNull() throws Exception {
        Patient p = service.registerPatient("Neha Gupta", "neha@health.example", "  ", "Password@123", "Password@123");
        assertEquals(null, p.getPhone());
    }

    @Test
    void duplicateEmailIsRejected() throws Exception {
        saved("priya@health.example", "Password@123", UserStatus.ACTIVE);
        ValidationException e = assertThrows(ValidationException.class,
                () -> service.registerPatient("Priya Two", "PRIYA@health.example", null, "Password@123", "Password@123"));
        assertEquals("This email is already registered.", e.getErrors().get("email"));
    }

    @Test
    void invalidInputReportsEveryBadField() {
        ValidationException e = assertThrows(ValidationException.class,
                () -> service.registerPatient("A", "not-an-email", "123", "weak", "different"));
        assertTrue(e.getErrors().containsKey("name"));
        assertTrue(e.getErrors().containsKey("email"));
        assertTrue(e.getErrors().containsKey("phone"));
        assertTrue(e.getErrors().containsKey("password"));
        assertTrue(e.getErrors().containsKey("confirmPassword"));
        assertEquals(0, dao.findAllQuietly().size());
    }

    // ---------- fake ----------

    /** Minimal in-memory UserDao. */
    private static class FakeUserDao implements UserDao {
        private final Map<String, User> byEmail = new LinkedHashMap<>();
        private int nextId = 1;

        @Override public Optional<User> findByEmail(String email) { return Optional.ofNullable(byEmail.get(email)); }
        @Override public boolean existsByEmail(String email) { return byEmail.containsKey(email); }
        @Override public Optional<User> findById(Integer id) {
            return byEmail.values().stream().filter(u -> u.getUserId() == id).findFirst();
        }
        @Override public List<User> findAll() { return new ArrayList<>(byEmail.values()); }
        @Override public User save(User user) {
            user.setUserId(nextId++);
            byEmail.put(user.getEmail(), user);
            return user;
        }
        @Override public void update(User user) { byEmail.put(user.getEmail(), user); }
        @Override public void delete(Integer id) { byEmail.values().removeIf(u -> u.getUserId() == id); }

        List<User> findAllQuietly() { return findAll(); }
    }
}
