<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <nav>
        <ul>
            <c:if test="${sessionScope.user.role == 'PATIENT'}">
                <li><a href="${pageContext.request.contextPath}/patient/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/patient/book.jsp">Book Appointment</a></li>
                <li><a href="${pageContext.request.contextPath}/patient/records.jsp">Health Records</a></li>
            </c:if>

            <c:if test="${sessionScope.user.role == 'DOCTOR'}">
                <li><a href="${pageContext.request.contextPath}/pro/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/pro/schedule.jsp">Manage Schedule</a></li>
            </c:if>

            <c:if test="${sessionScope.user.role == 'ADMIN'}">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users.jsp">Manage Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/appointments.jsp">Appointments</a></li>
            </c:if>
        </ul>
    </nav>
</aside>