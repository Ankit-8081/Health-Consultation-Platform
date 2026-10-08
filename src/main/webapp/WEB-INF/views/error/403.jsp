<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Access denied</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tokens.css">
</head>
<body style="font-family: var(--font-body); background: var(--color-bg); color: var(--color-text); text-align: center; padding: 4rem 1rem;">
  <main>
    <h1 style="font-size: 24px;">403 - Access denied</h1>
    <p style="color: var(--color-muted);">You do not have permission to open this page.</p>
    <p><a href="${pageContext.request.contextPath}/" style="color: var(--color-primary);">Back to home</a></p>
  </main>
</body>
</html>
