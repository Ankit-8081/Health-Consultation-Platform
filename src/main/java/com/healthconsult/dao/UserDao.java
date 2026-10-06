package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.model.User;
import java.util.Optional;

/** Data access for the {@code users} table (and the profile row that belongs to a new patient). */
public interface UserDao extends GenericDao<User, Integer> {

    /** Looks up by email. The caller passes the email already trimmed and lower-cased. */
    Optional<User> findByEmail(String email) throws AppException;

    boolean existsByEmail(String email) throws AppException;
}
