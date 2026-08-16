<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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

<!-- Sidebar Alumno -->
<jsp:include page="/views/layout/sidebar_alumno.jsp" />

<div class="main-content">

    <header class="top-header">
        <h1 class="top-title">Historial de Compu Aula</h1>
    </header>

    <div class="content-body">

        <div class="mb-2">
            <a href="javascript:history.back()" class="back-link">
                <i class="bi bi-arrow-left"></i> <u>Pestaña anterior</u>
            </a>
        </div>

        <div class="text-center mb-3">
            <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 140px;">
        </div>

        <div class="table-outer-wrapper">

            <div class="filter-buttons-wrapper">
                <button class="btn-filter">Fecha <i class="bi bi-funnel"></i></button>
                <button class="btn-filter">Hora <i class="bi bi-funnel"></i></button>
            </div>

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
                    <c:choose>
                        <c:when test="${not empty listaHistorial}">
                            <c:forEach var="item" items="${listaHistorial}">
                                <tr class="${item.estado eq 'Pendiente' ? 'row-pending' : ''}">
                                    <td><strong>${item.grado}</strong></td>
                                    <td><strong>${item.grupo}</strong></td>
                                    <td><strong>${item.numeroPc}</strong></td>
                                    <td><strong>${item.matricula}</strong></td>
                                    <td class="text-start ps-3 fw-bold">${item.nombreCompleto}</td>
                                    <td><strong>${item.fecha}</strong></td>
                                    <td class="text-start ps-3 fw-bold">${item.incidencia}</td>
                                    <td>
                                        <span class="status-text ${item.estado eq 'Pendiente' ? 'text-muted' : 'fw-bold'}">
                                                ${item.estado}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">
                                    No cuentas con registros de asistencia en la bitácora.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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