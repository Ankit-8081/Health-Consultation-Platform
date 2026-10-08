package com.healthconsult.service;

import com.healthconsult.dao.UserDao;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.AuthException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Patient;
import com.healthconsult.model.User;
import com.healthconsult.model.UserStatus;
import com.healthconsult.util.PasswordUtil;
import com.healthconsult.util.Validator;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

/** Login and patient registration (SRS FR-C1, FR-C2, BR-9). No HTTP types here. */
public class AuthService {

    /** One message for every login failure, so an attacker cannot tell which part was wrong. */
    static final String BAD_LOGIN = "Invalid email or password.";

    /** A valid BCrypt hash, checked when the email is unknown so both cases take about the same time. */
    private static final String DUMMY_HASH = "$2a$10$rORbczMcuah1F4I8AYRMK.SImuc2t9xovuWZYCT6LPXc7X8w.QeoC";

    private final UserDao userDao;

    public AuthService(UserDao userDao) {
        this.userDao = userDao;
    }

    /**
     * @return the logged-in user
     * @throws ValidationException blank or badly formed fields
     * @throws AuthException       wrong email or password, or an inactive account
     */
    public User login(String email, String password) throws AppException {
        String cleanEmail = Validator.trim(email).toLowerCase(Locale.ROOT);
        Map<String, String> errors = new LinkedHashMap<>();
        if (cleanEmail.isEmpty()) {
            errors.put("email", "Enter your email address.");
        } else if (!Validator.isValidEmail(cleanEmail)) {
            errors.put("email", "Enter a valid email address.");
        }
        if (password == null || password.isEmpty()) {
            errors.put("password", "Enter your password.");
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }

        Optional<User> found = userDao.findByEmail(cleanEmail);
        if (found.isEmpty()) {
            PasswordUtil.matches(password, DUMMY_HASH);
            throw new AuthException(BAD_LOGIN);
        }
        User user = found.get();
        boolean passwordOk = PasswordUtil.matches(password, user.getPasswordHash());
        if (!passwordOk || user.getStatus() != UserStatus.ACTIVE) {
            throw new AuthException(BAD_LOGIN);
        }
        return user;
    }

    /**
     * Creates a PATIENT account. Only patients can register themselves (professionals are created by an admin).
     *
     * @throws ValidationException one or more fields are invalid, or the email is already registered
     */
    public Patient registerPatient(String name, String email, String phone, String password, String confirmPassword)
            throws AppException {
        String cleanName = Validator.trim(name);
        String cleanEmail = Validator.trim(email).toLowerCase(Locale.ROOT);
        String cleanPhone = Validator.trim(phone);

        Map<String, String> errors = new LinkedHashMap<>();
        if (!Validator.lengthBetween(cleanName, 2, 100)) {
            errors.put("name", "Enter your full name (2 to 100 characters).");
        }
        if (cleanEmail.isEmpty()) {
            errors.put("email", "Enter your email address.");
        } else if (!Validator.isValidEmail(cleanEmail)) {
            errors.put("email", "Enter a valid email address.");
        }
        if (!cleanPhone.isEmpty() && !Validator.isValidPhone(cleanPhone)) {
            errors.put("phone", "Enter a 10 digit phone number, or leave it empty.");
        }
        if (!Validator.isStrongPassword(password)) {
            errors.put("password", "Use 8 to 64 characters with at least one letter and one number.");
        }
        if (password == null || !password.equals(confirmPassword)) {
            errors.put("confirmPassword", "The two passwords do not match.");
        }
        if (!errors.containsKey("email") && userDao.existsByEmail(cleanEmail)) {
            errors.put("email", "This email is already registered.");
        }
        if (!errors.isEmpty()) {
            throw new ValidationException(errors);
        }

        Patient patient = new Patient(0, cleanName, cleanEmail, PasswordUtil.hash(password),
                cleanPhone.isEmpty() ? null : cleanPhone, UserStatus.ACTIVE);
        userDao.save(patient);
        return patient;
    }
}
