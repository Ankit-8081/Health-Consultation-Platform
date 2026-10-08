<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Page not found</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/tokens.css">
</head>
<body style="font-family: var(--font-body); background: var(--color-bg); color: var(--color-text); text-align: center; padding: 4rem 1rem;">
  <main>
    <h1 style="font-size: 24px;">404 - Page not found</h1>
    <p style="color: var(--color-muted);">We could not find the page you asked for.</p>
    <p><a href="${pageContext.request.contextPath}/" style="color: var(--color-primary);">Back to home</a></p>
  </main>
</body>
</html>
