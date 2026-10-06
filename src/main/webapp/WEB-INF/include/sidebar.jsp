<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="uri" value="${pageContext.request.requestURI}" />
<%-- Links come from the URL map in docs/UI_Handoff_Spec.md. Roles: ADMIN, PROFESSIONAL, PATIENT. --%>
<aside class="sidebar">
    <nav aria-label="Main">
        <ul>
            <c:choose>
                <c:when test="${sessionScope.role == 'PATIENT'}">
                    <li><a href="${ctx}/patient/dashboard"<c:if test="${fn:endsWith(uri, '/patient/dashboard')}"> class="active" aria-current="page"</c:if>>Dashboard</a></li>
                    <li><a href="${ctx}/patient/book"<c:if test="${fn:endsWith(uri, '/patient/book')}"> class="active" aria-current="page"</c:if>>Book consultation</a></li>
                    <li><a href="${ctx}/patient/appointments"<c:if test="${fn:endsWith(uri, '/patient/appointments')}"> class="active" aria-current="page"</c:if>>My appointments</a></li>
                    <li><a href="${ctx}/patient/advice"<c:if test="${fn:endsWith(uri, '/patient/advice')}"> class="active" aria-current="page"</c:if>>Medical advice</a></li>
                    <li><a href="${ctx}/patient/records"<c:if test="${fn:endsWith(uri, '/patient/records')}"> class="active" aria-current="page"</c:if>>Health records</a></li>
                    <li><a href="${ctx}/patient/profile"<c:if test="${fn:endsWith(uri, '/patient/profile')}"> class="active" aria-current="page"</c:if>>Profile</a></li>
                </c:when>
                <c:when test="${sessionScope.role == 'PROFESSIONAL'}">
                    <li><a href="${ctx}/pro/dashboard"<c:if test="${fn:endsWith(uri, '/pro/dashboard')}"> class="active" aria-current="page"</c:if>>Dashboard</a></li>
                    <li><a href="${ctx}/pro/schedule"<c:if test="${fn:endsWith(uri, '/pro/schedule')}"> class="active" aria-current="page"</c:if>>Schedule</a></li>
                    <li><a href="${ctx}/pro/consultations"<c:if test="${fn:endsWith(uri, '/pro/consultations')}"> class="active" aria-current="page"</c:if>>Consultations</a></li>
                </c:when>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <li><a href="${ctx}/admin/dashboard"<c:if test="${fn:endsWith(uri, '/admin/dashboard')}"> class="active" aria-current="page"</c:if>>Dashboard</a></li>
                    <li><a href="${ctx}/admin/users"<c:if test="${fn:endsWith(uri, '/admin/users')}"> class="active" aria-current="page"</c:if>>Users</a></li>
                    <li><a href="${ctx}/admin/appointments"<c:if test="${fn:endsWith(uri, '/admin/appointments')}"> class="active" aria-current="page"</c:if>>Appointments</a></li>
                    <li><a href="${ctx}/admin/settings"<c:if test="${fn:endsWith(uri, '/admin/settings')}"> class="active" aria-current="page"</c:if>>Settings</a></li>
                    <li><a href="${ctx}/admin/analytics"<c:if test="${fn:endsWith(uri, '/admin/analytics')}"> class="active" aria-current="page"</c:if>>Analytics</a></li>
                </c:when>
            </c:choose>
        </ul>
    </nav>
</aside>
