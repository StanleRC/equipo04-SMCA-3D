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

<!-- Bootstrap 5 CSS (para el modal) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

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

                <!-- Mensaje de alerta general -->
                <div id="alertBox" class="alert alert-danger text-center p-2 mb-3 d-none" style="font-size: 13px;"></div>

                <form id="formRegistrarAlumno">
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
                                <label for="matricula" class="form-label">Matrícula</label>
                                <input type="text" id="matricula" name="txtMatricula" class="form-control custom-input" required>
                            </div>
                        </div>

                        <!-- Columna Derecha -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="correo" class="form-label">Correo electrónico</label>
                                <input type="email" id="correo" name="txtCorreo" class="form-control custom-input" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Contraseña</label>
                                <input type="password" id="password" name="txtPassword" class="form-control custom-input" minlength="8" maxlength="16" required>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirmar contraseña</label>
                                <input type="password" id="confirmPassword" name="txtConfirmPassword" class="form-control custom-input" required>
                            </div>

                            <!-- Carrera y Grupo lado a lado -->
                            <div class="row g-2 mb-3">
                                <div class="col-7">
                                    <label for="carrera" class="form-label">Carrera</label>
                                    <select id="carrera" name="carrera" class="form-select custom-input custom-select" required>
                                        <option value="" disabled selected hidden>Selecciona tu carrera</option>
                                        <option value="DS">Desarrollo de software</option>
                                        <option value="DA">Diseño y animación</option>
                                        <option value="DM">Diseño de modas</option>
                                    </select>
                                </div>
                                <div class="col-5">
                                    <label for="grupo" class="form-label">Grupo</label>
                                    <select id="grupo" name="grupo" class="form-select custom-input custom-select" required>
                                        <option value="" disabled selected hidden>Selecciona tu grupo</option>
                                        <option value="3A">3°A</option>
                                        <option value="3B">3°B</option>
                                        <option value="3C">3°C</option>
                                        <option value="3D">3°D</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="actions-container mt-4 d-flex justify-content-between">
                        <a href="javascript:history.back()" class="btn-action btn-cancel">Cancelar</a>

                        <button type="submit" id="btnRegistrar" class="btn-action btn-registrar">
                            <span id="spinnerBtn" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
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

<!-- Bootstrap 5 JS (para el modal) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script AJAX para validación y registro (estructura de 2 pasos sin email) -->
<script>
    const contextPath = "${pageContext.request.contextPath}";

    // 1. Manejar el evento Submit del Formulario
    document.getElementById('formRegistrarAlumno').addEventListener('submit', function (e) {
        e.preventDefault();

        const alertBox = document.getElementById('alertBox');
        const btnRegistrar = document.getElementById('btnRegistrar');
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
        btnRegistrar.disabled = true;
        spinnerBtn.classList.remove('d-none');

        const formData = new URLSearchParams(new FormData(this));
        formData.append('accion', 'validarDatos');

        fetch(contextPath + '/RegistrarAlumnoDocenteServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: formData.toString()
        })
            .then(response => response.json())
            .then(data => {
                btnRegistrar.disabled = false;
                spinnerBtn.classList.add('d-none');

                if (data.status === 'ok') {
                    // Datos validados, proceder al registro
                    mostrarConfirmacionRegistro();
                } else {
                    alertBox.textContent = data.message;
                    alertBox.classList.remove('d-none');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                btnRegistrar.disabled = false;
                spinnerBtn.classList.add('d-none');
                alertBox.textContent = 'Ocurrió un error al procesar la solicitud.';
                alertBox.classList.remove('d-none');
            });
    });

    // 2. Mostrar confirmación y registrar
    function mostrarConfirmacionRegistro() {
        const matricula = document.getElementById('matricula').value.trim().toLowerCase();

        Swal.fire({
            title: '¿Registrar alumno?',
            text: 'Matrícula: ' + matricula,
            icon: 'question',
            showCancelButton: true,
            confirmButtonText: 'Registrar',
            cancelButtonText: 'Cancelar',
            reverseButtons: false,
            customClass: {
                popup: 'figma-modal',
                title: 'figma-title',
                confirmButton: 'figma-btn-confirm',
                cancelButton: 'figma-btn-cancel'
            }
        }).then((result) => {
            if (result.isConfirmed) {
                registrarAlumno();
            }
        });
    }

    // 3. Registrar alumno en BD
    function registrarAlumno() {
        const bodyData = new URLSearchParams();
        bodyData.append('accion', 'registrar');

        fetch(contextPath + '/RegistrarAlumnoDocenteServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: bodyData.toString()
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'ok') {
                    Swal.fire({
                        title: '¡Éxito!',
                        text: data.message,
                        icon: 'success',
                        confirmButtonText: 'Aceptar',
                        confirmButtonColor: '#0b8a72',
                        customClass: {
                            popup: 'figma-modal',
                            title: 'figma-title',
                            confirmButton: 'figma-btn-confirm'
                        }
                    }).then(() => {
                        document.getElementById('formRegistrarAlumno').reset();
                        history.back();
                    });
                } else {
                    Swal.fire({
                        title: 'Error',
                        text: data.message,
                        icon: 'error',
                        confirmButtonText: 'Aceptar',
                        confirmButtonColor: '#dc3545',
                        customClass: {
                            popup: 'figma-modal',
                            title: 'figma-title',
                            confirmButton: 'figma-btn-confirm'
                        }
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    title: 'Error',
                    text: 'Error al procesar el registro.',
                    icon: 'error',
                    confirmButtonText: 'Aceptar',
                    confirmButtonColor: '#dc3545',
                    customClass: {
                        popup: 'figma-modal',
                        title: 'figma-title',
                        confirmButton: 'figma-btn-confirm'
                    }
                });
            });
    }
</script>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />