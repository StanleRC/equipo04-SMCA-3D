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
    <header class="utez-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
    </header>

    <!-- Tarjeta del Formulario -->
    <main class="register-card">

        <h2 class="register-title">Registrar maestro</h2>

        <form action="${pageContext.request.contextPath}/registrarMaestroServlet" method="POST">
            <div class="row g-3">

                <!-- Columna Izquierda -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <input type="text" class="custom-input" name="txtNombre" placeholder="Nombre(s)" required>
                    </div>
                    <div class="mb-3">
                        <input type="text" class="custom-input" name="txtApellidoPaterno" placeholder="Apellido paterno" required>
                    </div>
                    <div class="mb-3">
                        <input type="text" class="custom-input" name="txtApellidoMaterno" placeholder="Apellido materno" required>
                    </div>
                    <div class="mb-3">
                        <input type="email" class="custom-input" name="txtCorreo" placeholder="Correo" required>
                    </div>
                </div>

                <!-- Columna Derecha -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <input type="password" class="custom-input" name="txtPassword" placeholder="Contraseña" required>
                    </div>
                    <div class="mb-3">
                        <input type="password" class="custom-input" name="txtConfirmPassword" placeholder="Confirme la contraseña" required>
                    </div>
                    <div class="mb-3">
                        <input type="tel" class="custom-input" name="txtTelefono" placeholder="Ingrese el teléfono" required>
                    </div>
                </div>

            </div>

            <!-- Botones de Acción -->
            <div class="actions-container">
                <a href="${pageContext.request.contextPath}/admin-docente_login.jsp" class="btn-cancel">Cancelar</a>
                <button type="submit" class="btn-registrar">Registrar</button>
            </div>
        </form>

    </main>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>