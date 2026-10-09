package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.model.Appointment;
import com.healthconsult.model.AppointmentStatus;
import com.healthconsult.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/** JDBC for the reminder job. PreparedStatement only. */
public class ReminderDaoImpl implements ReminderDao {

    private static final Logger LOG = Logger.getLogger(ReminderDaoImpl.class.getName());

    @Override
    public List<Appointment> findBookedStartingBetween(LocalDateTime from, LocalDateTime to) throws AppException {
        String sql = "SELECT a.appointment_id, a.patient_id, a.professional_id, a.appointment_date, a.start_time, "
                + "a.end_time, a.status, a.reason, p.full_name AS patient_name, d.full_name AS professional_name "
                + "FROM appointments a "
                + "JOIN users p ON p.user_id = a.patient_id "
                + "JOIN users d ON d.user_id = a.professional_id "
                + "WHERE a.status = 'BOOKED' AND TIMESTAMP(a.appointment_date, a.start_time) >= ? "
                + "AND TIMESTAMP(a.appointment_date, a.start_time) < ? "
                + "ORDER BY a.appointment_date, a.start_time";
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(from));
            ps.setTimestamp(2, Timestamp.valueOf(to));
            try (ResultSet rs = ps.executeQuery()) {
                List<Appointment> rows = new ArrayList<>();
                while (rs.next()) {
                    Appointment a = new Appointment(rs.getInt("appointment_id"), rs.getInt("patient_id"),
                            rs.getInt("professional_id"), rs.getDate("appointment_date").toLocalDate(),
                            rs.getTime("start_time").toLocalTime(), rs.getTime("end_time").toLocalTime(),
                            AppointmentStatus.valueOf(rs.getString("status")), rs.getString("reason"));
                    a.setPatientName(rs.getString("patient_name"));
                    a.setProfessionalName(rs.getString("professional_name"));
                    rows.add(a);
                }
                return rows;
            }
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Database error while reading upcoming appointments", e);
            throw new DataAccessException("Could not read the upcoming appointments.", e);
        }
    }
}
