<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Alumno - Bitácora Digital UTEZ</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- CSS del registro -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registro_directo_alumno.css?v=1.1">

    <style>
        .custom-select {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-color: #fff;
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 0.375rem 2.25rem 0.375rem 0.75rem;
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2224%22%20height%3D%2224%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23495057%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22%2F%3E%3C%2Fsvg%3E');
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 16px 16px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        .custom-select:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25), 0 1px 2px rgba(0,0,0,0.05);
        }
    </style>
</head>

<body>

<div class="main-container">

    <!-- Logo Superior -->
    <header class="utez-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
    </header>

    <!-- Tarjeta Principal de Registro -->
    <main class="register-card">

        <h2 class="register-title">Registro alumno</h2>

        <!-- Mensaje de alerta general -->
        <div id="alertBox" class="alert alert-danger text-center p-2 mb-3 d-none" style="font-size: 13px;"></div>

        <!-- Formulario -->
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
                        <input type="password" class="custom-input form-control" id="password" name="txtPassword" required>
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
                                <option value="DSM">Desarrollo de Software</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label for="grupo" class="form-label">Grupo</label>
                            <select class="custom-select form-control" id="grupo" name="grupo" required>
                                <option value="" disabled selected hidden>Selecciona tu grupo</option>
                                <option value="DSM3D">3°D</option>
                            </select>
                        </div>
                    </div>
                </div>

            </div>

            <div class="actions-container mt-3 d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-cancel">Cancelar</a>
                <button type="submit" id="btnEnviar" class="btn btn-next">
                    <span id="spinnerBtn" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Siguiente
                </button>
            </div>

        </form>

    </main>

</div>

<!-- ========================================================= -->
<!-- MODAL DE VERIFICACIÓN DE CÓDIGO -->
<!-- ========================================================= -->
<div class="modal fade" id="modalCodigo" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalCodigoLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="modalCodigoLabel">
                    <i class="bi bi-shield-check me-2"></i>Validación de Correo
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <p class="text-center text-muted small">
                    Te hemos enviado un correo con tu código de validación. Revisa tu bandeja de entrada o spam e ingrésalo a continuación:
                </p>

                <div id="modalAlertBox" class="alert alert-danger text-center p-2 d-none" style="font-size: 13px;"></div>

                <div class="mb-3">
                    <label for="inputCodigoVerificacion" class="form-label fw-bold text-center w-100">Código de 6 dígitos</label>
                    <input type="text" class="form-control text-center fw-bold fs-4" id="inputCodigoVerificacion" maxlength="6" placeholder="000000" style="letter-spacing: 5px;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" id="btnValidarCodigo" class="btn btn-success fw-bold">
                    <span id="spinnerModal" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Validar y Registrar
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

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

</body>
</html>