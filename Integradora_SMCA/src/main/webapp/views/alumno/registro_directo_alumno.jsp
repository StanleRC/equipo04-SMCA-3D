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
            border-radius: 8px; /* O el radio que tenga en Figma */
            padding: 0.375rem 2.25rem 0.375rem 0.75rem;
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2224%22%20height%3D%2224%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%23495057%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpath%20d%3D%22M6%209l6%206%206-6%22%2F%3E%3C%2Fsvg%3E');
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 16px 16px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05); /* Sombra ligera estilo Figma */
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
                <button type="submit" class="btn btn-next">Siguiente</button>
            </div>

        </form>

    </main>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Definición de variables JSP antes de cargar el archivo JS -->
<script>
    window.APP_CONFIG = {
        usuarioNombre: "${sessionScope.usuarioLogueado.nombre}",
        contextPath: "${pageContext.request.contextPath}"
    };
</script>

<!-- Importar el archivo JS (con ?v=2 para obligar al navegador a recargar el JS actualizado) -->
<script src="${pageContext.request.contextPath}/assets/js/modal_bienvenida_alumno.js?v=2"></script>
</body>
</html>