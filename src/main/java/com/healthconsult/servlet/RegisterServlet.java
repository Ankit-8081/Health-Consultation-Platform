package com.healthconsult.servlet;

import com.healthconsult.dao.UserDaoImpl;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.service.AuthService;
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
 * F1 patient registration. Fields: name, email, phone (optional), password, confirmPassword.
 * Only patients can register themselves. On success: flash message, redirect to /login (PRG).
 * On a problem it forwards back to the form with "errors" and "form" (never the passwords).
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(RegisterServlet.class.getName());
    private static final String VIEW = "/WEB-INF/views/auth/register.jsp";

    private final AuthService authService;

    public RegisterServlet() {
        this(new AuthService(new UserDaoImpl()));
    }

    RegisterServlet(AuthService authService) {
        this.authService = authService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        try {
            authService.registerPatient(name, email, phone, req.getParameter("password"), req.getParameter("confirmPassword"));
            req.getSession(true).setAttribute(SessionKeys.FLASH_SUCCESS, "Account created. Please sign in.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (ValidationException e) {
            showForm(req, resp, e.getErrors(), name, email, phone);
        } catch (AppException e) {
            LOG.log(Level.SEVERE, "Registration failed", e);
            showForm(req, resp, Map.of("general", "Something went wrong. Please try again."), name, email, phone);
        }
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, Map<String, String> errors,
                          String name, String email, String phone) throws ServletException, IOException {
        req.setAttribute("errors", errors);
        req.setAttribute("form", Map.of(
                "name", Validator.trim(name),
                "email", Validator.trim(email),
                "phone", Validator.trim(phone)));
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }
}
