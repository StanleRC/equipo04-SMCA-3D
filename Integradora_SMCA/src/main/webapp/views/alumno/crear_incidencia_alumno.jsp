<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Incidencia - Alumno</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrarinsidencia_alumno.css?v=3">
</head>
<body>

<jsp:include page="/views/layout/sidebar_alumno.jsp" />
<c:set var="alu" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado : sessionScope.alumno}" />

<div class="main-container">

    <div class="logo-container">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo" style="max-height: 110px;">
    </div>

    <div class="card-register">

        <div class="avatar-header">
            <i class="bi bi-person-fill"></i>
        </div>

        <h2 class="card-title-custom">Registro de Incidencia</h2>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger text-center mb-3">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <!-- Procesa el formulario hacia RegistrarIncidenciaServlet -->
        <form action="${pageContext.request.contextPath}/RegistrarIncidenciaServlet" method="POST">

            <!-- Prioridad -->
            <div class="mb-3">
                <label for="prioridad" class="form-label">Prioridad</label>
                <select name="prioridad" id="prioridad" class="form-select custom-input">
                    <option value="Baja" selected>Baja</option>
                    <option value="Media">Media</option>
                    <option value="Alta">Alta</option>
                </select>
            </div>

            <!-- Descripción de la Incidencia -->
            <h3 class="card-subtitle-custom">¿Qué fallas presenta el equipo?</h3>
            <div class="mb-4">
                <textarea name="descripcion_falla"
                class="form-control custom-textarea"
                rows="4"
                placeholder="Describe la incidencia..."
                required></textarea>
            </div>

            <div class="actions-container mt-4 d-flex justify-content-between">
                <a href="../alumno/editar_perfil_alumno.jsp" class="btn-secundario">Cancelar</a>
                <button type="submit" class="btn-principal">Registrar</button>
            </div>
        </form>
    </div>

    <a href="${pageContext.request.contextPath}/views/sobrenosotros.jsp" class="sobre-nosotros-link">
        <i class="bi bi-info-circle"></i>
        <span><u>Sobre Nosotros</u></span>
    </a>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
