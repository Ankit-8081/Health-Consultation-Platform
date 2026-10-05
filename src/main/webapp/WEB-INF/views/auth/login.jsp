<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Login" />
</jsp:include>

<main id="main-content" class="auth-container">
    <h1>Login to Your Account</h1>

    <form action="${pageContext.request.contextPath}/login" method="POST" novalidate>
        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" 
                   value="<c:out value='${form.email}' />" 
                   class="${not empty errors.email ? 'input-error' : ''}"
                   <c:if test="${not empty errors.email}">aria-invalid="true" aria-describedby="email-error"</c:if> required>
            <c:if test="${not empty errors.email}">
                <span id="email-error" class="field-error" role="alert"><c:out value="${errors.email}" /></span>
            </c:if>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" 
                   class="${not empty errors.password ? 'input-error' : ''}"
                   <c:if test="${not empty errors.password}">aria-invalid="true" aria-describedby="password-error"</c:if> required>
            <c:if test="${not empty errors.password}">
                <span id="password-error" class="field-error" role="alert"><c:out value="${errors.password}" /></span>
            </c:if>
        </div>

        <button type="submit" class="btn-primary">Sign In</button>
    </form>

    <p class="auth-footer">
        Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
    </p>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />
