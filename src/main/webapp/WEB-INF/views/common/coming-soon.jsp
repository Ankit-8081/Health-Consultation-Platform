<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Coming soon" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <h1><c:out value="${featureName}" /></h1>

    <div class="card" role="status">
        <p><strong>It is scheduled for Review 2.</strong></p>
        <p>This feature is planned and will be added in the next phase of the project.</p>
    </div>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
