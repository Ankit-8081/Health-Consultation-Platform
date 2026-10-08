<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${param.pageTitle}" /> - HealthConsult</title>
    <link rel="stylesheet" href="${ctx}/css/tokens.css">
    <link rel="stylesheet" href="${ctx}/css/style.css">
    <link rel="stylesheet" href="${ctx}/css/pages.css">
</head>
<body>
    <a href="#main-content" class="skip-link">Skip to main content</a>

    <header class="navbar">
        <a class="brand" href="${ctx}/">HealthConsult</a>
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <span class="user-name"><c:out value="${sessionScope.userName}" /></span>
                    <span class="role-badge"><c:out value="${sessionScope.role}" /></span>
                    <form action="${ctx}/logout" method="post" class="inline-form">
                        <button type="submit" class="btn-link">Logout</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <a href="${ctx}/login">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <div class="main-container">
