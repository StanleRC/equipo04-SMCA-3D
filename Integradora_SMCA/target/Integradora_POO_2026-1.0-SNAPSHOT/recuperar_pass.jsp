<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña - UTEZ</title>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Hoja de Estilos -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.5">
</head>

<body class="login-body">

<div class="login-page-container">

    <!-- Sección del Logo de la UTEZ y Título -->
    <header class="login-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
        <h1 class="system-title">Bitácora digital</h1>
    </header>


    <main class="login-card">

        <!-- Avatar gris superior -->
        <div class="login-avatar-container">
            <div class="login-avatar-circle">
                <i class="bi bi-person-fill"></i>
            </div>
        </div>

        <h2 style="text-align: center; color: #555555; font-size: 18px; margin-bottom: 20px; font-weight: 600;">
            Recuperar contraseña
        </h2>

        <!-- Formulario de recuperación -->
        <form action="${pageContext.request.contextPath}/recuperarPassServlet" method="POST" class="login-form">

            <!-- Campo Correo -->
            <div class="form-group">
                <div class="input-icon-wrapper">
                    <i class="bi bi-envelope icon-input"></i>
                    <input type="email" id="correo" name="correo" placeholder="Introduce tu correo" required>
                </div>
            </div>


            <div class="button-container">
                <button type="submit" class="btn-submit">Continuar</button>
            </div>


            <div class="card-links-container" style="text-align: center; margin-top: 15px;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="card-link bold-link">Regresar al login</a>
            </div>
        </form>
    </main>


    <footer class="login-footer">
        <a href="javascript:void(0);" class="about-us-link" id="openModalBtn">
            <i class="bi bi-info-circle"></i>
            <span>Sobre Nosotros</span>
        </a>
    </footer>

</div>

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


<script src="${pageContext.request.contextPath}/assets/js/sobrenosotros.js"></script>
</body>
</html>