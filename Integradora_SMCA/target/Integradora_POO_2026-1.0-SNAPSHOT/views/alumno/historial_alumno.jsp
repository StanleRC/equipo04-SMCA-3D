<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Compu Aula - Alumno</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- CSS Personalizado del Historial -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/historial_alumno.css?v=3">
</head>
<body>

<!-- Incluimos el Sidebar del Alumno -->
<jsp:include page="/views/layout/sidebar_alumno.jsp" />

<!-- Área de Contenido Principal -->
<div class="main-content">

    <!-- Banner Superior Azul -->
    <header class="top-header">
        <h1 class="top-title">Historial de Compu Aula</h1>
    </header>

    <!-- Cuerpo del Contenido -->
    <div class="content-body">

        <!-- Enlace Pestaña Anterior -->
        <div class="mb-2">
            <a href="javascript:history.back()" class="back-link">
                <i class="bi bi-arrow-left"></i> <u>Pestaña anterior</u>
            </a>
        </div>

        <!-- Logo UTEZ Centrado -->
        <div class="text-center mb-3">
            <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 140px;">
        </div>

        <!-- Contenedor de Tabla con Filtros -->
        <div class="table-outer-wrapper">

            <!-- Botones de Filtro (Fecha y Hora) a la Derecha -->
            <div class="filter-buttons-wrapper">
                <button class="btn-filter">Fecha <i class="bi bi-funnel"></i></button>
                <button class="btn-filter">Hora <i class="bi bi-funnel"></i></button>
            </div>

            <!-- Tabla de Historial -->
            <div class="table-responsive">
                <table class="table custom-table align-middle">
                    <thead>
                    <tr>
                        <th style="width: 7%;">Grado</th>
                        <th style="width: 7%;">Grupo</th>
                        <th style="width: 6%;">PC</th>
                        <th style="width: 14%;">Matrícula</th>
                        <th style="width: 22%;">Nombre</th>
                        <th style="width: 12%;">Fecha</th>
                        <th style="width: 20%;">Incidencia</th>
                        <th style="width: 12%;">Estado</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- Fila 1 (Gris tenue por ser registro reciente/pendiente) -->
                    <tr class="row-pending">
                        <td>3</td>
                        <td>D</td>
                        <td>08</td>
                        <td>20253ds104</td>
                        <td class="text-start ps-3">Julian Perez Perez</td>
                        <td>12/06/2026</td>
                        <td class="text-start ps-3">Ninguna</td>
                        <td><span class="status-text text-muted">Pendiente</span></td>
                    </tr>
                    <!-- Fila 2 -->
                    <tr>
                        <td><strong>3</strong></td>
                        <td><strong>D</strong></td>
                        <td><strong>07</strong></td>
                        <td><strong>20253ds104</strong></td>
                        <td class="text-start ps-3 fw-bold">Julian Perez Perez</td>
                        <td><strong>11/06/2026</strong></td>
                        <td class="text-start ps-3 fw-bold">El teclado no sirve</td>
                        <td><span class="status-text fw-bold">Validado</span></td>
                    </tr>
                    <!-- Fila 3 -->
                    <tr>
                        <td><strong>3</strong></td>
                        <td><strong>D</strong></td>
                        <td><strong>12</strong></td>
                        <td><strong>20253ds104</strong></td>
                        <td class="text-start ps-3 fw-bold">Julian Perez Perez</td>
                        <td><strong>10/06/2026</strong></td>
                        <td class="text-start ps-3 fw-bold">No prende el monitor</td>
                        <td><span class="status-text fw-bold">Validado</span></td>
                    </tr>
                    <!-- Fila 4 -->
                    <tr>
                        <td><strong>3</strong></td>
                        <td><strong>D</strong></td>
                        <td><strong>13</strong></td>
                        <td><strong>20253ds104</strong></td>
                        <td class="text-start ps-3 fw-bold">Julian Perez Perez</td>
                        <td><strong>08/06/2026</strong></td>
                        <td class="text-start ps-3 fw-bold">Ninguna</td>
                        <td><span class="status-text fw-bold">Descartado</span></td>
                    </tr>
                    <!-- Fila 5 -->
                    <tr>
                        <td><strong>3</strong></td>
                        <td><strong>D</strong></td>
                        <td><strong>07</strong></td>
                        <td><strong>20253ds104</strong></td>
                        <td class="text-start ps-3 fw-bold">Julian Perez Perez</td>
                        <td><strong>07/06/2026</strong></td>
                        <td class="text-start ps-3 fw-bold">Manchas en la pantalla</td>
                        <td><span class="status-text fw-bold">Validado</span></td>
                    </tr>
                    <!-- Fila 6 -->
                    <tr>
                        <td><strong>3</strong></td>
                        <td><strong>D</strong></td>
                        <td><strong>06</strong></td>
                        <td><strong>20253ds104</strong></td>
                        <td class="text-start ps-3 fw-bold">Julian Perez Perez</td>
                        <td><strong>05/06/2026</strong></td>
                        <td class="text-start ps-3 fw-bold">Ninguna</td>
                        <td><span class="status-text fw-bold">Descartado</span></td>
                    </tr>
                    <!-- Filas Vacías cuadradas como la maqueta -->
                    <tr class="empty-row"><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                    <tr class="empty-row"><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                    <tr class="empty-row"><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                    </tbody>
                </table>
            </div>

        </div>

    </div>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>