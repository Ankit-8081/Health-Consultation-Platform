package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Availability;
import com.healthconsult.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.DayOfWeek;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/** JDBC for the {@code availability} table. All SQL uses PreparedStatement. */
public class AvailabilityDaoImpl implements AvailabilityDao {

    private static final Logger LOG = Logger.getLogger(AvailabilityDaoImpl.class.getName());
    private static final String COLUMNS = "availability_id, professional_id, day_of_week, start_time, end_time";
    private static final int MYSQL_DUPLICATE_ENTRY = 1062;

    @FunctionalInterface
    private interface Binder {
        void bind(PreparedStatement ps) throws SQLException;
    }

    @Override
    public List<Availability> findByProfessional(int professionalId) throws AppException {
        return query("SELECT " + COLUMNS + " FROM availability WHERE professional_id = ? ORDER BY day_of_week, start_time",
                ps -> ps.setInt(1, professionalId));
    }

    @Override
    public List<Availability> findByProfessionalAndDay(int professionalId, DayOfWeek day) throws AppException {
        return query("SELECT " + COLUMNS + " FROM availability WHERE professional_id = ? AND day_of_week = ? ORDER BY start_time",
                ps -> {
                    ps.setInt(1, professionalId);
                    ps.setInt(2, day.getValue());
                });
    }

    @Override
    public Optional<Availability> findById(Integer id) throws AppException {
        List<Availability> rows = query("SELECT " + COLUMNS + " FROM availability WHERE availability_id = ?", ps -> ps.setInt(1, id));
        return rows.isEmpty() ? Optional.empty() : Optional.of(rows.get(0));
    }

    @Override
    public List<Availability> findAll() throws AppException {
        return query("SELECT " + COLUMNS + " FROM availability ORDER BY professional_id, day_of_week, start_time", ps -> { });
    }

    @Override
    public Availability save(Availability a) throws AppException {
        String sql = "INSERT INTO availability (professional_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)";
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getProfessionalId());
            ps.setInt(2, a.getDayNumber());
            ps.setTime(3, Time.valueOf(a.getStartTime()));
            ps.setTime(4, Time.valueOf(a.getEndTime()));
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    a.setAvailabilityId(keys.getInt(1));
                }
            }
            return a;
        } catch (SQLException e) {
            if (e.getErrorCode() == MYSQL_DUPLICATE_ENTRY) {
                throw new ValidationException("start", "Working hours starting at that time already exist on that day.");
            }
            throw wrap("save the working hours", e);
        }
    }

    @Override
    public void update(Availability a) throws AppException {
        String sql = "UPDATE availability SET day_of_week = ?, start_time = ?, end_time = ? WHERE availability_id = ?";
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, a.getDayNumber());
            ps.setTime(2, Time.valueOf(a.getStartTime()));
            ps.setTime(3, Time.valueOf(a.getEndTime()));
            ps.setInt(4, a.getAvailabilityId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw wrap("update the working hours", e);
        }
    }

    @Override
    public void delete(Integer id) throws AppException {
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement("DELETE FROM availability WHERE availability_id = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw wrap("delete the working hours", e);
        }
    }

    private List<Availability> query(String sql, Binder binder) throws AppException {
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            binder.bind(ps);
            try (ResultSet rs = ps.executeQuery()) {
                List<Availability> rows = new ArrayList<>();
                while (rs.next()) {
                    rows.add(new Availability(rs.getInt("availability_id"), rs.getInt("professional_id"),
                            DayOfWeek.of(rs.getInt("day_of_week")),
                            rs.getTime("start_time").toLocalTime(), rs.getTime("end_time").toLocalTime()));
                }
                return rows;
            }
        } catch (SQLException e) {
            throw wrap("read the working hours", e);
        }
    }

    private static DataAccessException wrap(String action, SQLException e) {
        LOG.log(Level.SEVERE, "Database error while trying to " + action, e);
        return new DataAccessException("Could not " + action + ".", e);
    }
}
