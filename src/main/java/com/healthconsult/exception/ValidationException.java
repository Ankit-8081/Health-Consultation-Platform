package com.healthconsult.exception;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/** One or more form fields are invalid. Carries field name to message, for display under each field. */
@SuppressWarnings("serial")
public class ValidationException extends AppException {

    private final Map<String, String> errors;

    public ValidationException(Map<String, String> errors) {
        super("Please correct the highlighted fields.");
        this.errors = Collections.unmodifiableMap(new LinkedHashMap<>(errors));
    }

    public ValidationException(String field, String message) {
        this(Map.of(field, message));
    }

    public Map<String, String> getErrors() {
        return errors;
    }
}
