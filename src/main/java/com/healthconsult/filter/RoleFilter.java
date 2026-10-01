package com.healthconsult.filter;

import com.healthconsult.model.Role;
import com.healthconsult.util.SessionKeys;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

/**
 * Role check by URL prefix: /admin/** needs ADMIN, /pro/** needs PROFESSIONAL, /patient/** needs PATIENT.
 * Other URLs are not restricted here. A wrong role gets a 403 page. Runs after AuthFilter, so the
 * user is already logged in when this filter sees the request.
 */
public class RoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        Optional<Role> required = Role.forPath(path);
        if (required.isEmpty()) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        Role actual = null;
        if (session != null) {
            actual = Role.fromName((String) session.getAttribute(SessionKeys.ROLE)).orElse(null);
        }
        if (actual != required.get()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        chain.doFilter(req, res);
    }
}
