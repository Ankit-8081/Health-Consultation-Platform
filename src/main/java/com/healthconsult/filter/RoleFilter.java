package com.healthconsult.filter;

import com.healthconsult.util.SessionKeys;
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

        if (path.startsWith("/admin/")) {
            if (!isUserInRole(req, "ADMIN")) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } else if (path.startsWith("/doctor/")) {
            if (!isUserInRole(req, "DOCTOR")) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } else if (path.startsWith("/patient/")) {
            if (!isUserInRole(req, "PATIENT")) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isUserInRole(HttpServletRequest req, String role) {
        HttpSession session = req.getSession(false);
        if (session == null) return false;
        Object userRole = session.getAttribute(SessionKeys.ROLE);
        if (userRole == null) return false;
        return userRole.toString().toUpperCase().contains(role);
    }
}
