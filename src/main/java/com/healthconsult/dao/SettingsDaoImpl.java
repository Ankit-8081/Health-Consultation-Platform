package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.model.Settings;
import com.healthconsult.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SettingsDaoImpl implements SettingsDao {

    private static final Logger LOG = Logger.getLogger(SettingsDaoImpl.class.getName());

    @Override
    public Settings load() throws AppException {
        Map<String, String> values = new HashMap<>();
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT setting_key, setting_value FROM system_settings");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                values.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Database error while reading settings", e);
            throw new DataAccessException("Could not read the settings.", e);
        }
        Settings d = Settings.defaults();
        return new Settings(
                intOf(values, "slot_minutes", d.getSlotMinutes()),
                intOf(values, "max_bookings_per_day", d.getMaxBookingsPerDay()),
                intOf(values, "booking_window_days", d.getBookingWindowDays()),
                intOf(values, "cancel_before_hours", d.getCancelBeforeHours()));
    }

    private static int intOf(Map<String, String> values, String key, int fallback) {
        try {
            int v = Integer.parseInt(values.getOrDefault(key, "").trim());
            return v >= 0 ? v : fallback;
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
