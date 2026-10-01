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

class AuthFilterTest {

    private final AuthFilter filter = new AuthFilter();
    private final HttpServletRequest req = mock(HttpServletRequest.class);
    private final HttpServletResponse res = mock(HttpServletResponse.class);
    private final FilterChain chain = mock(FilterChain.class);

    private void requestFor(String uri) {
        when(req.getContextPath()).thenReturn("/health-consult");
        when(req.getRequestURI()).thenReturn("/health-consult" + uri);
    }

    @Test
    void anonymousUserIsSentToLogin() throws Exception {
        requestFor("/patient/book");
        when(req.getSession(false)).thenReturn(null);

        filter.doFilter(req, res, chain);

        verify(res).sendRedirect("/health-consult/login");
        verify(chain, never()).doFilter(any(), any());
    }

    @Test
    void loginPageIsPublic() throws Exception {
        requestFor("/login");

        filter.doFilter(req, res, chain);

        verify(chain).doFilter(req, res);
    }

    @Test
    void staticFilesArePublic() throws Exception {
        requestFor("/css/tokens.css");

        filter.doFilter(req, res, chain);

        verify(chain).doFilter(req, res);
    }

    @Test
    void loggedInUserPassesAndPageIsNotCached() throws Exception {
        requestFor("/patient/book");
        HttpSession session = mock(HttpSession.class);
        when(req.getSession(false)).thenReturn(session);
        when(session.getAttribute(SessionKeys.USER_ID)).thenReturn(5);

        filter.doFilter(req, res, chain);

        verify(chain).doFilter(req, res);
        verify(res).setHeader("Pragma", "no-cache");
    }
}
