<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Registro de grupo - UTEZ" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registro_grupo.css?v=2">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
<script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

<style>
    /* Vista previa del identificador que se va a generar */
    .previo-id {
        background: #eef3fb;
        border-radius: 10px;
        padding: 12px 16px;
        font-size: 13px;
        color: #3f4a5a;
        text-align: center;
        margin-bottom: 16px;
    }

    .previo-id strong {
        display: block;
        font-size: 19px;
        color: #1c3862;
        letter-spacing: .05em;
        margin-top: 4px;
    }

    .previo-id.vacio strong { color: #a3acbb; }

    .nota-campo {
        display: block;
        font-size: 11.5px;
        color: #8a8a8a;
        margin-top: 4px;
    }
</style>

<div class="main-wrapper">
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="registro-grupo-body">

            <div class="header-section">
                <div class="back-link-wrapper">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="bi bi-arrow-left"></i> Pestaña anterior
                    </a>
                </div>
                <div class="logo-wrapper text-center">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                         alt="Logo UTEZ" class="utez-logo img-fluid">
                    <h2 class="page-subtitle mt-2">Registro de grupo</h2>
                </div>
            </div>

            <div class="registro-card">
                <h3 class="registro-card-title text-center">Ingresa los datos<br>del grupo</h3>

                <form id="formRegistroGrupo"
                      action="${pageContext.request.contextPath}/RegistrarGrupoServlet"
                      method="POST">

                    <%--
                        Las carreras se cargan de la tabla CARRERA, no escritas a mano.
                        La lista de antes tenía DATSI, DADM y DATEC pero le faltaba DSM,
                        que es justo la carrera del único grupo que existe.
                    --%>
                    <div class="form-group mb-3">
                        <label for="txtCarrera" class="form-label">Carrera</label>
                        <select id="txtCarrera" name="txtCarrera"
                                class="form-select custom-input custom-select" required>
                            <option value="" disabled selected hidden>Cargando carreras...</option>
                        </select>
                    </div>

                    <div class="form-group mb-3">
                        <label for="txtCuatrimestre" class="form-label">Cuatrimestre</label>
                        <input type="number"
                               id="txtCuatrimestre"
                               name="txtCuatrimestre"
                               class="form-control custom-input"
                               placeholder="Ej. 3"
                               min="1" max="11"
                               required>
                        <small class="nota-campo">Un número del 1 al 11.</small>
                    </div>

                    <div class="form-group mb-3">
                        <label for="txtGrupo" class="form-label">Grupo</label>
                        <input type="text"
                               id="txtGrupo"
                               name="txtGrupo"
                               class="form-control custom-input"
                               placeholder="Ej. D"
                               maxlength="1"
                               required>
                        <small class="nota-campo">Una sola letra.</small>
                    </div>

                    <%--
                        id_grupo no es autonumérico: se arma con carrera + cuatrimestre
                        + letra. Mostrarlo antes de guardar evita crear duplicados por
                        no saber cómo iba a quedar.
                    --%>
                    <div class="previo-id vacio" id="previoId">
                        Identificador que se creará
                        <strong id="textoPrevioId">— — —</strong>
                    </div>

                    <div class="d-flex justify-content-center gap-4 mt-4">
                        <a href="javascript:history.back()"
                           class="btn-action btn-cancelar text-decoration-none text-center">Cancelar</a>

                        <button type="submit" id="btnRegistrar" class="btn-action btn-registrar">
                            Registrar
                        </button>
                    </div>

                </form>
            </div>
        </div>

    </main>
</div>

<%-- Mensajes que devuelve RegistrarGrupoServlet en la URL --%>
<span id="flashExito" hidden><c:out value="${param.exito}" /></span>
<span id="flashError" hidden><c:out value="${param.error}" /></span>

<script>
    (function () {
        var contextPath = "${pageContext.request.contextPath}";

        var selCarrera = document.getElementById('txtCarrera');
        var inpCuatri = document.getElementById('txtCuatrimestre');
        var inpGrupo = document.getElementById('txtGrupo');
        var previo = document.getElementById('previoId');
        var textoPrevio = document.getElementById('textoPrevioId');
        var form = document.getElementById('formRegistroGrupo');
        var btn = document.getElementById('btnRegistrar');

        function avisoError(mensaje) {
            if (typeof mostrarAlertaError === 'function') mostrarAlertaError(mensaje);
            else if (typeof Swal !== 'undefined') Swal.fire({ icon: 'error', title: 'Revisa esto', text: mensaje });
            else alert(mensaje);
        }

        function avisoExito(mensaje) {
            if (typeof mostrarAlertaExito === 'function') mostrarAlertaExito(mensaje);
            else if (typeof Swal !== 'undefined') Swal.fire({ icon: 'success', title: 'Listo', text: mensaje });
        }

        // ---------- carreras desde la base ----------

        fetch(contextPath + '/CatalogosServlet', { headers: { 'Accept': 'application/json' } })
            .then(function (res) { return res.json(); })
            .then(function (datos) {
                selCarrera.innerHTML = '<option value="" disabled selected hidden>Selecciona la carrera</option>';

                datos.carreras.forEach(function (c) {
                    var op = document.createElement('option');
                    op.value = c.idCarrera;
                    op.textContent = c.idCarrera + ' - ' + c.nombreCarrera;
                    selCarrera.appendChild(op);
                });
            })
            .catch(function () {
                selCarrera.innerHTML = '<option value="" disabled selected>No se pudieron cargar las carreras</option>';
            });

        // ---------- vista previa del identificador ----------

        function actualizarPrevio() {
            var carrera = selCarrera.value;
            var cuatri = inpCuatri.value.trim();
            var letra = inpGrupo.value.trim().toUpperCase();

            if (carrera && cuatri && letra) {
                textoPrevio.textContent = carrera + cuatri + letra;
                previo.classList.remove('vacio');
            } else {
                textoPrevio.textContent = '— — —';
                previo.classList.add('vacio');
            }
        }

        selCarrera.addEventListener('change', actualizarPrevio);
        inpCuatri.addEventListener('input', actualizarPrevio);

        inpGrupo.addEventListener('input', function () {
            // Solo una letra: el identificador depende de que sea un carácter.
            inpGrupo.value = inpGrupo.value.replace(/[^A-Za-zÑñ]/g, '').toUpperCase().slice(0, 1);
            actualizarPrevio();
        });

        // ---------- envío ----------

        form.addEventListener('submit', function (e) {
            if (!selCarrera.value) {
                e.preventDefault();
                avisoError('Selecciona la carrera.');
                return;
            }

            var cuatri = parseInt(inpCuatri.value, 10);
            if (isNaN(cuatri) || cuatri < 1 || cuatri > 11) {
                e.preventDefault();
                avisoError('El cuatrimestre debe estar entre 1 y 11.');
                inpCuatri.focus();
                return;
            }

            if (!inpGrupo.value.trim()) {
                e.preventDefault();
                avisoError('Escribe la letra del grupo.');
                inpGrupo.focus();
                return;
            }

            btn.disabled = true;
            btn.textContent = 'Registrando...';
        });

        // ---------- resultado del servlet ----------

        document.addEventListener('DOMContentLoaded', function () {
            var exito = document.getElementById('flashExito').textContent.trim();
            var error = document.getElementById('flashError').textContent.trim();

            if (exito) avisoExito(exito);
            if (error) avisoError(error);

            // Se limpia la URL para que recargar no repita la alerta.
            if ((exito || error) && window.history.replaceState) {
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
    })();
</script>

<jsp:include page="/views/layout/footer.jsp" />
