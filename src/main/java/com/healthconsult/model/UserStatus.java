package com.healthconsult.model;

/** Matches the {@code users.status} ENUM in schema.sql. Only ACTIVE users can log in. */
public enum UserStatus {
    ACTIVE,
    INACTIVE
}
