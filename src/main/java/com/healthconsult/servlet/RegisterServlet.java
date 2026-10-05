package com.healthconsult.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Shows the patient registration page.
 *
 * <p>TODO F1 (Business Logic): add doPost. Fields: name, email, phone (optional), password, confirmPassword.
 * Validate, hash with PasswordUtil, save a PATIENT, set session flashSuccess, redirect to /login.
 * Only patients can self-register. Professionals are created by an Admin (SRS FR-C1, FR-A1).
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }
}
