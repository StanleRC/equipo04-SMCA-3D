<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Escritorio Alumno - Bitácora Digital</title>

    <!-- Bootstrap 5 CSS e Iconos -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- CSS Personalizado con Colores UTEZ -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/utez-theme.css?v=3">
</head>
<body class="bg-light">

<div class="main-wrapper">

    <!-- Menú lateral verde existente -->
    <jsp:include page="/views/layout/sidebar_alumno.jsp" />

    <!-- Área principal de trabajo con el margen correcto para el sidebar -->
    <div class="main-content">

        <!-- Barra de Bienvenida Superior estilo UTEZ -->
        <header class="top-welcome-bar">
            Sistema de Bitácora Digital - DATID UTEZ
        </header>

        <!-- Contenido Central del Escritorio -->
        <main class="registro-grupo-body">
            <div class="header-section text-center">
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo mb-2">
                <h2 class="page-subtitle">Escritorio de Alumno</h2>
            </div>

            <!-- Tarjeta Principal -->
            <div class="registro-card">
                <h3 class="registro-card-title">Panel de Control</h3>
                <p class="text-muted text-center">
                    Bienvenido al sistema. Desde aquí puedes monitorear tus accesos, consultar tu historial o reportar fallas en los laboratorios de cómputo.
                </p>
            </div>
        </main>

    </div> <!-- /.main-content -->

</div> <!-- /.main-wrapper -->

<!-- ============================================================ -->
<!-- WIDGET FLOTANTE DE BIENVENIDA (ESQUINA INFERIOR DERECHA)     -->
<!-- ============================================================ -->
<div id="widgetBienvenida" class="widget-bienvenida">

    <div class="widget-header">
        <span><i class="bi bi-clock-history me-1"></i> Bienvenida UTEZ</span>
        <button type="button" class="btn-close btn-close-white btn-sm" onclick="cerrarWidget()"></button>
    </div>

    <div class="widget-body">
        <h6 class="fw-bold text-dark mb-1">¡Hola, ${sessionScope.usuarioLogueado.nombre}!</h6>
        <p class="text-muted small mb-2" style="font-size: 12px;">Acceso rápido a tus opciones principales:</p>

        <!-- Reloj y Fecha -->
        <div class="alert alert-light border py-1 px-2 my-2 text-success fw-semibold shadow-sm" style="font-size: 13px;">
            <i class="bi bi-clock me-1"></i>
            <span id="relojServidor">Cargando hora...</span>
        </div>

        <!-- Botones con estilos UTEZ -->
        <div class="d-grid gap-2 mt-3">
            <a href="${pageContext.request.contextPath}/views/alumno/crear_incidencia_alumno.jsp" class="btn btn-action btn-cancelar py-2 px-3 fw-semibold w-100" style="background-color: #dc2626 !important;">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> Registrar incidencia
            </a>
        </div>
    </div>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Script para el reloj y mostrar la ventana emergente -->
<script src="${pageContext.request.contextPath}/assets/js/modal_bienvenida_alumno.js"></script>

</body>
</html>