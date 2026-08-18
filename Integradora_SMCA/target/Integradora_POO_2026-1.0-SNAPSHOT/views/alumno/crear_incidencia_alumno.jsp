<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Esta pantalla es del alumno: sin sesión no tiene nada que hacer aquí.
    Object usuarioSesion = session.getAttribute("usuarioLogueado");
    if (usuarioSesion == null) {
        usuarioSesion = session.getAttribute("alumno");
    }
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // Permite llegar con el aula ya elegida: crear_incidencia_alumno.jsp?lab=CC11
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrarinsidencia_alumno.css?v=3">

    <style>
        /* Estilos acotados a esta pantalla */
        .contador-caracteres {
            display: block;
            text-align: right;
            font-size: 12px;
            color: #8a8a8a;
            margin-top: 4px;
        }

        .contador-caracteres.al-limite {
            color: #c0392b;
            font-weight: 600;
        }

        .etiqueta-campo {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #5a6b85;
            margin-bottom: 4px;
        }

        .nota-opcional {
            font-size: 12px;
            color: #8a8a8a;
            text-align: center;
            margin-bottom: 14px;
        }

        .btn-siguiente:disabled {
            opacity: .65;
            cursor: progress;
        }
    </style>
</head>
<body>

<div class="main-container">

    <div class="logo-container">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
             alt="Logo UTEZ" class="utez-logo" style="max-height: 110px;">
    </div>

    <div class="card-register">

        <div class="avatar-header">
            <i class="bi bi-person-fill"></i>
        </div>

        <h2 class="card-title-custom">Bienvenido a la bitácora digital</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center mb-3" role="alert">
                    ${error}
            </div>
        </c:if>

        <form id="formIncidencia"
              action="${pageContext.request.contextPath}/RegistrarIncidenciaServlet"
              method="POST" novalidate>

            <!-- Fila 1: PC y aula -->
            <div class="row g-3 mb-3">
                <div class="col-6">
                    <label for="numeroPc" class="etiqueta-campo">Número de PC</label>
                    <input type="text"
                           id="numeroPc"
                           name="numeroPc"
                           class="form-control custom-input"
                           placeholder="Ej. 08"
                           maxlength="10"
                           autocomplete="off"
                           required>
                </div>

                <div class="col-6">
                    <label for="laboratorio" class="etiqueta-campo">Aula</label>

                    <%--
                        Antes cada opción mandaba un id numérico (1, 2, 3...) escrito a mano.
                        Esos números no coincidían con los de la tabla LABORATORIO, que usa
                        IDENTITY: "CA 5" mandaba el 9, que en realidad es CC1, y las opciones
                        11, 12 y 13 no existían, así que el insert fallaba por la llave foránea.

                        Ahora se manda el nombre del aula. El DAO lo resuelve contra
                        laboratorio.aula, así que ya no depende de que los ids coincidan.
                    --%>
                    <select id="laboratorio" name="laboratorio" class="form-select custom-input" required>
                        <option value="" disabled <%= labSeleccionado.isEmpty() ? "selected" : "" %>>
                            Selecciona aula
                        </option>

                        <optgroup label="CECADEC">
                            <option value="CC10" <%= "CC10".equals(labSeleccionado) ? "selected" : "" %>>CC 10</option>
                            <option value="CC11" <%= "CC11".equals(labSeleccionado) ? "selected" : "" %>>CC 11</option>
                            <option value="CC12" <%= "CC12".equals(labSeleccionado) ? "selected" : "" %>>CC 12</option>
                            <option value="CC13" <%= "CC13".equals(labSeleccionado) ? "selected" : "" %>>CC 13</option>
                        </optgroup>

                        <optgroup label="Docencia 4">
                            <option value="CA1" <%= "CA1".equals(labSeleccionado) ? "selected" : "" %>>CA 1</option>
                            <option value="CA2" <%= "CA2".equals(labSeleccionado) ? "selected" : "" %>>CA 2</option>
                            <option value="CA3" <%= "CA3".equals(labSeleccionado) ? "selected" : "" %>>CA 3</option>
                            <option value="CA4" <%= "CA4".equals(labSeleccionado) ? "selected" : "" %>>CA 4</option>
                        </optgroup>

                        <optgroup label="CEDIM">
                            <option value="CC1" <%= "CC1".equals(labSeleccionado) ? "selected" : "" %>>CC 1</option>
                            <option value="CC2" <%= "CC2".equals(labSeleccionado) ? "selected" : "" %>>CC 2</option>
                        </optgroup>

                        <%--
                            CA 5, CA 6 y CA 11 estaban en el formulario pero nunca se
                            insertaron en la tabla LABORATORIO. Si las agregas allá,
                            añádelas aquí con su nombre de aula y funcionan solas.
                        --%>
                    </select>
                </div>
            </div>

            <!-- Fila 2: prioridad y hora de salida -->
            <div class="row g-3 mb-4">
                <div class="col-6">
                    <label for="prioridad" class="etiqueta-campo">Prioridad</label>
                    <select id="prioridad" name="prioridad" class="form-select custom-input">
                        <option value="Baja">Baja</option>
                        <option value="Media" selected>Media</option>
                        <option value="Alta">Alta</option>
                    </select>
                </div>

                <div class="col-6">
                    <label for="horaFin" class="etiqueta-campo">Hora de salida</label>
                    <input type="time"
                           id="horaFin"
                           name="horaFin"
                           class="form-control custom-input"
                           required>
                </div>
            </div>

            <h3 class="card-subtitle-custom">¿El equipo presenta alguna falla?</h3>
            <p class="nota-opcional">
                Si todo funcionó bien, deja este campo vacío y solo se registra tu uso del equipo.
            </p>

            <div class="mb-4">
                <textarea id="descripcionFalla"
                          name="descripcion_falla"
                          class="form-control custom-textarea"
                          rows="4"
                          maxlength="500"
                          placeholder="Describe la incidencia..."></textarea>

                <%-- descripcion_falla es CLOB, pero las tablas muestran 500 caracteres. --%>
                <small class="contador-caracteres" id="contador">0 / 500</small>
            </div>

            <div class="text-center">
                <button type="submit" id="btnEnviar" class="btn btn-siguiente">Siguiente</button>
            </div>
        </form>
    </div>

    <a href="${pageContext.request.contextPath}/views/sobrenosotros.jsp" class="sobre-nosotros-link">
        <i class="bi bi-info-circle"></i>
        <span><u>Sobre Nosotros</u></span>
    </a>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        var form = document.getElementById('formIncidencia');
        var btnEnviar = document.getElementById('btnEnviar');
        var textarea = document.getElementById('descripcionFalla');
        var contador = document.getElementById('contador');
        var horaFin = document.getElementById('horaFin');

        // La hora de salida arranca con la hora actual: es lo que el alumno pondría casi siempre.
        if (horaFin && !horaFin.value) {
            var ahora = new Date();
            horaFin.value = String(ahora.getHours()).padStart(2, '0') + ':' +
                String(ahora.getMinutes()).padStart(2, '0');
        }

        function actualizarContador() {
            var usados = textarea.value.length;
            contador.textContent = usados + ' / 500';
            contador.classList.toggle('al-limite', usados >= 480);
        }

        textarea.addEventListener('input', actualizarContador);
        actualizarContador();

        form.addEventListener('submit', function (evento) {
            var pc = document.getElementById('numeroPc');
            var aula = document.getElementById('laboratorio');

            if (pc.value.trim() === '') {
                evento.preventDefault();
                pc.focus();
                return;
            }

            if (aula.value === '') {
                evento.preventDefault();
                aula.focus();
                return;
            }

            // Evita que un doble clic registre la incidencia dos veces.
            btnEnviar.disabled = true;
            btnEnviar.textContent = 'Registrando...';
        });
    })();
</script>
</body>
</html>
