package com.healthconsult.model;

/**
 * Something that owns health records (rubric: interfaces). Implemented by {@link Patient}.
 * Business rule BR-8: a patient can read only their own data, so ownership is checked in one place.
 */
public interface RecordHolder {

    /** The user id of the person the records belong to. */
    int getRecordOwnerId();

    /** True if {@code user} is the owner of these records. */
    default boolean isOwnedBy(User user) {
        return user != null && user.getUserId() == getRecordOwnerId();
    }
}
