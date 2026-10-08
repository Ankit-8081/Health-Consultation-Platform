package com.healthconsult.servlet;

import com.healthconsult.exception.AppException;
import com.healthconsult.service.BookingService;
import com.healthconsult.util.SessionKeys;
import com.healthconsult.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/** POST only. Cancels one of the logged-in patient's own appointments, then redirects back to the list. */
@WebServlet("/patient/appointments/cancel")
public class CancelAppointmentServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(CancelAppointmentServlet.class.getName());

    private final BookingService service;

    public CancelAppointmentServlet() {
        this(new BookingService());
    }

    CancelAppointmentServlet(BookingService service) {
        this.service = service;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        int patientId = (Integer) session.getAttribute(SessionKeys.USER_ID);
        try {
            service.cancel(patientId, Integer.parseInt(Validator.trim(req.getParameter("appointmentId"))));
            session.setAttribute(SessionKeys.FLASH_SUCCESS, "Appointment cancelled.");
        } catch (NumberFormatException e) {
            session.setAttribute(SessionKeys.FLASH_ERROR, "That request was not valid.");
        } catch (AppException e) {
            LOG.log(Level.INFO, "Cancel refused: " + e.getMessage());
            session.setAttribute(SessionKeys.FLASH_ERROR, e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/patient/appointments");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/patient/appointments");
    }
}
