<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Page Not Found - HealthConsult Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f4f8fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
        .error-card { background: #ffffff; border: none; border-radius: 16px; box-shadow: 0 4px 20px rgba(0, 163, 224, 0.08); padding: 40px; text-align: center; max-width: 500px; width: 100%; }
        .error-icon { font-size: 4rem; color: #00a3e0; margin-bottom: 20px; }
        .btn-custom { background-color: #00a3e0; color: #fff; border-radius: 8px; padding: 10px 24px; font-weight: 600; text-decoration: none; display: inline-block; transition: background 0.2s; }
        .btn-custom:hover { background-color: #0082b4; color: #fff; }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="error-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <h2 class="fw-bold text-dark mb-2">Page Not Found (404)</h2>
        <p class="text-muted mb-4">The medical portal page you are looking for might have been moved, deleted, or never existed.</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-custom"><i class="fa-solid fa-house me-2"></i>Return to Home</a>
    </div>
</body>
</html>
