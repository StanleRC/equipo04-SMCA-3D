<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Configuración de Cuenta - Bitácora" />
</jsp:include>

<!-- CSS de Configuración de Cuenta -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/config_perfil.css?v=3">

<!-- CDN de SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Recursos de alertas personalizadas -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
<script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

<div class="main-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal (Desplazada 240px a la derecha) -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="profile-top-blue-bar">
            Configuración de Cuenta
        </div>

        <!-- Cuerpo Centrado del Formulario -->
        <div class="profile-page-body">
            <div class="container">

                <!-- Logo UTEZ Centrado -->
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="width: 200px; height: auto;">
                </div>

                <!-- Tarjeta Principal de Configuración -->
                <div class="profile-main-card">

                    <p class="text-center profile-instruction-text mb-4">
                        Gestiona tu información personal, avatar institucional y credenciales de acceso.
                    </p>

                    <form id="formConfigCuenta" action="ActualizarPerfilServlet" method="POST" enctype="multipart/form-data">
                        <div class="row align-items-center">

                            <!-- Columna Izquierda: Cargar Foto -->
                            <div class="col-md-5 avatar-upload-section text-center">
                                <div class="avatar-preview-circle">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <button type="button" class="btn-upload-link">Subir nueva foto</button>
                                <p class="avatar-specs-text">
                                    Formatos válidos: PNG, JPG.<br>Tamaño máximo recomendado: 2 MB.
                                </p>
                            </div>

                            <!-- Columna Derecha: Campos del Formulario -->
                            <div class="col-md-7 profile-form-section">
                                <div class="user-role-badge">
                                    Rol de usuario: <span class="text-muted font-weight-normal">administrador</span>
                                </div>

                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Nombre</label>
                                    <input type="text" id="txtNombre" name="txtNombre" class="form-control profile-form-input" placeholder="Nombre(s)" autocomplete="off">
                                </div>

                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Correo Institucional</label>
                                    <input type="email" id="txtCorreo" name="txtCorreo" class="form-control profile-form-input" placeholder="Correo" autocomplete="off">
                                </div>

                                <div class="form-group mb-4">
                                    <label class="profile-form-label">Teléfono de Contacto</label>
                                    <input type="text" id="txtTelefono" name="txtTelefono" class="form-control profile-form-input" placeholder="Telefono" autocomplete="off">
                                </div>

                                <div class="text-end mt-4">
                                    <button type="submit" class="btn-profile-save">Guardar cambios</button>
                                </div>
                            </div>

                        </div>
                    </form>

                </div>

            </div>
        </div>
    </main>
</div>

<!-- Script de interceptación del formulario para disparar las alertas -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('formConfigCuenta');

        if (form) {
            form.addEventListener('submit', function(event) {
                // Detenemos el envío automático del formulario
                event.preventDefault();

                const nombre = document.getElementById('txtNombre').value.trim();
                const correo = document.getElementById('txtCorreo').value.trim();
                const telefono = document.getElementById('txtTelefono').value.trim();

                // 1. VALIDACIÓN: Si algún campo importante está vacío -> MOSTRAR ALERTA DE ERROR
                if (nombre === '' || correo === '' || telefono === '') {
                    if (typeof mostrarAlertaError === 'function') {
                        mostrarAlertaError('Por favor, completa todos los campos del formulario.');
                    } else {
                        alert('Por favor, completa todos los campos.');
                    }
                    return; // Detiene la ejecución
                }

                // 2. ÉXITO: Si todos los campos están llenos -> MOSTRAR ALERTA DE ÉXITO Y ENVIAR
                if (typeof mostrarAlertaExito === 'function') {
                    mostrarAlertaExito('¡Cambios realizados de manera exitosa!', function() {
                        form.submit(); // Envía los datos a ActualizarPerfilServlet al dar clic en Aceptar
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