<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<%-- After a forward, requestURI is the JSP path. The original URL is kept in this request attribute. --%>
<c:set var="uri" value="${empty requestScope['jakarta.servlet.forward.request_uri'] ? pageContext.request.requestURI : requestScope['jakarta.servlet.forward.request_uri']}" />
<%-- Links come from the URL map in docs/UI_Handoff_Spec.md. Roles: ADMIN, PROFESSIONAL, PATIENT. --%>
<aside class="sidebar">
    <nav aria-label="Main">
        <ul>
            <c:choose>
                <c:when test="${sessionScope.role == 'PATIENT'}">
                    <li><a href="${ctx}/patient/dashboard"<c:if test="${fn:endsWith(uri, '/patient/dashboard')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-house-medical" aria-hidden="true"></i>Dashboard</a></li>
                    <li><a href="${ctx}/patient/book"<c:if test="${fn:endsWith(uri, '/patient/book')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-calendar-plus" aria-hidden="true"></i>Book consultation</a></li>
                    <li><a href="${ctx}/patient/appointments"<c:if test="${fn:endsWith(uri, '/patient/appointments')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-calendar-check" aria-hidden="true"></i>My appointments</a></li>
                    <li><a href="${ctx}/patient/advice"<c:if test="${fn:endsWith(uri, '/patient/advice')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-file-prescription" aria-hidden="true"></i>Medical advice</a></li>
                    <li><a href="${ctx}/patient/records"<c:if test="${fn:endsWith(uri, '/patient/records')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-file-medical" aria-hidden="true"></i>Health records</a></li>
                    <li><a href="${ctx}/patient/profile"<c:if test="${fn:endsWith(uri, '/patient/profile')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-user-gear" aria-hidden="true"></i>Profile</a></li>
                </c:when>
                <c:when test="${sessionScope.role == 'PROFESSIONAL'}">
                    <li><a href="${ctx}/pro/dashboard"<c:if test="${fn:endsWith(uri, '/pro/dashboard')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-house-medical" aria-hidden="true"></i>Dashboard</a></li>
                    <li><a href="${ctx}/pro/schedule"<c:if test="${fn:endsWith(uri, '/pro/schedule')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-calendar-days" aria-hidden="true"></i>Schedule</a></li>
                    <li><a href="${ctx}/pro/consultations"<c:if test="${fn:endsWith(uri, '/pro/consultations')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-stethoscope" aria-hidden="true"></i>Consultations</a></li>
                </c:when>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <li><a href="${ctx}/admin/dashboard"<c:if test="${fn:endsWith(uri, '/admin/dashboard')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-house-medical" aria-hidden="true"></i>Dashboard</a></li>
                    <li><a href="${ctx}/admin/users"<c:if test="${fn:endsWith(uri, '/admin/users')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-users" aria-hidden="true"></i>Users</a></li>
                    <li><a href="${ctx}/admin/appointments"<c:if test="${fn:endsWith(uri, '/admin/appointments')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-calendar-check" aria-hidden="true"></i>Appointments</a></li>
                    <li><a href="${ctx}/admin/settings"<c:if test="${fn:endsWith(uri, '/admin/settings')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-gear" aria-hidden="true"></i>Settings</a></li>
                    <li><a href="${ctx}/admin/analytics"<c:if test="${fn:endsWith(uri, '/admin/analytics')}"> class="active" aria-current="page"</c:if>><i class="fa-solid fa-chart-pie" aria-hidden="true"></i>Analytics</a></li>
                </c:when>
            </c:choose>
        </ul>
    </nav>
</aside>
