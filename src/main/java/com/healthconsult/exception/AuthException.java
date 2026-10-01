package com.healthconsult.exception;

/** Login failed, or the user is not allowed to do this. Keep messages generic ("Invalid email or password"). */
@SuppressWarnings("serial")
public class AuthException extends AppException {

    public AuthException(String message) {
        super(message);
    }
}
