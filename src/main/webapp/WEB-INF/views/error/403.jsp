<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Access denied - HealthConsult</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tokens.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="error-page">
  <main class="card error-card">
    <h1>403 - Access denied</h1>
    <p>You do not have permission to open this page.</p>
    <a class="btn-outline-link" href="${pageContext.request.contextPath}/">Back to home</a>
  </main>
</body>
</html>
