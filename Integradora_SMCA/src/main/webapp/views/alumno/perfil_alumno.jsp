<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tu Perfil - Alumno</title>

    <!-- Importe Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Iconos de Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- CSS Personalizado del Perfil -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/Perfilalumno.css?v=3">
    <!-- CSS del Modal Exitoso -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modal_exito.css?v=3">

    <style>
        .card {
            background-color: #f8f9fa;
            border-radius: 18px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: 1px solid #e0e0e0;
            overflow: hidden;
            padding: 0 !important;
        }

        .profile-divider {
            border-right: 1px solid #b0b0b0;
        }

        @media (max-width: 767.98px) {
            .profile-divider {
                border-right: none;
                border-bottom: 1px solid #b0b0b0;
                padding-bottom: 2rem !important;
            }
        }
    </style>
</head>
<body>

<!-- Se llama el sidebar del Alumno -->
<jsp:include page="/views/layout/sidebar_alumno.jsp" />

<!-- Contenido principal -->
<div class="main-content">

    <!-- Banner Superior Azul -->
    <header class="top-header">
        <h1 class="top-title">Tu perfil</h1>
    </header>

    <div class="content-body">

        <!-- Logo de la UTEZ -->
        <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 140px;">
        </div>

        <!-- Tarjeta de información -->
        <div class="card">
            <div class="row align-items-stretch g-0">

                <!-- Columna Izquierda (Foto de perfil limpia) -->
                <div class="col-md-4 text-center d-flex align-items-center justify-content-center p-4 profile-divider">
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado.fotoPerfil}">
                            <img src="${pageContext.request.contextPath}/assets/img/perfiles/${sessionScope.usuarioLogueado.fotoPerfil}"
                                 class="rounded-circle img-fluid"
                                 alt="Foto Perfil"
                                 style="width: 150px; height: 150px; object-fit: cover;">
                        </c:when>
                        <c:when test="${not empty sessionScope.alumno.fotoPerfil}">
                            <img src="${pageContext.request.contextPath}/assets/img/perfiles/${sessionScope.alumno.fotoPerfil}"
                                 class="rounded-circle img-fluid"
                                 alt="Foto Perfil"
                                 style="width: 150px; height: 150px; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/img/default_profile.png"
                                 class="rounded-circle img-fluid"
                                 alt="Foto Perfil Predeterminada"
                                 style="width: 150px; height: 150px; object-fit: cover;">
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Columna Derecha (Datos del alumno) -->
                <div class="col-md-8 p-4 ps-md-5">
                    <h2 class="academic-title">Información académica</h2>
                    <h3 class="carrera-title">Desarrollo de Software Multiplataforma</h3>

                    <div class="user-info-section">
                        <h4 class="user-name-text">
                            <c:choose>
                                <c:when test="${not empty sessionScope.usuarioLogueado}">
                                    ${sessionScope.usuarioLogueado.nombre} ${sessionScope.usuarioLogueado.apellidoPaterno} ${sessionScope.usuarioLogueado.apellidoMaterno}
                                </c:when>
                                <c:otherwise>
                                    ${sessionScope.alumno.nombre} ${sessionScope.alumno.apellidoPaterno} ${sessionScope.alumno.apellidoMaterno}
                                </c:otherwise>
                            </c:choose>
                        </h4>
                        <span class="user-role-text">Alumno</span>
                    </div>

                    <!-- Detalles -->
                    <div class="row g-3 details-grid mt-2">
                        <div class="col-6">
                            <span class="label-text">Cuatrimestre:</span>
                            <span class="value-text">3°</span>
                        </div>
                        <div class="col-6">
                            <span class="label-text">Grupo:</span>
                            <span class="value-text">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                                        ${sessionScope.usuarioLogueado.grupoIdGrupo}
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.alumno.grupoIdGrupo}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="col-12">
                            <span class="value-text email-text">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                                        ${sessionScope.usuarioLogueado.correo}
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.alumno.correo}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="col-12">
                            <span class="label-text">Matrícula:</span>
                            <span class="value-text">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                                        ${sessionScope.usuarioLogueado.matricula}
                                    </c:when>
                                    <c:otherwise>
                                        ${sessionScope.alumno.matricula}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Modal de Login Exitoso -->
<c:if test="${not empty sessionScope.mostrarModalLogin and sessionScope.mostrarModalLogin}">
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
    <script src="${pageContext.request.contextPath}/assets/js/modal_exito.js"></script>
    <% session.removeAttribute("mostrarModalLogin"); %>
</c:if>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Definición de variables JSP antes de cargar el archivo JS -->
<script>
    window.APP_CONFIG = {
        usuarioNombre: "${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado.nombre : sessionScope.alumno.nombre}",
        contextPath: "${pageContext.request.contextPath}"
    };
</script>
</body>
</html>