<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Registrar maestro - UTEZ" />
</jsp:include>

<!-- CSS Registrar Maestro -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrar_maestro.css?v=1">

<!-- SweetAlert2 y Alertas Personalizadas -->
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

                <form id="formRegistrarMaestro" action="${pageContext.request.contextPath}/RegistroDocenteServlet" method="POST">
                    <div class="row g-3">
                        <!-- Columna Izquierda -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="idDocente" class="form-label">Matrícula / Clave de Docente</label>
                                <input type="text" id="idDocente" name="txtIdDocente" class="form-control custom-input" placeholder="Ej. 20253DS035" autocomplete="off" required>
                            </div>
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre(s)</label>
                                <input type="text" id="nombre" name="txtNombre" class="form-control custom-input" placeholder="Ingresa nombre(s)" autocomplete="off" required>
                            </div>
                            <div class="mb-3">
                                <label for="apellidoPaterno" class="form-label">Apellido paterno</label>
                                <input type="text" id="apellidoPaterno" name="txtApellidoPaterno" class="form-control custom-input" placeholder="Ingresa apellido paterno" autocomplete="off" required>
                            </div>
                            <div class="mb-3">
                                <label for="apellidoMaterno" class="form-label">Apellido materno</label>
                                <input type="text" id="apellidoMaterno" name="txtApellidoMaterno" class="form-control custom-input" placeholder="Ingresa apellido materno" autocomplete="off" required>
                            </div>
                        </div>

                        <!-- Columna Derecha -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="correo" class="form-label">Correo electrónico</label>
                                <input type="email" id="correo" name="txtCorreo" class="form-control custom-input" placeholder="docente@utez.edu.mx" autocomplete="off" required>
                            </div>
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
                                <input type="tel" id="telefono" name="txtTelefono" class="form-control custom-input" placeholder="7771234567" autocomplete="off">
                            </div>
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="actions-container mt-4 d-flex justify-content-between">
                        <a href="javascript:history.back()" class="btn btn-cancel">Cancelar</a>
                        <button type="submit" class="btn btn-next">Registrar</button>
                    </div>
                </form>
            </div>
        </div>

    </main>
</div>

<!-- Script de Validaciones -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('formRegistrarMaestro');

        if (form) {
            form.addEventListener('submit', function(event) {
                event.preventDefault();

                const pass = document.getElementById('password').value;
                const confirmPass = document.getElementById('confirmPassword').value;

                if (pass !== confirmPass) {
                    if (typeof mostrarAlertaError === 'function') {
                        mostrarAlertaError('Las contraseñas no coinciden. Por favor, verifícalas.');
                    } else {
                        alert('Las contraseñas no coinciden.');
                    }
                    return;
                }

                if (typeof mostrarAlertaExito === 'function') {
                    mostrarAlertaExito('¡Docente registrado correctamente!', function() {
                        form.submit();
                    });
                } else {
                    form.submit();
                }
            });
        }
    });
</script>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />