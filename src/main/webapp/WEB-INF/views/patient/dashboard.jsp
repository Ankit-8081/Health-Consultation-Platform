<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Patient dashboard" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <h1>Patient dashboard</h1>

    <jsp:include page="/WEB-INF/include/flash.jsp" />

    <div class="card">
        <p>Welcome, <strong><c:out value="${sessionScope.userName}" /></strong>.</p>
        <p>This is a placeholder page. The real dashboard replaces it.</p>
    </div>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
