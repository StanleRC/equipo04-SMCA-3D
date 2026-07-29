<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tu Perfil - Alumno</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- CSS Personalizado de la pantalla de Perfil -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Perfilalumno.css">

    <!-- 1. AQUÍ AÑADES EL CSS DEL MODAL EXTERNO -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modal_exito.css">
</head>
<body>

<!-- Incluimos el Sidebar del Alumno -->
<jsp:include page="/WEB-INF/views/layout/sidebar_alumno.jsp" />

<!-- Área de Contenido Principal -->
<div class="main-content">

    <!-- Banner Superior Azul -->
    <header class="top-header">
        <h1 class="top-title">Tu perfil</h1>
    </header>

    <!-- Contenedor Interno -->
    <div class="content-body">

        <!-- Enlace Volver a Pestaña Anterior -->
        <div class="mb-3">
            <a href="javascript:history.back()" class="back-link">
                <i class="bi bi-arrow-left"></i> <u>Pestaña anterior</u>
            </a>
        </div>

        <!-- Logo UTEZ Centrado -->
        <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/utez_logo.png" alt="Logo UTEZ" class="utez-logo-profile">
        </div>

        <!-- Tarjeta de Información Académica -->
        <div class="profile-card">

            <!-- Columna Izquierda: Avatar -->
            <div class="profile-card-left">
                <div class="large-avatar">
                    <i class="bi bi-person-fill"></i>
                </div>
            </div>

            <!-- Columna Derecha: Datos Académicos y Personales -->
            <div class="profile-card-right">
                <h2 class="academic-title">Información academica</h2>
                <h3 class="carrera-title">Desarrollo de software multiplataforma</h3>

                <div class="user-info-section">
                    <h4 class="user-name-text">${sessionScope.usuario.nombre != null ? sessionScope.usuario.nombre : 'Julian Perez Perez'}</h4>
                    <span class="user-role-badge">Alumno</span>
                </div>

                <!-- Grilla de Detalles -->
                <div class="row g-3 details-grid">
                    <div class="col-6">
                        <span class="label-text">Cuatrimestre:</span>
                        <span class="value-text">3</span>
                    </div>
                    <div class="col-6">
                        <span class="label-text">Grupo:</span>
                        <span class="value-text">D</span>
                    </div>
                    <div class="col-12">
                        <span class="value-text font-monospace">20253ds104@utez.edu.mx</span>
                    </div>
                    <div class="col-12">
                        <span class="label-text">Matricula:</span>
                        <span class="value-text">20253ds104</span>
                    </div>
                </div>

            </div>

        </div>

    </div>

</div>

<!-- 2. ESTRUCTURA HTML DEL MODAL (Agregada antes de los scripts) -->
<div class="modal fade" id="modalLoginExitoso" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content custom-modal-content text-center">

            <div class="success-icon-badge">
                <i class="bi bi-check-lg"></i>
            </div>

            <div class="modal-body pt-5 pb-4 px-4">
                <h3 class="modal-success-title mt-3">¡Inicio de sesión<br>exitoso!</h3>

                <div class="mt-4">
                    <button type="button" class="btn btn-aceptar-modal" id="btnAceptarModal">
                        Aceptar
                    </button>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- 3. AQUÍ AÑADES EL JS EXTERNO QUE ABRE Y CIERRA EL MODAL -->
<script src="${pageContext.request.contextPath}/assets/js/modal_exito.js"></script>

</body>
</html>