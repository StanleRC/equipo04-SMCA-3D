<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitácora Digital - UTEZ</title>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- CSS de Login -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.5">
</head>

<body class="login-body">

<div class="login-page-container">

    <!-- Sección del Logo de la UTEZ y Título -->
    <header class="login-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
        <h1 class="system-title">Bitácora digital</h1>
    </header>

    <!-- Tarjeta del Formulario (Card) -->
    <main class="login-card">

        <!-- Mensaje de error dinámico dinámico con JSTL -->
        <c:if test="${not empty requestScope.errorMessage}">
            <div style="color: #ff4d4d; text-align: center; font-size: 13px; font-weight: 600; margin-bottom: 15px;">
                    ${requestScope.errorMessage}
            </div>
        </c:if>

        <!-- Avatar gris superior -->
        <div class="login-avatar-container">
            <div class="login-avatar-circle">
                <i class="bi bi-person-fill"></i>
            </div>
        </div>

        <!-- Formulario de acceso -->
        <form action="${pageContext.request.contextPath}/loginServlet" method="POST" class="login-form">

            <!-- Campo Matrícula -->
            <div class="form-group">
                <label for="matricula" class="input-label">Matrícula</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-person-vcard icon-input"></i>
                    <input type="text" id="matricula" name="matricula" placeholder="Introduce tu matrícula" required>
                </div>
            </div>

            <!-- Campo Contraseña -->
            <div class="form-group">
                <label for="password" class="input-label">Contraseña</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-lock icon-input"></i>
                    <input type="password" id="password" name="password" placeholder="Introduce una contraseña" required>
                </div>
            </div>

            <!-- Botón de Acción -->
            <div class="button-container">
                <button type="submit" class="btn-submit">Iniciar sesión</button>
            </div>

            <!-- Enlaces de soporte -->
            <div class="card-links-container">
                <a href="${pageContext.request.contextPath}/recuperar_pass.jsp" class="card-link bold-link">¿Olvidaste tu contraseña?</a>

                <div class="card-footer-links">
                    <a href="${pageContext.request.contextPath}/views/alumno/registro_directo_alumno.jsp" class="card-link">¿No tienes cuenta?</a>
                    <a href="${pageContext.request.contextPath}/admin-docente_login.jsp" class="card-link">¿Eres administrador?</a>
                </div>
            </div>
        </form>
    </main>

    <!-- Footer con enlace interactivo -->
    <footer class="login-footer">
        <a href="javascript:void(0);" class="about-us-link" id="openModalBtn">
            <i class="bi bi-info-circle"></i>
            <span>Sobre Nosotros</span>
        </a>
    </footer>

</div>

<!-- Modal Sobre Nosotros -->
<div id="aboutModal" class="modal-overlay">
    <div class="modal-card">
        <h2 class="modal-title">¿Quiénes somos?</h2>

        <p class="modal-text">
            "Somos estudiantes de la carrera de Tecnologías de la Información en la UTEZ.
            Desarrollamos este sistema como parte de nuestro proyecto integrador para optimizar
            la gestión, el control de accesos y el reporte de incidencias en los laboratorios de cómputo
            de DATID, conectando de forma eficiente a alumnos, docentes y administradores a través
            de soluciones en la nube."
        </p>

        <button type="button" class="btn-close-modal" id="closeModalBtn">Cerrar</button>
    </div>
</div>

<!-- JS de Sobre Nosotros -->
<script src="${pageContext.request.contextPath}/assets/js/sobrenosotros.js"></script>
</body>
</html>