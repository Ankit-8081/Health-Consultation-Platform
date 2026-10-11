<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Coming soon" />
</jsp:include>

<jsp:include page="/WEB-INF/include/sidebar.jsp" />

<main id="main-content" class="content">
    <section class="page-banner">
        <div>
            <h1><c:out value="${featureName}" /></h1>
            <p>This part of the platform is planned for the next phase.</p>
        </div>
    </section>

    <section class="card message-card" role="status">
        <div class="auth-icon" aria-hidden="true"><i class="fa-solid fa-hourglass-half"></i></div>
        <p><strong>It is scheduled for Review 2.</strong></p>
        <p>We are still building this feature. Please check back after the next release.</p>
    </section>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
