package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import java.util.List;
import java.util.Optional;

/**
 * Basic CRUD contract that every DAO implements. SQL lives only in DAO classes, always through
 * {@link java.sql.PreparedStatement}.
 *
 * <p>Convention: each DAO method also has an overload taking a {@link java.sql.Connection}, so a service
 * can run several DAO calls inside one {@code DBUtil.inTransaction(...)}.
 *
 * @param <T>  entity type
 * @param <ID> primary key type
 */
public interface GenericDao<T, ID> {

    Optional<T> findById(ID id) throws AppException;

    List<T> findAll() throws AppException;

    /** Inserts the entity and returns it with its generated id filled in. */
    T save(T entity) throws AppException;

    void update(T entity) throws AppException;

    void delete(ID id) throws AppException;
}
