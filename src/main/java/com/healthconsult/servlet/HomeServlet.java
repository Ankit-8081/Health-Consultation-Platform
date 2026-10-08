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
 * Context root. Logged-in users go to their role's dashboard, visitors see the landing page.
 * The empty pattern maps only the root, so Tomcat's default servlet still serves css and images.
 */
@WebServlet(urlPatterns = {""})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            String roleName = (String) session.getAttribute(SessionKeys.ROLE);
            var role = Role.fromName(roleName);
            if (role.isPresent()) {
                resp.sendRedirect(req.getContextPath() + role.get().getDashboardPath());
                return;
            }
        }
        req.getRequestDispatcher("/WEB-INF/views/common/landing.jsp").forward(req, resp);
    }
}
