<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle} - Online Health Consultation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tokens.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <a href="#main-content" class="skip-link">Skip to main content</a>

    <header class="navbar">
        <div class="logo">
            <h2>HealthConsult</h2>
        </div>
        <div class="user-info">
            <c:if test="${not empty sessionScope.user}">
                <span>Welcome, ${sessionScope.user.name} (${sessionScope.user.role})</span>
                <a href="${pageContext.request.contextPath}/logout" style="color:#f56565; margin-left:15px;">Logout</a>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/login.jsp" style="color:#e2e8f0;">Login</a>
            </c:if>
        </div>
    </header>

    <div class="main-container">