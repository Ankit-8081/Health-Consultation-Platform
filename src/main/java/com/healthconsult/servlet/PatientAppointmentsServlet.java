package com.healthconsult.servlet;

import com.healthconsult.exception.AppException;
import com.healthconsult.service.BookingService;
import com.healthconsult.util.SessionKeys;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/** F2: the patient's own appointments, newest first. */
@WebServlet("/patient/appointments")
public class PatientAppointmentsServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(PatientAppointmentsServlet.class.getName());

    private final BookingService service;

    public PatientAppointmentsServlet() {
        this(new BookingService());
    }

    PatientAppointmentsServlet(BookingService service) {
        this.service = service;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int patientId = (Integer) req.getSession(false).getAttribute(SessionKeys.USER_ID);
        try {
            req.setAttribute("appointments", service.appointmentsOf(patientId));
        } catch (AppException e) {
            LOG.log(Level.SEVERE, "Could not load appointments", e);
            req.setAttribute("errors", Map.of("general", "Could not load your appointments. Please try again."));
        }
        req.getRequestDispatcher("/WEB-INF/views/patient/appointments.jsp").forward(req, resp);
    }
}
