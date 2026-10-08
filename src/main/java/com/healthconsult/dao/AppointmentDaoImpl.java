package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.exception.SlotUnavailableException;
import com.healthconsult.model.Appointment;
import com.healthconsult.model.AppointmentStatus;
import com.healthconsult.util.DBUtil;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/** JDBC for the {@code appointments} table. All SQL uses PreparedStatement. */
public class AppointmentDaoImpl implements AppointmentDao {

    private static final Logger LOG = Logger.getLogger(AppointmentDaoImpl.class.getName());
    private static final String COLUMNS =
            "a.appointment_id, a.patient_id, a.professional_id, a.appointment_date, a.start_time, a.end_time, a.status, a.reason";
    private static final int MYSQL_DUPLICATE_ENTRY = 1062;

    @FunctionalInterface
    private interface Binder {
        void bind(PreparedStatement ps) throws SQLException;
    }

    // ---------- reads ----------

    @Override
    public List<LocalTime> findBookedStarts(int professionalId, LocalDate date) throws AppException {
        String sql = "SELECT start_time FROM appointments WHERE professional_id = ? AND appointment_date = ? AND status = 'BOOKED'";
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, professionalId);
            ps.setDate(2, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                List<LocalTime> starts = new ArrayList<>();
                while (rs.next()) {
                    starts.add(rs.getTime("start_time").toLocalTime());
                }
                return starts;
            }
        } catch (SQLException e) {
            throw wrap("read the booked slots", e);
        }
    }

    @Override
    public List<Appointment> findByPatient(int patientId) throws AppException {
        String sql = "SELECT " + COLUMNS + ", u.full_name AS professional_name FROM appointments a "
                + "JOIN users u ON u.user_id = a.professional_id WHERE a.patient_id = ? "
                + "ORDER BY a.appointment_date DESC, a.start_time DESC";
        return query(sql, ps -> ps.setInt(1, patientId));
    }

    @Override
    public Optional<Appointment> findById(Integer id) throws AppException {
        String sql = "SELECT " + COLUMNS + ", u.full_name AS professional_name FROM appointments a "
                + "JOIN users u ON u.user_id = a.professional_id WHERE a.appointment_id = ?";
        List<Appointment> rows = query(sql, ps -> ps.setInt(1, id));
        return rows.isEmpty() ? Optional.empty() : Optional.of(rows.get(0));
    }

    @Override
    public List<Appointment> findAll() throws AppException {
        String sql = "SELECT " + COLUMNS + ", u.full_name AS professional_name FROM appointments a "
                + "JOIN users u ON u.user_id = a.professional_id ORDER BY a.appointment_date DESC, a.start_time DESC";
        return query(sql, ps -> { });
    }

    // ---------- transaction parts (use the caller's connection) ----------

    @Override
    public boolean slotTaken(Connection c, int professionalId, LocalDate date, LocalTime start) throws AppException {
        String sql = "SELECT appointment_id FROM appointments WHERE professional_id = ? AND appointment_date = ? "
                + "AND start_time = ? AND status = 'BOOKED' FOR UPDATE";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, professionalId);
            ps.setDate(2, Date.valueOf(date));
            ps.setTime(3, Time.valueOf(start));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw wrap("check the slot", e);
        }
    }

    @Override
    public int countBooked(Connection c, int professionalId, LocalDate date) throws AppException {
        String sql = "SELECT COUNT(*) FROM appointments WHERE professional_id = ? AND appointment_date = ? AND status = 'BOOKED'";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, professionalId);
            ps.setDate(2, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            throw wrap("count the bookings", e);
        }
    }

    @Override
    public boolean patientBusy(Connection c, int patientId, LocalDate date, LocalTime start) throws AppException {
        String sql = "SELECT 1 FROM appointments WHERE patient_id = ? AND appointment_date = ? AND start_time = ? AND status = 'BOOKED'";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ps.setDate(2, Date.valueOf(date));
            ps.setTime(3, Time.valueOf(start));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw wrap("check the patient's bookings", e);
        }
    }

    @Override
    public Appointment save(Connection c, Appointment a) throws AppException {
        String sql = "INSERT INTO appointments (patient_id, professional_id, appointment_date, start_time, end_time, status, reason) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getPatientId());
            ps.setInt(2, a.getProfessionalId());
            ps.setDate(3, Date.valueOf(a.getDate()));
            ps.setTime(4, Time.valueOf(a.getStartTime()));
            ps.setTime(5, Time.valueOf(a.getEndTime()));
            ps.setString(6, a.getStatus().name());
            ps.setString(7, a.getReason());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    a.setAppointmentId(keys.getInt(1));
                }
            }
            return a;
        } catch (SQLException e) {
            if (e.getErrorCode() == MYSQL_DUPLICATE_ENTRY) {
                // the UNIQUE key on live slots is the last safety net if two requests race
                throw new SlotUnavailableException(a.getProfessionalId(), a.getDate(), a.getStartTime());
            }
            throw wrap("save the appointment", e);
        }
    }

    // ---------- writes with their own connection ----------

    @Override
    public Appointment save(Appointment a) throws AppException {
        return DBUtil.inTransaction(c -> save(c, a));
    }

    @Override
    public void update(Appointment a) throws AppException {
        updateStatus(a.getAppointmentId(), a.getStatus());
    }

    @Override
    public void updateStatus(int appointmentId, AppointmentStatus status) throws AppException {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE appointments SET status = ? WHERE appointment_id = ?")) {
            ps.setString(1, status.name());
            ps.setInt(2, appointmentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw wrap("update the appointment", e);
        }
    }

    /** Appointments are cancelled, never deleted, so the history stays complete. */
    @Override
    public void delete(Integer id) throws AppException {
        throw new AppException("Appointments are cancelled, not deleted.");
    }

    // ---------- helpers ----------

    private List<Appointment> query(String sql, Binder binder) throws AppException {
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            binder.bind(ps);
            try (ResultSet rs = ps.executeQuery()) {
                List<Appointment> rows = new ArrayList<>();
                while (rs.next()) {
                    Appointment a = new Appointment(rs.getInt("appointment_id"), rs.getInt("patient_id"),
                            rs.getInt("professional_id"), rs.getDate("appointment_date").toLocalDate(),
                            rs.getTime("start_time").toLocalTime(), rs.getTime("end_time").toLocalTime(),
                            AppointmentStatus.valueOf(rs.getString("status")), rs.getString("reason"));
                    a.setProfessionalName(rs.getString("professional_name"));
                    rows.add(a);
                }
                return rows;
            }
        } catch (SQLException e) {
            throw wrap("read the appointments", e);
        }
    }

    private static DataAccessException wrap(String action, SQLException e) {
        LOG.log(Level.SEVERE, "Database error while trying to " + action, e);
        return new DataAccessException("Could not " + action + ".", e);
    }
}
