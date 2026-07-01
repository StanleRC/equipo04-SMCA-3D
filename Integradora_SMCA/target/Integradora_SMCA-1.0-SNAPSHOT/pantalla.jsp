<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configuración de Cuenta</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/csspantalla.css">
</head>
<body>

<div class="layout-container">

    <aside class="sidebar">
        <div class="profile-section text-center">
            <div class="avatar-container mx-auto">
                <div class="avatar-placeholder"></div>
                <button class="edit-avatar-btn">✎</button>
            </div>
            <p class="welcome-text">¡Bienvenido(a)!</p>
            <h3 class="user-name">Pedro Urieta</h3>
        </div>

        <nav class="sidebar-menu">
            <a href="#" class="menu-item">Buscar</a>
            <a href="#" class="menu-item">Bitácora</a>
            <a href="#" class="menu-item">Incidencias</a>
            <a href="#" class="menu-item">Registrar nuevo usuario</a>
        </nav>

        <div class="sidebar-footer">
            <a href="#" class="logout-btn">
                <span class="logout-icon">↪️</span> Cerrar sesión
            </a>
        </div>
    </aside>

    <div class="main-content">
        <header class="topbar">
            <h1 class="m-0">Configuración de Cuenta</h1>
        </header>

        <main class="page-body">
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/bootstrap.js"></script>

</body>
</html>