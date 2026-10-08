package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.model.Settings;

public interface SettingsDao {

    /** Reads system_settings. Missing or invalid values fall back to {@link Settings#defaults()}. */
    Settings load() throws AppException;
}
