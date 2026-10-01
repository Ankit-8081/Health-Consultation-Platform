package com.healthconsult.exception;

/** A JDBC call failed. Wraps the original {@link java.sql.SQLException}; log it, show a friendly message. */
@SuppressWarnings("serial")
public class DataAccessException extends AppException {

    public DataAccessException(String message) {
        super(message);
    }

    public DataAccessException(String message, Throwable cause) {
        super(message, cause);
    }
}
