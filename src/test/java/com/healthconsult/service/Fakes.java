package com.healthconsult.service;

import com.healthconsult.dao.AppointmentDao;
import com.healthconsult.dao.AvailabilityDao;
import com.healthconsult.dao.ProfessionalDao;
import com.healthconsult.dao.SettingsDao;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.DataAccessException;
import com.healthconsult.model.Appointment;
import com.healthconsult.model.AppointmentStatus;
import com.healthconsult.model.Availability;
import com.healthconsult.model.ProfessionalSummary;
import com.healthconsult.model.Settings;
import com.healthconsult.util.DBUtil;
import com.healthconsult.util.Transactor;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;

/** In-memory stand-ins for the DAOs, so the service tests need no database. */
final class Fakes {

    private Fakes() {
    }

    static class FakeAvailabilityDao implements AvailabilityDao {
        final List<Availability> rows = new CopyOnWriteArrayList<>();
        private final AtomicInteger ids = new AtomicInteger(1);

        @Override public List<Availability> findByProfessional(int professionalId) {
            List<Availability> out = new ArrayList<>();
            for (Availability a : rows) if (a.getProfessionalId() == professionalId) out.add(a);
            return out;
        }
        @Override public List<Availability> findByProfessionalAndDay(int professionalId, DayOfWeek day) {
            List<Availability> out = new ArrayList<>();
            for (Availability a : rows) if (a.getProfessionalId() == professionalId && a.getDayOfWeek() == day) out.add(a);
            return out;
        }
        @Override public Optional<Availability> findById(Integer id) {
            for (Availability a : rows) if (a.getAvailabilityId() == id) return Optional.of(a);
            return Optional.empty();
        }
        @Override public List<Availability> findAll() { return new ArrayList<>(rows); }
        @Override public Availability save(Availability a) { a.setAvailabilityId(ids.getAndIncrement()); rows.add(a); return a; }
        @Override public void update(Availability a) { }
        @Override public void delete(Integer id) { rows.removeIf(a -> a.getAvailabilityId() == id); }

        Availability add(int pro, DayOfWeek d, String from, String to) {
            return save(new Availability(0, pro, d, LocalTime.parse(from), LocalTime.parse(to)));
        }
    }

    static class FakeAppointmentDao implements AppointmentDao {
        final List<Appointment> rows = new CopyOnWriteArrayList<>();
        private final AtomicInteger ids = new AtomicInteger(1);

        private boolean live(Appointment a) { return a.getStatus() == AppointmentStatus.BOOKED; }

        @Override public List<LocalTime> findBookedStarts(int pro, LocalDate date) {
            List<LocalTime> out = new ArrayList<>();
            for (Appointment a : rows) if (live(a) && a.getProfessionalId() == pro && a.getDate().equals(date)) out.add(a.getStartTime());
            return out;
        }
        @Override public List<Appointment> findByPatient(int patientId) {
            List<Appointment> out = new ArrayList<>();
            for (Appointment a : rows) if (a.getPatientId() == patientId) out.add(a);
            return out;
        }
        @Override public boolean slotTaken(Connection c, int pro, LocalDate date, LocalTime start) {
            return findBookedStarts(pro, date).contains(start);
        }
        @Override public int countBooked(Connection c, int pro, LocalDate date) { return findBookedStarts(pro, date).size(); }
        @Override public boolean patientBusy(Connection c, int patientId, LocalDate date, LocalTime start) {
            for (Appointment a : rows) if (live(a) && a.getPatientId() == patientId && a.getDate().equals(date) && a.getStartTime().equals(start)) return true;
            return false;
        }
        @Override public Appointment save(Connection c, Appointment a) { a.setAppointmentId(ids.getAndIncrement()); rows.add(a); return a; }
        @Override public Appointment save(Appointment a) { return save(null, a); }
        @Override public void updateStatus(int id, AppointmentStatus status) {
            for (Appointment a : rows) if (a.getAppointmentId() == id) a.setStatus(status);
        }
        @Override public Optional<Appointment> findById(Integer id) {
            for (Appointment a : rows) if (a.getAppointmentId() == id) return Optional.of(a);
            return Optional.empty();
        }
        @Override public List<Appointment> findAll() { return new ArrayList<>(rows); }
        @Override public void update(Appointment a) { updateStatus(a.getAppointmentId(), a.getStatus()); }
        @Override public void delete(Integer id) throws AppException { throw new AppException("not supported"); }
    }

    static class FakeProfessionalDao implements ProfessionalDao {
        final List<ProfessionalSummary> rows = new ArrayList<>();
        @Override public List<ProfessionalSummary> findAllActive() { return new ArrayList<>(rows); }
        @Override public Optional<ProfessionalSummary> findActiveById(int id) {
            for (ProfessionalSummary p : rows) if (p.getId() == id) return Optional.of(p);
            return Optional.empty();
        }
    }

    static class FakeSettingsDao implements SettingsDao {
        Settings settings = Settings.defaults();
        @Override public Settings load() { return settings; }
    }

    /** Runs the work with no real connection. {@code lock} makes transactions run one at a time, like row locks would. */
    static class FakeTransactor implements Transactor {
        private final Object lock = new Object();
        @Override public <T> T run(DBUtil.TxWork<T> work) throws AppException {
            synchronized (lock) {
                try {
                    return work.run(null);
                } catch (SQLException e) {
                    throw new DataAccessException("fake db error", e);
                }
            }
        }
    }
}
