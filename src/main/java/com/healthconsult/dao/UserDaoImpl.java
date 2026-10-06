package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Admin;
import com.healthconsult.model.HealthcareProfessional;
import com.healthconsult.model.Patient;
import com.healthconsult.model.Role;
import com.healthconsult.model.User;
import com.healthconsult.model.UserStatus;
import com.healthconsult.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC implementation. All SQL uses PreparedStatement. Methods that take a {@link Connection} let a service
 * run several DAO calls inside one {@code DBUtil.inTransaction(...)}; the versions without it open their own.
 */
public class UserDaoImpl implements UserDao {

    private static final Logger LOG = Logger.getLogger(UserDaoImpl.class.getName());
    private static final String COLUMNS = "user_id, full_name, email, password_hash, role, phone, status";
    private static final int MYSQL_DUPLICATE_ENTRY = 1062;
    private static final int MYSQL_FK_VIOLATION = 1451;

    // ---------- reads ----------

    @Override
    public Optional<User> findById(Integer id) throws AppException {
        String sql = "SELECT " + COLUMNS + " FROM users WHERE user_id = ?";
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return readOne(ps);
        } catch (SQLException e) {
            throw wrap("read the user", e);
        }
    }

    @Override
    public Optional<User> findByEmail(String email) throws AppException {
        try (Connection c = DBUtil.getConnection()) {
            return findByEmail(c, email);
        } catch (SQLException e) {
            throw wrap("close the connection", e);
        }
    }

    public Optional<User> findByEmail(Connection c, String email) throws AppException {
        String sql = "SELECT " + COLUMNS + " FROM users WHERE email = ?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            return readOne(ps);
        } catch (SQLException e) {
            throw wrap("read the user", e);
        }
    }

    @Override
    public boolean existsByEmail(String email) throws AppException {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT 1 FROM users WHERE email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw wrap("check the email address", e);
        }
    }

    @Override
    public List<User> findAll() throws AppException {
        String sql = "SELECT " + COLUMNS + " FROM users ORDER BY user_id";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<User> users = new ArrayList<>();
            while (rs.next()) {
                users.add(map(rs));
            }
            return users;
        } catch (SQLException e) {
            throw wrap("list users", e);
        }
    }

    // ---------- writes ----------

    /** Saves in one transaction: the users row, plus the patient_profiles row for a patient. */
    @Override
    public User save(User user) throws AppException {
        return DBUtil.inTransaction(c -> save(c, user));
    }

    public User save(Connection c, User user) throws AppException {
        if (user.getRole() == Role.PROFESSIONAL) {
            throw new DataAccessException("Professionals are created through the admin module.");
        }
        String sql = "INSERT INTO users (full_name, email, password_hash, role, phone, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole().name());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getStatus().name());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    user.setUserId(keys.getInt(1));
                }
            }
        } catch (SQLException e) {
            if (e.getErrorCode() == MYSQL_DUPLICATE_ENTRY) {
                throw new ValidationException("email", "This email is already registered.");
            }
            throw wrap("save the user", e);
        }
        if (user.getRole() == Role.PATIENT) {
            try (PreparedStatement ps = c.prepareStatement("INSERT INTO patient_profiles (patient_id) VALUES (?)")) {
                ps.setInt(1, user.getUserId());
                ps.executeUpdate();
            } catch (SQLException e) {
                throw wrap("save the patient profile", e);
            }
        }
        return user;
    }

    /** Updates name, email, phone and status. Passwords and roles are not changed here. */
    @Override
    public void update(User user) throws AppException {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, status = ? WHERE user_id = ?";
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getStatus().name());
            ps.setInt(5, user.getUserId());
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == MYSQL_DUPLICATE_ENTRY) {
                throw new ValidationException("email", "This email is already registered.");
            }
            throw wrap("update the user", e);
        }
    }

    /** BR-10: a user with appointments cannot be deleted, deactivate instead. */
    @Override
    public void delete(Integer id) throws AppException {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            if (e.getErrorCode() == MYSQL_FK_VIOLATION) {
                throw new AppException("This user has appointments and cannot be deleted. Deactivate the account instead.");
            }
            throw wrap("delete the user", e);
        }
    }

    // ---------- helpers ----------

    private static Optional<User> readOne(PreparedStatement ps) throws SQLException {
        try (ResultSet rs = ps.executeQuery()) {
            return rs.next() ? Optional.of(map(rs)) : Optional.empty();
        }
    }

    /** Builds the right subclass for the row's role. */
    private static User map(ResultSet rs) throws SQLException {
        int id = rs.getInt("user_id");
        String name = rs.getString("full_name");
        String email = rs.getString("email");
        String hash = rs.getString("password_hash");
        String phone = rs.getString("phone");
        UserStatus status = UserStatus.valueOf(rs.getString("status"));
        Role role = Role.valueOf(rs.getString("role"));
        return switch (role) {
            case ADMIN -> new Admin(id, name, email, hash, phone, status);
            case PROFESSIONAL -> new HealthcareProfessional(id, name, email, hash, phone, status);
            case PATIENT -> new Patient(id, name, email, hash, phone, status);
        };
    }

    private static DataAccessException wrap(String action, SQLException e) {
        LOG.log(Level.SEVERE, "Database error while trying to " + action, e);
        return new DataAccessException("Could not " + action + ".", e);
    }
}
