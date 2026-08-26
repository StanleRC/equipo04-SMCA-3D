<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error 404 - Página no encontrada</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            text-align: center;
            padding-top: 50px;
        }
        .error-container {
            display: inline-block;
            padding: 20px;
            border: 2px solid #dc3545;
            border-radius: 10px;
            background-color: #fff;
        }
        h1 {
            color: #dc3545;
        }
        img {
            max-width: 300px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="error-container">
    <h1>404 - Recurso no encontrado</h1>
    <p>La página que buscas no existe o fue movida.</p>
    <img src="${pageContext.request.contextPath}/assets/img/error-404.png" alt="Error 404">
    <p><a href="javascript:history.back()" class="btn-back">Volver</a></p>
</div>
</body>
</html>
