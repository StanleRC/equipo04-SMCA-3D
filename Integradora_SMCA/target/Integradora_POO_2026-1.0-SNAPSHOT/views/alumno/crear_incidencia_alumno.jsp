<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String labSeleccionado = request.getParameter("lab");
    if (labSeleccionado == null) {
        labSeleccionado = "";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Bitácora - Alumno</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrarinsidencia_alumno.css?v=2">
</head>
<body>

<div class="main-container">

    <div class="logo-container">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo" style="max-height: 110px;">
    </div>

    <div class="card-register">

        <div class="avatar-header">
            <i class="bi bi-person-fill"></i>
        </div>

        <h2 class="card-title-custom">Bienvenido a la bitácora digital</h2>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger text-center mb-3">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <!-- Procesa el formulario hacia RegistrarIncidenciaServlet -->
        <form action="${pageContext.request.contextPath}/RegistrarIncidenciaServlet" method="POST">

            <!-- Fila 1: Número de PC y Selección de Aula -->
            <div class="row g-3 mb-3">
                <div class="col-6">
                    <input type="text"
                           name="numeroPc"
                           class="form-control custom-input"
                           placeholder="Numero de PC"
                           required>
                </div>

                <div class="col-6">
                    <select name="laboratorio" class="form-select custom-input" required>
                        <option value="" disabled selected>Selecciona aula</option>

                        <optgroup label="CECADEC">
                            <option value="1">CC 10</option>
                            <option value="2">CC 11</option>
                            <option value="3">CC 12</option>
                            <option value="4">CC 13</option>
                        </optgroup>

                        <optgroup label="Docencia 4">
                            <option value="5">CA 1</option>
                            <option value="6">CA 2</option>
                            <option value="7">CA 3</option>
                            <option value="8">CA 4</option>
                            <option value="9">CA 5</option>
                            <option value="10">CA 6</option>
                            <option value="11">CA 11</option>
                        </optgroup>

                        <optgroup label="CEDIM">
                            <option value="12">CC 1</option>
                            <option value="13">CC 2</option>
                        </optgroup>
                    </select>
                </div>
            </div>

            <!-- Fila 2: Prioridad (Sin required) y Hora de Salida -->
            <div class="row g-3 mb-4">
                <div class="col-6">
                    <select name="prioridad" class="form-select custom-input">
                        <option value="Media" selected>Prioridad (por defecto Media)</option>
                        <option value="Baja">Baja</option>
                        <option value="Media">Media</option>
                        <option value="Alta">Alta</option>
                    </select>
                </div>

                <div class="col-6">
                    <input type="time"
                           name="horaFin"
                           class="form-control custom-input"
                           title="Hora de salida"
                           required>
                </div>
            </div>

            <h3 class="card-subtitle-custom">¿El equipo presenta alguna falla? (Opcional)</h3>

            <!-- Descripción de la Incidencia ( name="descripcion_falla" ) -->
            <div class="mb-4">
                <textarea name="descripcion_falla"
                          class="form-control custom-textarea"
                          rows="4"
                          placeholder="Describe la incidencia..."></textarea>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-siguiente">Siguiente</button>
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