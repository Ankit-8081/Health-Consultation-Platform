package com.healthconsult.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * STUB so the app starts and shows a page. Feature F1 (Business Logic + Frontend) replaces this:
 * doPost must validate input, call AuthService, create a NEW session, store SessionKeys.USER_ID,
 * USER_NAME and ROLE, then redirect to Role.getDashboardPath().
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }
}
