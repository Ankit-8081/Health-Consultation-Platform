<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Register" />
</jsp:include>

<main id="main-content" class="content" style="max-width: 500px; margin: 40px auto;">
    <h2>Create an Account</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post" style="margin-top: 20px;">
        <div style="margin-bottom: 15px;">
            <label for="name" style="display:block; font-weight:bold; margin-bottom:5px;">Full Name</label>
            <input type="text" id="name" name="name" value="${param.name}" required 
                   style="width:100%; padding:8px; border:1px solid #ccc; border-radius:4px;">
            <c:if test="${not empty fieldErrors.name}">
                <span style="color:#e53e3e; font-size:0.85rem;">${fieldErrors.name}</span>
            </c:if>
        </div>

        <div style="margin-bottom: 15px;">
            <label for="email" style="display:block; font-weight:bold; margin-bottom:5px;">Email Address</label>
            <input type="email" id="email" name="email" value="${param.email}" required 
                   style="width:100%; padding:8px; border:1px solid #ccc; border-radius:4px;">
            <c:if test="${not empty fieldErrors.email}">
                <span style="color:#e53e3e; font-size:0.85rem;">${fieldErrors.email}</span>
            </c:if>
        </div>

        <div style="margin-bottom: 15px;">
            <label for="password" style="display:block; font-weight:bold; margin-bottom:5px;">Password</label>
            <input type="password" id="password" name="password" required 
                   style="width:100%; padding:8px; border:1px solid #ccc; border-radius:4px;">
            <c:if test="${not empty fieldErrors.password}">
                <span style="color:#e53e3e; font-size:0.85rem;">${fieldErrors.password}</span>
            </c:if>
        </div>

        <div style="margin-bottom: 15px;">
            <label for="role" style="display:block; font-weight:bold; margin-bottom:5px;">Register As</label>
            <select id="role" name="role" style="width:100%; padding:8px; border:1px solid #ccc; border-radius:4px;">
                <option value="PATIENT" ${param.role == 'PATIENT' ? 'selected' : ''}>Patient</option>
                <option value="DOCTOR" ${param.role == 'DOCTOR' ? 'selected' : ''}>Healthcare Professional</option>
            </select>
        </div>

        <button type="submit" style="width:100%; padding:10px; background-color:#2b6cb0; color:white; border:none; border-radius:4px; font-weight:bold; cursor:pointer;">
            Register
        </button>
    </form>

    <p style="margin-top: 15px; text-align: center;">
        Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a>
    </p>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />