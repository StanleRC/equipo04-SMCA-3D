<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitácora Digital (Admin) - UTEZ</title>

    <!-- Cargamos Bootstrap Icons directamente -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Tu archivo CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
</head>

<body class="login-body">

<div class="login-page-container">

    <!-- Sección del Logo de la UTEZ y Título de Administrador -->
    <header class="login-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
        <h1 class="system-title">Bitácora digital<br><span class="subtitle-admin">(Acceso como administrador)</span></h1>
    </header>

    <!-- Tarjeta del Formulario (Card) -->
    <main class="login-card">

        <!-- Mensaje de error de forma correcta y limpia -->
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div style="color: #ff4d4d; text-align: center; font-size: 13px; font-weight: 600; margin-bottom: 15px;">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <!-- Avatar gris superior -->
        <div class="login-avatar-container">
            <div class="login-avatar-circle">
                <i class="bi bi-person-fill"></i>
            </div>
        </div>

        <!-- Formulario de acceso -->
        <form action="${pageContext.request.contextPath}/adminLoginServlet" method="POST" class="login-form">

            <!-- Campo Correo -->
            <div class="form-group">
                <label for="correo" class="input-label">Correo</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-envelope icon-input"></i>
                    <input type="email" id="correo" name="correo" placeholder="Introduce tu correo" required>
                </div>
            </div>

            <!-- Campo Contraseña -->
            <div class="form-group">
                <label for="password" class="input-label">Contraseña</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-lock icon-input"></i>
                    <input type="password" id="password" name="password" placeholder="Introduce tu contraseña" required>
                </div>
            </div>

            <!-- Botón de Acción -->
            <div class="button-container">
                <button type="submit" class="btn-submit">Iniciar sesión</button>
            </div>

            <!-- Enlaces de soporte adaptados a la imagen -->
            <div class="card-links-container">
                <a href="${pageContext.request.contextPath}/recuperar_pass.jsp" class="card-link bold-link">¿Olvidaste tu contraseña?</a>

                <div class="card-footer-links">
                    <a href="${pageContext.request.contextPath}/registro.jsp" class="card-link">¿No tienes una cuenta?</a>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="card-link">¿Eres un estudiante?</a>
                </div>
            </div>
        </form>
    </main>

    <!-- Footer de la página con enlace interactivo -->
    <footer class="login-footer">
        <a href="javascript:void(0);" class="about-us-link" id="openModalBtn">
            <i class="bi bi-info-circle"></i>
            <span>Sobre Nosotros</span>
        </a>
    </footer>

</div> <!-- /login-page-container -->


<!-- ========================================================= -->
<!-- ESTRUCTURA DEL MODAL (Como hijo directo del body) -->
<!-- ========================================================= -->
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

<!-- Script del Modal separado -->
<script src="${pageContext.request.contextPath}/assets/js/sobrenosotros.js"></script>

</body>
</html>