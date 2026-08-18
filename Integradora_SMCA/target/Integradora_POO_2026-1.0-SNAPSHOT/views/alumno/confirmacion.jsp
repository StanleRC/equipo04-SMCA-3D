<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirmación - Bitácora Digital</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrarinsidencia_alumno.css?v=2">
</head>
<body>

<div class="main-container">

    <div class="logo-container mb-4">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo" style="max-height: 110px;">
    </div>

    <div class="card-register text-center p-4">

        <div class="mb-3 text-success">
            <i class="bi bi-check-circle-fill" style="font-size: 4rem;"></i>
        </div>

        <h2 class="card-title-custom text-success fw-bold mb-3">¡Registro Exitoso!</h2>

        <p class="fs-5 text-secondary mb-4">
            Tu asistencia y reporte han sido registrados correctamente en la bitácora digital.
        </p>

        <div class="d-grid gap-2 col-8 mx-auto">
            <a href="${pageContext.request.contextPath}/views/alumno/perfil_alumno.jsp" class="btn btn-siguiente py-2 fs-6">
                <i class="bi bi-plus-lg me-2"></i>Finalizar
            </a>
        </div>

    </div>

    <a href="${pageContext.request.contextPath}/sobrenosotros.jsp" class="sobre-nosotros-link mt-4">
        <i class="bi bi-info-circle"></i>
        <span><u>Sobre Nosotros</u></span>
    </a>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>