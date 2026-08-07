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

        <!-- Mensaje de error dinámico -->
        <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger text-center p-2 mb-3" style="font-size: 13px;">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <!-- Formulario -->
        <form action="${pageContext.request.contextPath}/RegistroAlumnoServlet" method="POST">
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
                        <div class="col-7">
                            <label for="carrera" class="form-label">Carrera</label>
                            <select class="custom-select form-select" id="carrera" name="carrera" required>
                                <option value="" disabled selected hidden>Selecciona tu carrera</option>
                                <option value="DSM">Desarrollo de Software</option>
                            </select>
                        </div>
                        <div class="col-5">
                            <label for="grupo" class="form-label">Grupo</label>
                            <select class="custom-select form-select" id="grupo" name="grupo" required>
                                <option value="" disabled selected hidden>Selecciona tu grupo</option>
                                <option value="DSM3D">3°D</option>
                            </select>
                        </div>
                    </div>
                </div>

            </div>

            <div class="actions-container mt-3 d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-cancel">Cancelar</a>
                <button type="submit" class="btn btn-next">Siguiente</button>
            </div>

        </form>

    </main>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
