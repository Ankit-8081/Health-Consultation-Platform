package com.healthconsult.exception;

/**
 * Base class of all application-specific checked exceptions.
 * Servlets catch it and show {@link #getMessage()} to the user. Never put stack traces on a page.
 */
@SuppressWarnings("serial")
public class AppException extends Exception {

    public AppException(String message) {
        super(message);
    }

    public AppException(String message, Throwable cause) {
        super(message, cause);
    }
}
