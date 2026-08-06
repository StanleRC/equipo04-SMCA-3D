<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Bitácora - Alumno</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- CSS Personalizado -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrarinsidencia_alumno.css?v=2">
</head>
<body>

<div class="main-container">

    <!-- Logo UTEZ Superior -->
    <div class="logo-container">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo" style="max-height: 110px;">
    </div>

    <!-- Tarjeta Principal de Registro -->
    <div class="card-register">

        <!-- Avatar Circular Flotante -->
        <div class="avatar-header">
            <i class="bi bi-person-fill"></i>
        </div>

        <!-- Título -->
        <h2 class="card-title-custom">Bienvenido a la bitácora digital</h2>

        <!-- Formulario -->
        <form action="${pageContext.request.contextPath}/bitacora_servlet" method="POST">

            <!-- Fila de Inputs (Número de PC y Hora de salida) -->
            <div class="row g-3 mb-4">
                <div class="col-6">
                    <input type="text"
                           name="numeroPc"
                           class="form-control custom-input"
                           placeholder="Numero de PC"
                           required>
                </div>
                <div class="col-6 position-relative">
                    <input type="text"
                           name="horaSalida"
                           class="form-control custom-input pe-4"
                           placeholder="Hora de salida"
                           onfocus="(this.type='time')"
                           onblur="(this.type='text')">
                    <i class="bi bi-arrow-down short-arrow-icon"></i>
                </div>
            </div>

            <!-- Pregunta e Incidencias -->
            <h3 class="card-subtitle-custom">¿El equipo presenta alguna falla?</h3>

            <div class="mb-4">
                    <textarea name="incidencia"
                              class="form-control custom-textarea"
                              rows="4"
                              placeholder="Ingresa la incidencia (Opcional)...."></textarea>
            </div>

            <!-- Botón Siguiente -->
            <div class="text-center">
                <button type="submit" class="btn btn-siguiente">Siguiente</button>
            </div>
        </form>
    </div>

    <!-- Enlace Inferior Izquierdo: Sobre Nosotros -->
    <a href="${pageContext.request.contextPath}/sobrenosotros.jsp" class="sobre-nosotros-link">
        <i class="bi bi-info-circle"></i>
        <span><u>Sobre Nosotros</u></span>
    </a>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

