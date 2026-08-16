<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        <form action="${pageContext.request.contextPath}/RegistrarIncidenciaServlet" method="POST">

            <div class="row g-3 mb-4">
                <div class="col-6">
                    <input type="text"
                           name="numeroPc"
                           class="form-control custom-input"
                           placeholder="Numero de PC"
                           required>
                </div>

                <div class="col-6">
                    <select name="laboratorio" class="form-control custom-input" required>
                        <option value="">Selecciona aula</option>
                        <option value="CC10">CC 10</option>
                        <option value="CC11">CC 11</option>
                        <option value="CC12">CC 12</option>
                        <option value="CC13">CC 13</option>
                        <option value="CA1">CA 1</option>
                        <option value="CA2">CA 2</option>
                        <option value="CA3">CA 3</option>
                        <option value="CA4">CA 4</option>
                        <option value="CA5">CA 5</option>
                        <option value="CA6">CA 6</option>
                        <option value="CA11">CA 11</option>
                        <option value="CC1">CC 1</option>
                        <option value="CC2">CC 2</option>
                    </select>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-12">
                    <select name="prioridad" class="form-control custom-input" required>
                        <option value="">Selecciona prioridad</option>
                        <option value="Baja">Baja</option>
                        <option value="Media" selected>Media</option>
                        <option value="Alta">Alta</option>
                    </select>
                </div>
            </div>

            <h3 class="card-subtitle-custom">¿El equipo presenta alguna falla?</h3>

            <div class="mb-4">
                <textarea name="incidencia"
                          class="form-control custom-textarea"
                          rows="4"
                          placeholder="Describe la incidencia..."></textarea>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-siguiente">Siguiente</button>
            </div>
        </form>
    </div>

    <a href="${pageContext.request.contextPath}/sobrenosotros.jsp" class="sobre-nosotros-link">
        <i class="bi bi-info-circle"></i>
        <span><u>Sobre Nosotros</u></span>
    </a>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>