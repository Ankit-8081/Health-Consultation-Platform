package com.healthconsult.filter;

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
import java.util.List;
import java.util.Set;

/**
 * Runs on every request (mapped in web.xml, before RoleFilter).
 * Public pages and static files pass; everything else needs a logged-in session, otherwise the user
 * is sent to /login. Protected pages are sent with no-store so the back button after logout
 * does not show an old page.
 */
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_PATHS = Set.of("", "/", "/login", "/register");
    private static final List<String> PUBLIC_PREFIXES = List.of("/css/", "/js/", "/images/");

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getRequestURI().substring(request.getContextPath().length());
        if (isPublic(path)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(SessionKeys.USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        chain.doFilter(req, res);
    }

    private static boolean isPublic(String path) {
        if (PUBLIC_PATHS.contains(path)) {
            return true;
        }
        for (String prefix : PUBLIC_PREFIXES) {
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }
}
