package com.healthconsult.servlet;

import com.healthconsult.model.Role;
import com.healthconsult.util.SessionKeys;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Context root. Logged-in users go to their role's dashboard, everyone else to /login.
 * The empty pattern maps only the root, so Tomcat's default servlet still serves css and images.
 */
@WebServlet(urlPatterns = {""})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String target = "/login";
        HttpSession session = req.getSession(false);
        if (session != null) {
            String roleName = (String) session.getAttribute(SessionKeys.ROLE);
            target = Role.fromName(roleName).map(Role::getDashboardPath).orElse("/login");
        }
        resp.sendRedirect(req.getContextPath() + target);
    }
}
