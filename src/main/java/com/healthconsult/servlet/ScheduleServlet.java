package com.healthconsult.servlet;

import com.healthconsult.dao.AvailabilityDaoImpl;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.service.ScheduleService;
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

/** F3: the professional's working hours. GET shows them, POST adds (default) or deletes (action=delete). */
@WebServlet("/pro/schedule")
public class ScheduleServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(ScheduleServlet.class.getName());
    private static final String VIEW = "/WEB-INF/views/pro/schedule.jsp";

    private final ScheduleService service;

    public ScheduleServlet() {
        this(new ScheduleService(new AvailabilityDaoImpl()));
    }

    ScheduleServlet(ScheduleService service) {
        this.service = service;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        show(req, resp, null, null);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        int professionalId = (Integer) req.getSession(false).getAttribute(SessionKeys.USER_ID);
        boolean delete = "delete".equals(req.getParameter("action"));
        try {
            if (delete) {
                service.remove(professionalId, Integer.parseInt(Validator.trim(req.getParameter("availabilityId"))));
                flash(req, "Working hours removed.");
            } else {
                service.add(professionalId, req.getParameter("day"), req.getParameter("start"), req.getParameter("end"));
                flash(req, "Working hours saved.");
            }
            resp.sendRedirect(req.getContextPath() + "/pro/schedule");
        } catch (ValidationException e) {
            show(req, resp, e.getErrors(), formValues(req));
        } catch (NumberFormatException e) {
            show(req, resp, Map.of("general", "That request was not valid."), null);
        } catch (AppException e) {
            LOG.log(Level.WARNING, "Schedule change failed", e);
            show(req, resp, Map.of("general", e.getMessage()), formValues(req));
        }
    }

    private void show(HttpServletRequest req, HttpServletResponse resp, Map<String, String> errors, Map<String, String> form)
            throws ServletException, IOException {
        int professionalId = (Integer) req.getSession(false).getAttribute(SessionKeys.USER_ID);
        try {
            req.setAttribute("hours", service.list(professionalId));
        } catch (AppException e) {
            LOG.log(Level.SEVERE, "Could not load working hours", e);
            errors = Map.of("general", "Could not load your working hours. Please try again.");
        }
        if (errors != null) {
            req.setAttribute("errors", errors);
        }
        if (form != null) {
            req.setAttribute("form", form);
        }
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private static Map<String, String> formValues(HttpServletRequest req) {
        return Map.of("day", Validator.trim(req.getParameter("day")),
                "start", Validator.trim(req.getParameter("start")),
                "end", Validator.trim(req.getParameter("end")));
    }

    private static void flash(HttpServletRequest req, String message) {
        req.getSession(false).setAttribute(SessionKeys.FLASH_SUCCESS, message);
    }
}
