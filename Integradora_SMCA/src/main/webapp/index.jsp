<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitácora Digital - UTEZ</title>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- CSS de Login -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.6">

    <style>
        .form-row-inline {
            display: flex;
            gap: 10px;
            justify-content: space-between;
            margin-bottom: 20px;
            align-items: flex-end;
        }
        .form-row-inline .input-icon-wrapper {
            flex: 1;
            margin-bottom: 0;
            display: flex;
            flex-direction: column;
        }
        .form-row-inline input, .form-row-inline select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
            height: 40px;
        }
        .small-label {
            font-size: 11px;
            color: #666;
            margin-bottom: 4px;
            text-align: center;
            font-weight: bold;
        }
    </style>
</head>

<body class="login-body">

<div class="login-page-container">

    <header class="login-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
        <h1 class="system-title">Bitácora digital</h1>
    </header>

    <main class="login-card">

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="error-message-text" style="color: red; text-align: center; margin-bottom: 10px;">
                    ${requestScope.errorMessage}
            </div>
        </c:if>

        <div class="login-avatar-container">
            <div class="login-avatar-circle">
                <img src="${pageContext.request.contextPath}/assets/img/logologis.png" alt="Logo Bitácora" class="avatar-img">
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/loginServlet" method="POST" class="login-form">

            <!-- Campo OCULTO para capturar la hora de entrada (hora actual) automáticamente -->
            <input type="hidden" id="horaEntrada" name="horaEntrada">

            <div class="form-group">
                <label for="matricula" class="input-label" style="text-align: center; display: block; font-weight: bold;">Matrícula</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-envelope icon-input"></i>
                    <input type="text" id="matricula" name="matricula" placeholder="Introduce tu matrícula" required>
                </div>
            </div>

            <div class="form-group">
                <label for="password" class="input-label" style="text-align: center; display: block; font-weight: bold;">Contraseña</label>
                <div class="input-icon-wrapper">
                    <i class="bi bi-lock icon-input"></i>
                    <input type="password" id="password" name="password" placeholder="Introduce una contraseña" required>
                </div>
            </div>

            <!-- Fila de 3 columnas (PC, Aula, Hora de Salida) -->
            <div class="form-row-inline">
                <!-- Número de PC -->
                <div class="input-icon-wrapper">
                    <input type="text" id="numeroPc" name="numeroPc" placeholder="No. de PC" maxlength="10" required>
                </div>

                <!-- Aula -->
                <div class="input-icon-wrapper">
                    <select id="aula" name="aula" class="login-select" required>
                        <option value="">Aula</option>
                        <option value="CC10">CC 10</option>
                        <option value="CC11">CC 11</option>
                        <option value="CC12">CC 12</option>
                        <option value="CC13">CC 13</option>
                        <option value="CA1">CA 1</option>
                        <option value="CA2">CA 2</option>
                        <option value="CA3">CA 3</option>
                        <option value="CA4">CA 4</option>
                        <option value="CC1">CC 1</option>
                        <option value="CC2">CC 2</option>
                    </select>
                </div>

                <!-- Hora de Salida -->
                <div class="input-icon-wrapper">
                    <span class="small-label">Hora de salida</span>
                    <input type="time" id="hora" name="hora" required>
                </div>
            </div>

            <div class="button-container" style="text-align: center; margin-top: 15px;">
                <button type="submit" class="btn-submit">Iniciar sesión</button>
            </div>

            <div class="card-links-container" style="text-align: center; margin-top: 10px;">
                <a href="${pageContext.request.contextPath}/recuperar_pass.jsp" class="card-link bold-link">¿Olvidaste tu contraseña?</a>
            </div>

            <div class="card-footer-links" style="display: flex; justify-content: space-between; margin-top: 15px;">
                <a href="${pageContext.request.contextPath}/views/alumno/registro_directo_alumno.jsp" class="card-link">¿No tienes cuenta?</a>
                <a href="${pageContext.request.contextPath}/admin-docente_login.jsp" class="card-link">¿Eres docente?</a>
            </div>
        </form>
    </main>

    <footer class="login-footer" style="position: absolute; bottom: 10px; left: 10px;">
        <a href="javascript:void(0);" class="about-us-link" id="openModalBtn">
            <i class="bi bi-info-circle"></i>
            <span>Sobre Nosotros</span>
        </a>
    </footer>

</div>

<script src="${pageContext.request.contextPath}/assets/js/sobrenosotros.js"></script>
<script>
    // Obtener la hora actual al cargar la página
    document.addEventListener('DOMContentLoaded', function () {
        const now = new Date();
        const hh = String(now.getHours()).padStart(2, '0');
        const mm = String(now.getMinutes()).padStart(2, '0');
        const horaActual = hh + ':' + mm;

        // Asignar la hora actual al campo oculto de hora de ENTRADA
        const horaEntradaInput = document.getElementById('horaEntrada');
        if (horaEntradaInput) {
            horaEntradaInput.value = horaActual;
        }

        // Asignar también la hora actual al campo visible (Hora de salida) por defecto si está vacío
        const horaSalidaInput = document.getElementById('hora');
        if (horaSalidaInput && !horaSalidaInput.value) {
            horaSalidaInput.value = horaActual;
        }
    });
</script>
</body>
</html>