package com.healthconsult.util;

import com.healthconsult.exception.AppException;

/** The real thing: delegates to {@link DBUtil#inTransaction}. */
public class DbTransactor implements Transactor {
    @Override
    public <T> T run(DBUtil.TxWork<T> work) throws AppException {
        return DBUtil.inTransaction(work);
    }
}
