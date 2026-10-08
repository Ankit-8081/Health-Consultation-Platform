package com.healthconsult.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class RoleFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (path.startsWith("/doctor/") && !isUserInRole(req, "DOCTOR")) {
            res.sendError(403);
            return;
        }

        if (path.startsWith("/patient/") && !isUserInRole(req, "PATIENT")) {
            res.sendError(403);
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isUserInRole(HttpServletRequest req, String role) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        Object user = session.getAttribute("user");
        if (user == null) return false;
        return user.toString().toUpperCase().contains(role);
    }
}
