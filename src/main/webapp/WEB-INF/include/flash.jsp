<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- One-time messages. Servlets set session attributes flashSuccess / flashError before a redirect,
     or the request attribute errors.general when forwarding back to a form. Shown once, then removed. --%>
<c:if test="${not empty sessionScope.flashSuccess}">
    <div class="alert alert-success" role="status"><c:out value="${sessionScope.flashSuccess}" /></div>
    <c:remove var="flashSuccess" scope="session" />
</c:if>
<c:if test="${not empty sessionScope.flashError}">
    <div class="alert alert-error" role="alert"><c:out value="${sessionScope.flashError}" /></div>
    <c:remove var="flashError" scope="session" />
</c:if>
<c:if test="${not empty errors.general}">
    <div class="alert alert-error" role="alert"><c:out value="${errors.general}" /></div>
</c:if>
