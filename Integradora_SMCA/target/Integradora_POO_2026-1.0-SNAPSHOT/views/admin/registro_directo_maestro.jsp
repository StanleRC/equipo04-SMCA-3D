<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Maestro - UTEZ</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

        <form action="${pageContext.request.contextPath}/registrarMaestroServlet" method="POST">
            <div class="row g-3">

                <!-- Columna Izquierda -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre(s)</label>
                        <input type="text" id="nombre" class="form-control custom-input" name="txtNombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="apellidoPaterno" class="form-label">Apellido paterno</label>
                        <input type="text" id="apellidoPaterno" class="form-control custom-input" name="txtApellidoPaterno" required>
                    </div>
                    <div class="mb-3">
                        <label for="apellidoMaterno" class="form-label">Apellido materno</label>
                        <input type="text" id="apellidoMaterno" class="form-control custom-input" name="txtApellidoMaterno" required>
                    </div>
                    <div class="mb-3">
                        <label for="correo" class="form-label">Correo electrónico</label>
                        <input type="email" id="correo" class="form-control custom-input" name="txtCorreo" required>
                    </div>
                </div>

                <!-- Columna Derecha -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="password" class="form-label">Contraseña</label>
                        <input type="password" id="password" class="form-control custom-input" name="txtPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirmar contraseña</label>
                        <input type="password" id="confirmPassword" class="form-control custom-input" name="txtConfirmPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="tel" id="telefono" class="form-control custom-input" name="txtTelefono" required>
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
</body>
</html>
