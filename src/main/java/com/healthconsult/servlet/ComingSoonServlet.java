package com.healthconsult.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 * Pages that are planned for Review 2. The sidebar already links to them, so instead of a 404 the user sees
 * "This feature is scheduled for Review 2". When a feature is built, give it its own servlet and delete its
 * URL from the pattern list below (two servlets on one URL stop Tomcat from starting).
 * RoleFilter still checks the role by URL prefix before this servlet runs.
 */
@WebServlet(urlPatterns = {
        "/patient/advice", "/patient/records", "/patient/profile",
        "/pro/consultations",
        "/admin/users", "/admin/appointments", "/admin/settings", "/admin/analytics"})
public class ComingSoonServlet extends HttpServlet {

    private static final Map<String, String> NAMES = Map.of(
            "/patient/advice", "Medical advice",
            "/patient/records", "Health records",
            "/patient/profile", "Profile",
            "/pro/consultations", "Consultations",
            "/admin/users", "User management",
            "/admin/appointments", "Appointment management",
            "/admin/settings", "System settings",
            "/admin/analytics", "Analytics");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getRequestURI().substring(req.getContextPath().length());
        req.setAttribute("featureName", NAMES.getOrDefault(path, "This page"));
        req.getRequestDispatcher("/WEB-INF/views/common/coming-soon.jsp").forward(req, resp);
    }
}
