<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error 500 - Error interno del servidor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff3cd;
            text-align: center;
            padding-top: 50px;
        }
        .error-container {
            display: inline-block;
            padding: 20px;
            border: 2px solid #856404;
            border-radius: 10px;
            background-color: #fff;
        }
        h1 {
            color: #856404;
        }
        img {
            max-width: 250px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="error-container">
    <h1>500 - Error interno del servidor</h1>
    <p>Ocurrió un problema inesperado. Nuestro equipo ya está trabajando en ello.</p>
    <img src="${pageContext.request.contextPath}/assets/img/error-500.png" alt="Error 500">
    <p><a href="${pageContext.request.contextPath}/index.jsp">Volver al inicio</a></p>
</div>
</body>
</html>
