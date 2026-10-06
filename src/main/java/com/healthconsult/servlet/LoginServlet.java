package com.healthconsult.servlet;

import com.healthconsult.dao.UserDaoImpl;
import com.healthconsult.exception.AppException;
import com.healthconsult.exception.AuthException;
import com.healthconsult.exception.ValidationException;
import com.healthconsult.model.Role;
import com.healthconsult.model.User;
import com.healthconsult.service.AuthService;
import com.healthconsult.util.SessionKeys;
import com.healthconsult.util.Validator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * F1 login. GET shows the form (or sends a logged-in user to their dashboard). POST checks the
 * credentials, starts a NEW session and redirects to the role's dashboard (Post, Redirect, Get).
 * On a problem it forwards back to the form with request attributes "errors" and "form".
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(LoginServlet.class.getName());
    private static final String VIEW = "/WEB-INF/views/auth/login.jsp";

    private final AuthService authService;

    public LoginServlet() {
        this(new AuthService(new UserDaoImpl()));
    }

    LoginServlet(AuthService authService) {
        this.authService = authService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute(SessionKeys.USER_ID) != null) {
            Role role = Role.fromName((String) session.getAttribute(SessionKeys.ROLE)).orElse(null);
            if (role != null) {
                resp.sendRedirect(req.getContextPath() + role.getDashboardPath());
                return;
            }
        }
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        try {
            User user = authService.login(email, password);
            startSession(req, user);
            resp.sendRedirect(req.getContextPath() + user.getDashboardPath());
        } catch (ValidationException e) {
            showForm(req, resp, e.getErrors(), email);
        } catch (AuthException e) {
            showForm(req, resp, Map.of("general", e.getMessage()), email);
        } catch (AppException e) {
            LOG.log(Level.SEVERE, "Login failed", e);
            showForm(req, resp, Map.of("general", "Something went wrong. Please try again."), email);
        }
    }

    /** Drops any old session first, so a session id from before login can never be reused (session fixation). */
    private static void startSession(HttpServletRequest req, User user) {
        HttpSession old = req.getSession(false);
        if (old != null) {
            old.invalidate();
        }
        HttpSession session = req.getSession(true);
        session.setAttribute(SessionKeys.USER_ID, user.getUserId());
        session.setAttribute(SessionKeys.USER_NAME, user.getFullName());
        session.setAttribute(SessionKeys.ROLE, user.getRole().name());
    }

    private void showForm(HttpServletRequest req, HttpServletResponse resp, Map<String, String> errors, String email)
            throws ServletException, IOException {
        req.setAttribute("errors", errors);
        req.setAttribute("form", Map.of("email", Validator.trim(email)));
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }
}
