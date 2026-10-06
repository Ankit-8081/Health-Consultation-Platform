package com.healthconsult.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Shows the login page. The JSP lives under WEB-INF, so it can only be reached through this servlet.
 *
 * <p>TODO F1 (Business Logic): add doPost. Validate input, call AuthService, create a NEW session,
 * store SessionKeys.USER_ID, USER_NAME and ROLE, then redirect to Role.getDashboardPath().
 * On error forward back here with request attributes "errors" (Map field to message, "general" for
 * a message above the form) and "form" (Map of entered values, never the password).
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }
}
