package com.healthconsult.filter;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.healthconsult.util.SessionKeys;
import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;

class RoleFilterTest {

    private final RoleFilter filter = new RoleFilter();
    private final HttpServletRequest req = mock(HttpServletRequest.class);
    private final HttpServletResponse res = mock(HttpServletResponse.class);
    private final FilterChain chain = mock(FilterChain.class);

    private void requestAs(String uri, String role) {
        when(req.getContextPath()).thenReturn("/health-consult");
        when(req.getRequestURI()).thenReturn("/health-consult" + uri);
        HttpSession session = mock(HttpSession.class);
        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute(SessionKeys.ROLE)).thenReturn(role);
    }

    @Test
    void rightRolePasses() throws Exception {
        requestAs("/admin/users", "ADMIN");

        filter.doFilter(req, res, chain);

        verify(chain).doFilter(req, res);
    }

    @Test
    void wrongRoleGets403() throws Exception {
        requestAs("/admin/users", "PATIENT");

        filter.doFilter(req, res, chain);

        verify(res).sendError(HttpServletResponse.SC_FORBIDDEN);
        verify(chain, never()).doFilter(any(), any());
    }

    @Test
    void sharedUrlsAreNotRoleRestricted() throws Exception {
        requestAs("/messages", "PATIENT");

        filter.doFilter(req, res, chain);

        verify(chain).doFilter(req, res);
    }
}
