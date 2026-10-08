package com.healthconsult.dao;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.model.ProfessionalSummary;
import com.healthconsult.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProfessionalDaoImpl implements ProfessionalDao {

    private static final Logger LOG = Logger.getLogger(ProfessionalDaoImpl.class.getName());
    private static final String BASE =
            "SELECT u.user_id, u.full_name, p.specialization FROM users u "
                    + "JOIN professional_profiles p ON p.professional_id = u.user_id "
                    + "WHERE u.status = 'ACTIVE' AND u.role = 'PROFESSIONAL'";

    @Override
    public List<ProfessionalSummary> findAllActive() throws AppException {
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(BASE + " ORDER BY u.full_name");
             ResultSet rs = ps.executeQuery()) {
            List<ProfessionalSummary> rows = new ArrayList<>();
            while (rs.next()) {
                rows.add(map(rs));
            }
            return rows;
        } catch (SQLException e) {
            throw wrap(e);
        }
    }

    @Override
    public Optional<ProfessionalSummary> findActiveById(int professionalId) throws AppException {
        try (Connection c = DBUtil.getConnection(); PreparedStatement ps = c.prepareStatement(BASE + " AND u.user_id = ?")) {
            ps.setInt(1, professionalId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? Optional.of(map(rs)) : Optional.empty();
            }
        } catch (SQLException e) {
            throw wrap(e);
        }
    }

    private static ProfessionalSummary map(ResultSet rs) throws SQLException {
        return new ProfessionalSummary(rs.getInt("user_id"), rs.getString("full_name"), rs.getString("specialization"));
    }

    private static DataAccessException wrap(SQLException e) {
        LOG.log(Level.SEVERE, "Database error while reading professionals", e);
        return new DataAccessException("Could not read the professionals.", e);
    }
}
