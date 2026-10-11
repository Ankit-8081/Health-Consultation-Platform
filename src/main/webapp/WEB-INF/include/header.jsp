<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${param.pageTitle}" /> - HealthConsult</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${ctx}/css/tokens.css">
    <link rel="stylesheet" href="${ctx}/css/style.css">
    <link rel="stylesheet" href="${ctx}/css/pages.css">
</head>
<body>
    <a href="#main-content" class="skip-link">Skip to main content</a>

    <header class="navbar">
        <a class="brand" href="${ctx}/"><i class="fa-solid fa-heart-pulse" aria-hidden="true"></i>HealthConsult</a>
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <c:set var="nameParts" value="${fn:split(sessionScope.userName, ' ')}" />
                    <c:set var="initials" value="${fn:toUpperCase(fn:substring(nameParts[0], 0, 1))}${fn:length(nameParts) gt 1 ? fn:toUpperCase(fn:substring(nameParts[fn:length(nameParts) - 1], 0, 1)) : ''}" />
                    <span class="avatar" aria-hidden="true"><c:out value="${initials}" /></span>
                    <span class="user-name"><c:out value="${sessionScope.userName}" /></span>
                    <span class="role-badge"><c:out value="${sessionScope.role}" /></span>
                    <form action="${ctx}/logout" method="post" class="inline-form">
                        <button type="submit" class="btn-logout">Logout</button>
                    </form>
                </c:when>
                <%-- Visitors see a Login link everywhere except on the login and register pages themselves. --%>
                <c:when test="${param.pageTitle ne 'Login' and param.pageTitle ne 'Register'}">
                    <a class="btn-outline-link" href="${ctx}/login">Login</a>
                    <a class="btn-outline-link" href="${ctx}/register">Register</a>
                </c:when>
            </c:choose>
        </div>
    </header>

    <div class="main-container">
