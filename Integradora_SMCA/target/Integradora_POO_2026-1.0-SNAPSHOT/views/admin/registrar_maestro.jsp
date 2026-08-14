<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Registrar maestro - UTEZ" />
</jsp:include>

<!-- CSS Registrar Maestro -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrar_maestro.css?v=1">

<!-- CDN SweetAlert2 y Recursos Globales de Alertas -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
<script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

<div class="main-wrapper">
    <!-- Sidebar Admin -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="registrar-body">

            <!-- Encabezado: Botón Atrás + Logo UTEZ -->
            <div class="header-section">
                <div class="back-link-wrapper">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="bi bi-arrow-left"></i> Pestaña anterior
                    </a>
                </div>
                <div class="logo-wrapper">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo img-fluid">
                </div>
            </div>

            <!-- Tarjeta Principal Gris -->
            <div class="registrar-card">
                <h3 class="registrar-card-title text-center">Registrar maestro</h3>

                <form id="formRegistrarMaestro" action="RegistrarMaestroServlet" method="POST">
                    <div class="row g-3">
                        <!-- Columna Izquierda -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre(s)</label>
                                <input type="text" id="nombre" name="txtNombre" class="form-control custom-input" required>
                            </div>
                            <div class="mb-3">
                                <label for="apellidoPaterno" class="form-label">Apellido paterno</label>
                                <input type="text" id="apellidoPaterno" name="txtApellidoPaterno" class="form-control custom-input" required>
                            </div>
                            <div class="mb-3">
                                <label for="apellidoMaterno" class="form-label">Apellido materno</label>
                                <input type="text" id="apellidoMaterno" name="txtApellidoMaterno" class="form-control custom-input" required>
                            </div>
                            <div class="mb-3">
                                <label for="correo" class="form-label">Correo electrónico</label>
                                <input type="email" id="correo" name="txtCorreo" class="form-control custom-input" required>
                            </div>
                        </div>

                        <!-- Columna Derecha -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="password" class="form-label">Contraseña</label>
                                <input type="password" id="password" name="txtPassword" class="form-control custom-input" required>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirmar contraseña</label>
                                <input type="password" id="confirmPassword" name="txtConfirmPassword" class="form-control custom-input" required>
                            </div>
                            <div class="mb-3">
                                <label for="telefono" class="form-label">Teléfono</label>
                                <input type="tel" id="telefono" name="txtTelefono" class="form-control custom-input" required>
                            </div>
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="actions-container mt-4 d-flex justify-content-between">
                        <a href="javascript:history.back()" class="btn btn-cancel">Cancelar</a>

                        <button type="button"
                                class="btn btn-next"
                                onclick="confirmarRegistroMaestro(event, document.getElementById('formRegistrarMaestro'))">
                            Registrar
                        </button>
                    </div>
                </form>
            </div>
        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />