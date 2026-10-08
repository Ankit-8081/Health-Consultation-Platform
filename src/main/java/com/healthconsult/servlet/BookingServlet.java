package com.healthconsult.servlet;

import com.healthconsult.exception.AppException;
import com.healthconsult.exception.SlotUnavailableException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Appointment;
import com.healthconsult.service.BookingService;
import com.healthconsult.util.SessionKeys;
import com.healthconsult.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * F2: book a consultation. GET (optionally with professionalId) shows the professionals and the free slots.
 * POST books the chosen slot inside one transaction, then redirects (PRG) to the patient's appointments.
 */
@WebServlet("/patient/book")
public class BookingServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(BookingServlet.class.getName());
    private static final String VIEW = "/WEB-INF/views/patient/book.jsp";
    private static final int DAYS_SHOWN = 7;

    private final BookingService service;

    public BookingServlet() {
        this(new BookingService());
    }

    BookingServlet(BookingService service) {
        this.service = service;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        show(req, resp, parseId(req.getParameter("professionalId")), null, null);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        int patientId = (Integer) req.getSession(false).getAttribute(SessionKeys.USER_ID);
        Integer professionalId = parseId(req.getParameter("professionalId"));
        Map<String, String> form = Map.of("slot", Validator.trim(req.getParameter("slot")),
                "reason", Validator.trim(req.getParameter("reason")));
        try {
            if (professionalId == null) {
                throw new ValidationException("professionalId", "Choose a healthcare professional.");
            }
            Appointment a = service.book(patientId, professionalId, req.getParameter("slot"), req.getParameter("reason"));
            req.getSession(false).setAttribute(SessionKeys.FLASH_SUCCESS,
                    "Booked: " + a.getDate() + " at " + a.getStartTime() + ".");
            resp.sendRedirect(req.getContextPath() + "/patient/appointments");
        } catch (ValidationException e) {
            show(req, resp, professionalId, e.getErrors(), form);
        } catch (SlotUnavailableException e) {
            show(req, resp, professionalId, Map.of("general", e.getMessage()), form);
        } catch (AppException e) {
            LOG.log(Level.SEVERE, "Booking failed", e);
            show(req, resp, professionalId, Map.of("general", "Something went wrong. Please try again."), form);
        }
    }

    private void show(HttpServletRequest req, HttpServletResponse resp, Integer professionalId,
                      Map<String, String> errors, Map<String, String> form) throws ServletException, IOException {
        try {
            req.setAttribute("professionals", service.professionals());
            if (professionalId != null) {
                req.setAttribute("selectedProfessionalId", professionalId);
                req.setAttribute("slots", service.upcomingSlots(professionalId, DAYS_SHOWN));
                req.setAttribute("daysShown", DAYS_SHOWN);
            }
        } catch (AppException e) {
            LOG.log(Level.SEVERE, "Could not load the booking page", e);
            errors = Map.of("general", "Could not load the booking page. Please try again.");
        }
        if (errors != null) {
            req.setAttribute("errors", errors);
        }
        if (form != null) {
            req.setAttribute("form", form);
        }
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private static Integer parseId(String value) {
        try {
            return Integer.valueOf(Validator.trim(value));
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
