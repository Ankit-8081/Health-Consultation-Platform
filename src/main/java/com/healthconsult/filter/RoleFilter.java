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
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String servletPath = httpRequest.getServletPath();
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();

        String path = "";
        if (servletPath != null && !servletPath.isEmpty()) {
            path = servletPath;
        } else if (uri != null) {
            if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
                path = uri.substring(contextPath.length());
            } else {
                path = uri;
            }
        }

        // Public auth pages and static resources bypass role check
        if (path.startsWith("/login") || path.startsWith("/register") || path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Role restriction logic
        if (path.startsWith("/doctor") && !"DOCTOR".equalsIgnoreCase(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path.startsWith("/patient") && !"PATIENT".equalsIgnoreCase(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(role)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Shared URLs pass through
        chain.doFilter(request, response);
    }
}
