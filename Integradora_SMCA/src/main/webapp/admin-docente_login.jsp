<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitácora Digital (Admin/Docente) - UTEZ</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- Tu archivo CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.6">
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

        <!-- Mensaje de error -->
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error-message-text">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <!-- Avatar / Logo central superior -->
        <div class="login-avatar-container">
            <div class="login-avatar-circle">
                <img src="${pageContext.request.contextPath}/assets/img/logologis.png" alt="Logo Bitácora" class="avatar-img">
            </div>
        </div>

        <!-- Formulario de acceso -->
        <form action="${pageContext.request.contextPath}/loginDocenteServlet" method="POST" class="login-form">

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

            <!-- Enlace "¿Olvidaste tu contraseña?" -->
            <div class="card-links-container">
                <a href="${pageContext.request.contextPath}/recuperar_pass.jsp" class="card-link bold-link">¿Olvidaste tu contraseña?</a>
            </div>

            <!-- Enlaces inferiores en extremos -->
            <div class="card-footer-links">
                <a href="#" class="card-link" data-bs-toggle="modal" data-bs-target="#modalRegistroInfo">¿No tienes una cuenta?</a>
                <a href="${pageContext.request.contextPath}/index.jsp" class="card-link">¿Eres un estudiante?</a>
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
<!-- ESTRUCTURA DEL MODAL SOBRE NOSOTROS -->
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

<!-- ========================================================= -->
<!-- MODAL EMERGENTE DE INFORMACIÓN DE REGISTRO ACTUALIZADO -->
<!-- ========================================================= -->
<div class="modal fade" id="modalRegistroInfo" tabindex="-1" aria-labelledby="modalRegistroInfoLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content info-modal-content">

            <!-- Encabezado del Modal -->
            <div class="modal-header info-modal-header bg-success text-white">
                <h5 class="modal-title info-modal-title text-white" id="modalRegistroInfoLabel">
                    <i class="bi bi-info-circle-fill me-2 text-white"></i>Información de Acceso al Sistema
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <!-- Cuerpo del Modal -->
            <div class="modal-body info-modal-body">

                <p class="info-modal-desc">
                    Selecciona tu perfil para continuar con la solicitud de acceso:
                </p>

                <!-- Tarjeta Personal docente (Enlace directo a Registro de Maestro) -->
                <div class="info-role-card p-3 mb-3 border rounded shadow-sm d-flex align-items-center">
                    <div class="info-role-icon me-3 fs-3 text-success">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <div>
                        <h6 class="info-role-title fw-bold mb-1">Personal Docente / Profesorado</h6>
                        <p class="info-role-text mb-2 text-muted small">
                            ¿Eres maestro? Completa tu solicitud de registro en la plataforma.
                        </p>
                        <a href="${pageContext.request.contextPath}/views/admin/registro_directo_maestro.jsp" class="btn btn-sm btn-outline-success fw-bold">
                            Registrarse como Maestro
                        </a>
                    </div>
                </div>

                <!-- Tarjeta Administradores (Mensaje Restringido únicamente para Administrador) -->
                <div class="info-role-card p-3 border rounded shadow-sm d-flex align-items-center">
                    <div class="info-role-icon me-3 fs-3 text-success">
                        <i class="bi bi-shield-lock-fill"></i>
                    </div>
                    <div>
                        <h6 class="info-role-title fw-bold mb-1">Administradores de Sistema</h6>
                        <p class="info-role-text mb-0 text-muted small">
                            El registro está restringido. Póngase en contacto directo con el área de Desarrollo / Propietario del Software para la asignación de credenciales.
                        </p>
                    </div>
                </div>

            </div>

            <!-- Pie del Modal -->
            <div class="modal-footer info-modal-footer">
                <button type="button" class="btn btn-success w-100 fw-bold" data-bs-dismiss="modal">
                    Entendido
                </button>
            </div>

        </div>
    </div>
</div>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/assets/js/sobrenosotros.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>