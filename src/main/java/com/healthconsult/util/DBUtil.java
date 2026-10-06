package com.healthconsult.util;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * JDBC connection and transaction helper.
 *
 * <p>Settings come from {@code db.properties} on the classpath (copy {@code db.properties.example}),
 * or from the environment variables DB_URL, DB_USER, DB_PASSWORD, which win when set.
 *
 * <p>Typical use in a service (booking is one transaction, rule BR-6):
 * <pre>{@code
 * DBUtil.inTransaction(conn -> {
 *     if (appointmentDao.slotTaken(conn, proId, date, start)) {
 *         throw new SlotUnavailableException(proId, date, start);
 *     }
 *     return appointmentDao.save(conn, appointment);
 * });
 * }</pre>
 */
public final class DBUtil {

    private static final Logger LOG = Logger.getLogger(DBUtil.class.getName());
    private static final Properties PROPS = loadProperties();

    // Inside Tomcat the driver jar is in WEB-INF/lib, where DriverManager does not find it on its own
    // ("No suitable driver found"). Loading the class by name registers it.
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            LOG.log(Level.SEVERE, "MySQL driver not found. Check that mysql-connector-j is in WEB-INF/lib.", e);
        }
    }

    private DBUtil() {
    }

    /** Work to run inside one transaction. */
    @FunctionalInterface
    public interface TxWork<T> {
        T run(Connection connection) throws SQLException, AppException;
    }

    private static Properties loadProperties() {
        Properties p = new Properties();
        try (InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                p.load(in);
            } else {
                LOG.warning("db.properties not found on the classpath, using environment variables only.");
            }
        } catch (IOException e) {
            LOG.log(Level.SEVERE, "Could not read db.properties", e);
        }
        return p;
    }

    private static String setting(String key, String envName) {
        String fromEnv = System.getenv(envName);
        if (fromEnv != null && !fromEnv.isBlank()) {
            return fromEnv;
        }
        return PROPS.getProperty(key);
    }

    /** Opens a new connection. Always use try-with-resources so it is closed. */
    public static Connection getConnection() throws DataAccessException {
        String url = setting("db.url", "DB_URL");
        String user = setting("db.user", "DB_USER");
        String password = setting("db.password", "DB_PASSWORD");
        if (url == null || user == null) {
            throw new DataAccessException(
                    "Database is not configured. Copy db.properties.example to db.properties and fill it in.");
        }
        try {
            return DriverManager.getConnection(url, user, password == null ? "" : password);
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Could not connect to the database", e);
            throw new DataAccessException("Could not connect to the database.", e);
        }
    }

    /**
     * Runs {@code work} in one transaction: commit if it returns, rollback if it throws.
     * {@link AppException}s (for example SlotUnavailableException) are rethrown unchanged after the rollback.
     */
    public static <T> T inTransaction(TxWork<T> work) throws AppException {
        try (Connection c = getConnection()) {
            c.setAutoCommit(false);
            try {
                T result = work.run(c);
                c.commit();
                return result;
            } catch (AppException | RuntimeException e) {
                rollbackQuietly(c);
                throw e;
            } catch (SQLException e) {
                rollbackQuietly(c);
                LOG.log(Level.SEVERE, "Transaction failed", e);
                throw new DataAccessException("The operation could not be completed.", e);
            }
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Database error", e);
            throw new DataAccessException("Database error.", e);
        }
    }

    private static void rollbackQuietly(Connection c) {
        try {
            c.rollback();
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Rollback failed", e);
        }
    }
}
