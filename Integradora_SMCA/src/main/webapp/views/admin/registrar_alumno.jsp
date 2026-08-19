<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Registrar alumno - UTEZ" />
</jsp:include>

<!-- CSS Registrar Alumno -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrar_alumno.css?v=1">

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
            <div class="header-section d-flex justify-content-between align-items-center">
                <a href="javascript:history.back()" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Pestaña anterior
                </a>
                <div class="logo-wrapper text-center flex-grow-1">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo img-fluid">
                </div>
            </div>

            <!-- Tarjeta Principal Gris -->
            <div class="registrar-card">
                <h3 class="registrar-card-title text-center">Registrar alumno</h3>

                <form id="formRegistro">
                    <div class="row g-3">

                        <!-- Columna Izquierda -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre(s)</label>
                                <input type="text" class="custom-input form-control" id="nombre" name="txtNombre" required>
                            </div>
                            <div class="mb-3">
                                <label for="apellidoPaterno" class="form-label">Apellido paterno</label>
                                <input type="text" class="custom-input form-control" id="apellidoPaterno" name="txtApellidoPaterno" required>
                            </div>
                            <div class="mb-3">
                                <label for="apellidoMaterno" class="form-label">Apellido materno</label>
                                <input type="text" class="custom-input form-control" id="apellidoMaterno" name="txtApellidoMaterno" required>
                            </div>
                            <div class="mb-3">
                                <label for="matricula" class="form-label">Matrícula</label>
                                <input type="text" class="custom-input form-control" id="matricula" name="txtMatricula" required>
                            </div>
                        </div>

                        <!-- Columna Derecha -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="password" class="form-label">Contraseña</label>
                                <input type="password" class="custom-input form-control" id="password" name="txtPassword" minlength="8" maxlength="16" required>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirmar contraseña</label>
                                <input type="password" class="custom-input form-control" id="confirmPassword" name="txtConfirmPassword" required>
                            </div>
                            <div class="mb-3">
                                <label for="correo" class="form-label">Correo electrónico</label>
                                <input type="email" class="custom-input form-control" id="correo" name="txtCorreo" required>
                            </div>

                            <div class="row g-2">
                                <div class="col-6">
                                    <label for="carrera" class="form-label">Carrera</label>
                                    <select class="custom-select form-control" id="carrera" name="carrera" required>
                                        <option value="" disabled selected hidden>Selecciona tu carrera</option>
                                        <option value="DSM">Desarrollo de Software</option> <!-- Reemplazar esto -->
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label for="grupo" class="form-label">Grupo</label>
                                    <select class="custom-select form-control" id="grupo" name="grupo" required>
                                        <option value="" disabled selected hidden>Selecciona tu grupo</option>
                                        <option value="DSM3D">3°D</option><!-- Reemplazar esto -->
                                    </select>
                                </div>
                            </div>
                        </div>

                    </div>
                    <!-- Botones de Acción -->
                    <div class="actions-container mt-4 d-flex justify-content-between">
                        <a href="javascript:history.back()" class="btn-action btn-cancel">Cancelar</a>

                        <button type="button"
                                class="btn-action btn-registrar"
                                onclick="confirmarRegistroMaestro(event, document.getElementById('formRegistro'))">
                            Registrar
                        </button>
                    </div>

                    <!-- Enlace inferior de registro de grupo -->
                    <div class="text-center mt-3">
                        <span class="no-grupo-text">¿No encuentras tu grupo? </span>
                        <a href="${pageContext.request.contextPath}/views/admin/registro_grupo.jsp" class="registralo-link">Regístralo aquí</a>
                    </div>
                </form>
            </div>
        </div>

    </main>
</div>

<!-- Script AJAX para la validación -->
<script>
    const contextPath = "${pageContext.request.contextPath}";
    const modalCodigoBs = new bootstrap.Modal(document.getElementById('modalCodigo'));

    // 1. Manejar el evento Submit del Formulario
    document.getElementById('formRegistro').addEventListener('submit', function (e) {
        e.preventDefault();

        const alertBox = document.getElementById('alertBox');
        const btnEnviar = document.getElementById('btnEnviar');
        const spinnerBtn = document.getElementById('spinnerBtn');

        const pass = document.getElementById('password').value;
        const confirmPass = document.getElementById('confirmPassword').value;

        // Validar contraseñas iguales antes de enviar
        if (pass !== confirmPass) {
            alertBox.textContent = 'Las contraseñas no coinciden.';
            alertBox.classList.remove('d-none');
            return;
        }

        alertBox.classList.add('d-none');
        btnEnviar.disabled = true;
        spinnerBtn.classList.remove('d-none');

        const formData = new URLSearchParams(new FormData(this));
        formData.append('accion', 'enviarCodigo');

        fetch(contextPath + '/RegistroAlumnoServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: formData.toString()
        })
            .then(response => response.json())
            .then(data => {
                btnEnviar.disabled = false;
                spinnerBtn.classList.add('d-none');

                if (data.status === 'ok') {
                    // Limpiar campos del modal y mostrarlo
                    document.getElementById('inputCodigoVerificacion').value = '';
                    document.getElementById('modalAlertBox').classList.add('d-none');
                    modalCodigoBs.show();
                } else {
                    alertBox.textContent = data.message;
                    alertBox.classList.remove('d-none');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                btnEnviar.disabled = false;
                spinnerBtn.classList.add('d-none');
                alertBox.textContent = 'Ocurrió un error al procesar la solicitud.';
                alertBox.classList.remove('d-none');
            });
    });

    // 2. Manejar la verificación del código ingresado en el Modal
    document.getElementById('btnValidarCodigo').addEventListener('click', function () {
        const codigo = document.getElementById('inputCodigoVerificacion').value.trim();
        const modalAlertBox = document.getElementById('modalAlertBox');
        const btnValidar = document.getElementById('btnValidarCodigo');
        const spinnerModal = document.getElementById('spinnerModal');

        if (codigo.length !== 6) {
            modalAlertBox.textContent = 'Por favor ingresa un código de 6 dígitos.';
            modalAlertBox.classList.remove('d-none');
            return;
        }

        modalAlertBox.classList.add('d-none');
        btnValidar.disabled = true;
        spinnerModal.classList.remove('d-none');

        const bodyData = new URLSearchParams();
        bodyData.append('accion', 'validarCodigo');
        bodyData.append('txtCodigo', codigo);

        fetch(contextPath + '/RegistroAlumnoServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: bodyData.toString()
        })
            .then(response => response.json())
            .then(data => {
                btnValidar.disabled = false;
                spinnerModal.classList.add('d-none');

                if (data.status === 'ok') {
                    // Redirigir al inicio de sesión con parámetro de éxito
                    window.location.href = contextPath + '/index.jsp?registro=exito';
                } else {
                    modalAlertBox.textContent = data.message;
                    modalAlertBox.classList.remove('d-none');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                btnValidar.disabled = false;
                spinnerModal.classList.add('d-none');
                modalAlertBox.textContent = 'Ocurrió un error al validar el código.';
                modalAlertBox.classList.remove('d-none');
            });
    });
</script>


<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />