package com.healthconsult.util;

import com.healthconsult.exception.AppException;

/** Runs work in one database transaction. Services take this so tests can swap in a fake. */
public interface Transactor {
    <T> T run(DBUtil.TxWork<T> work) throws AppException;
}
