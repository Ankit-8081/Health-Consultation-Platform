<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>403 - Access Denied</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="error-page">
    <div class="error-container">
        <h1>403</h1>
        <h2>Access Denied</h2>
        <p>You do not have the necessary permissions to view this portal or page.</p>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-primary">Return to Home</a>
    </div>
</body>
</html>