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

        <!-- CORREGIDO: Se ajustó el action a /RegistroAlumnoServlet -->
        <form action="${pageContext.request.contextPath}/RegistroAlumnoServlet" method="POST">
            <div class="row g-3">

                <!-- Columna Izquierda -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <input type="text" class="custom-input" id="nombre" name="txtNombre" placeholder="Nombre(s)" required>
                    </div>
                    <div class="mb-3">
                        <input type="text" class="custom-input" id="apellidoPaterno" name="txtApellidoPaterno" placeholder="Apellido paterno" required>
                    </div>
                    <div class="mb-3">
                        <input type="text" class="custom-input" id="apellidoMaterno" name="txtApellidoMaterno" placeholder="Apellido materno" required>
                    </div>
                    <div class="mb-3">
                        <input type="text" class="custom-input" id="matricula" name="txtMatricula" placeholder="Matricula" required>
                    </div>
                </div>

                <!-- Columna Derecha -->
                <div class="col-md-6">
                    <div class="mb-3">
                        <input type="password" class="custom-input" id="password" name="txtPassword" placeholder="Contraseña" required>
                    </div>
                    <div class="mb-3">
                        <input type="password" class="custom-input" id="confirmPassword" name="txtConfirmPassword" placeholder="Confirme la contraseña" required>
                    </div>
                    <div class="mb-3">
                        <input type="email" class="custom-input" id="correo" name="txtCorreo" placeholder="Ingrese su correo" required>
                    </div>

                    <div class="row g-2">
                        <div class="col-7">
                            <select class="custom-select" id="carrera" name="carrera" required>
                                <option value="" disabled selected hidden>Carrera</option>
                                <option value="DSM">Desarrollo de Software</option>
                            </select>
                        </div>
                        <div class="col-5">
                            <select class="custom-select" id="grupo" name="grupo" required>
                                <option value="" disabled selected hidden>Grupo</option>
                                <option value="DSM3D">3°D</option>
                            </select>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Botones de Acción -->
            <div class="actions-container mt-3">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn-cancel">Cancelar</a>
                <button type="submit" class="btn-next">Siguiente</button>
            </div>
        </form>

    </main>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>