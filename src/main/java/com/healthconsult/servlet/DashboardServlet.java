package com.healthconsult.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Placeholder so that a login has somewhere to land. Maps the three dashboard URLs straight to
 * /WEB-INF/views/{role}/dashboard.jsp. RoleFilter has already checked the role by URL prefix.
 * Replace with real servlets (UI spec: PatientDashboardServlet etc.) when the dashboards get real data.
 */
@WebServlet(urlPatterns = {"/patient/dashboard", "/pro/dashboard", "/admin/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views" + req.getServletPath() + ".jsp").forward(req, resp);
    }
}
