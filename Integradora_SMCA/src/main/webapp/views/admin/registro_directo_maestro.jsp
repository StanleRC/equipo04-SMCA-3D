<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Maestro - UTEZ</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- SweetAlert2 & Alertas Personalizadas -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
    <script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

    <!-- CSS del registro -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrar_directo_maestro.css?v=1.0">
</head>

<body>

<div class="main-container">

    <!-- Logo Superior Centrado -->
    <header class="utez-header text-center mb-4">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
    </header>

    <!-- Tarjeta del Formulario -->
    <main class="register-card">

        <h2 class="register-title text-center mb-4">Registro maestro</h2>

        <form id="formRegistroDirectoMaestro" action="${pageContext.request.contextPath}/RegistroDocenteServlet" method="POST">
            <div class="row g-3">

                <!-- Columna Izquierda -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre(s)</label>
                        <input type="text" id="nombre" class="form-control custom-input" name="txtNombre" placeholder="Ingresa nombre(s)" autocomplete="off" required>
                    </div>
                    <div class="mb-3">
                        <label for="apellidoPaterno" class="form-label">Apellido paterno</label>
                        <input type="text" id="apellidoPaterno" class="form-control custom-input" name="txtApellidoPaterno" placeholder="Ingresa apellido paterno" autocomplete="off" required>
                    </div>
                    <div class="mb-3">
                        <label for="apellidoMaterno" class="form-label">Apellido materno</label>
                        <input type="text" id="apellidoMaterno" class="form-control custom-input" name="txtApellidoMaterno" placeholder="Ingresa apellido materno" autocomplete="off" required>
                    </div>
                    <div class="mb-3">
                        <label for="correo" class="form-label">Correo electrónico</label>
                        <input type="email" id="correo" class="form-control custom-input" name="txtCorreo" placeholder="maestro@utez.edu.mx" autocomplete="off" required>
                    </div>
                </div>

                <!-- Columna Derecha -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="password" class="form-label">Contraseña</label>
                        <input type="password" id="password" class="form-control custom-input" name="txtPassword" placeholder="••••••••" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirmar contraseña</label>
                        <input type="password" id="confirmPassword" class="form-control custom-input" name="txtConfirmPassword" placeholder="••••••••" required>
                    </div>
                    <div class="mb-3">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="tel" id="telefono" class="form-control custom-input" name="txtTelefono" placeholder="7771234567" autocomplete="off" required>
                    </div>
                </div>

            </div>

            <div class="actions-container mt-4 d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/admin-docente_login.jsp"
                   class="btn-action btn-cancel">Cancelar</a>
                <button type="submit" class="btn-action btn-registrar">Registrar</button>
            </div>

        </form>

    </main>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('formRegistroDirectoMaestro');

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
                    mostrarAlertaExito('¡Registro de maestro completado con éxito!', function() {
                        form.submit();
                    });
                } else {
                    form.submit();
                }
            });
        }
    });
</script>

</body>
</html>