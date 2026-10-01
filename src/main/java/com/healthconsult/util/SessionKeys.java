package com.healthconsult.util;

/** Names of the attributes stored in the HttpSession. One place, so nobody mistypes a string. */
public final class SessionKeys {

    public static final String USER_ID = "userId";
    public static final String USER_NAME = "userName";
    /** Stores {@code Role.name()}, for example "PATIENT". */
    public static final String ROLE = "role";
    /** One-time messages shown after a redirect, then removed. */
    public static final String FLASH_SUCCESS = "flashSuccess";
    public static final String FLASH_ERROR = "flashError";

    private SessionKeys() {
    }
}
