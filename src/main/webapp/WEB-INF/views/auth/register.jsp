<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/include/header.jsp">
    <jsp:param name="pageTitle" value="Register" />
</jsp:include>

<main id="main-content" class="auth-container">
    <h1>Create Patient Account</h1>

    <form action="${pageContext.request.contextPath}/register" method="POST" novalidate>
        <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name" 
                   value="<c:out value='${form.name}' />" 
                   class="${not empty errors.name ? 'input-error' : ''}"
                   <c:if test="${not empty errors.name}">aria-invalid="true" aria-describedby="name-error"</c:if> required>
            <c:if test="${not empty errors.name}">
                <span id="name-error" class="field-error" role="alert"><c:out value="${errors.name}" /></span>
            </c:if>
        </div>

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
            <label for="phone">Phone Number (Optional)</label>
            <input type="tel" id="phone" name="phone" 
                   value="<c:out value='${form.phone}' />" 
                   class="${not empty errors.phone ? 'input-error' : ''}"
                   <c:if test="${not empty errors.phone}">aria-invalid="true" aria-describedby="phone-error"</c:if>>
            <c:if test="${not empty errors.phone}">
                <span id="phone-error" class="field-error" role="alert"><c:out value="${errors.phone}" /></span>
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

        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" 
                   class="${not empty errors.confirmPassword ? 'input-error' : ''}"
                   <c:if test="${not empty errors.confirmPassword}">aria-invalid="true" aria-describedby="confirmPassword-error"</c:if> required>
            <c:if test="${not empty errors.confirmPassword}">
                <span id="confirmPassword-error" class="field-error" role="alert"><c:out value="${errors.confirmPassword}" /></span>
            </c:if>
        </div>

        <button type="submit" class="btn-primary">Register</button>
    </form>

    <p class="auth-footer">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
    </p>
</main>

<jsp:include page="/WEB-INF/include/footer.jsp" />