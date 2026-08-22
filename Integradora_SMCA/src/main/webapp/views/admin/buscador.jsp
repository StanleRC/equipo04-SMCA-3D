<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscador de alumnos - UTEZ</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        * { box-sizing: border-box; }

        html, body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6fa;
        }

        /*
            El sidebar es position:fixed y mide 240px, así que no ocupa lugar en
            el flujo del documento. Sin el margen, el contenido arranca en x=0,
            queda debajo de él y la primera columna sale cortada.

            El wrapper NO es flex a propósito: siéndolo, .main-content recibía el
            100% del ancho y el margen lo empujaba 240px fuera de la pantalla.
            Como bloque normal, el ancho automático ya descuenta el margen.
        */
        .main-wrapper { min-height: 100vh; }

        .main-content {
            margin-left: 240px;
            min-width: 0;
        }

        .top-welcome-bar {
            height: 47px;
            background-color: #1c3862;
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: bold;
        }

        .buscador-body { padding: 22px 30px 40px; }

        /* Logo centrado de verdad: el enlace flota encima y no desplaza nada. */
        .fila-superior {
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 62px;
            margin-bottom: 16px;
        }

        .btn-back {
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            color: #4a5568;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
        }

        .btn-back:hover { color: #1c3862; text-decoration: underline; }

        .utez-logo { width: 150px; height: auto; display: block; }

        /* ---------- TARJETA ---------- */

        .panel {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 14px rgba(28, 56, 98, .09);
            overflow: hidden;
        }

        .panel-cabecera {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            padding: 22px 26px 18px;
            border-bottom: 1px solid #edf0f5;
        }

        .panel-titulo {
            margin: 0;
            font-size: 20px;
            font-weight: 700;
            color: #1c3862;
        }

        .panel-subtitulo {
            margin: 3px 0 0;
            font-size: 13px;
            color: #7a8598;
        }

        /* ---------- BUSCADOR ---------- */

        .search-form {
            position: relative;
            width: 330px;
            max-width: 100%;
        }

        .form-control-search {
            width: 100%;
            height: 44px;
            padding: 0 74px 0 44px;
            border: 1.5px solid #e2e6ee;
            border-radius: 26px;
            font-size: 14.5px;
            background: #fafbfd;
            outline: none;
            transition: border-color .2s, box-shadow .2s, background .2s;
        }

        .form-control-search:focus {
            border-color: #1c3862;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(28, 56, 98, .08);
        }

        .icono-lupa {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #9aa3ad;
            font-size: 15px;
            pointer-events: none;
        }

        .clear-btn {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 26px;
            height: 26px;
            border: none;
            background: #eef1f6;
            border-radius: 50%;
            color: #6b7688;
            font-size: 11px;
            cursor: pointer;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .clear-btn.visible { display: flex; }
        .clear-btn:hover { background: #dfe4ec; color: #1c3862; }

        /* Indicador de que la búsqueda está en curso */
        .spinner-busqueda {
            position: absolute;
            right: 46px;
            top: 50%;
            transform: translateY(-50%);
            width: 15px;
            height: 15px;
            border: 2px solid #dfe4ec;
            border-top-color: #1c3862;
            border-radius: 50%;
            display: none;
            animation: girar .6s linear infinite;
        }

        .spinner-busqueda.visible { display: block; }

        @keyframes girar { to { transform: translateY(-50%) rotate(360deg); } }

        /* ---------- TABLA ---------- */

        .tabla-scroll { width: 100%; overflow-x: auto; }

        .tabla-alumnos {
            width: 100%;
            border-collapse: collapse;
            min-width: 880px;
        }

        .tabla-alumnos thead th {
            padding: 14px 12px;
            background: #f7f9fc;
            color: #5a6675;
            border-bottom: 1.5px solid #e6eaf1;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: .04em;
            text-transform: uppercase;
            text-align: left;
            white-space: nowrap;
        }

        .tabla-alumnos tbody td {
            padding: 14px 12px;
            border-bottom: 1px solid #f0f2f6;
            font-size: 14px;
            color: #3f4a5a;
            vertical-align: middle;
        }

        .tabla-alumnos tbody tr { transition: background .15s; }
        .tabla-alumnos tbody tr:hover { background: #f7f9fc; }
        .tabla-alumnos tbody tr:last-child td { border-bottom: none; }

        /* Fila de alumno deshabilitado: se distingue sin desaparecer */
        .tabla-alumnos tbody tr.inactivo td { opacity: .55; }

        .celda-matricula { font-weight: 700; color: #1c3862; white-space: nowrap; }

        .celda-corta {
            max-width: 210px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .chip-grupo {
            display: inline-block;
            background: #eef3fb;
            color: #1c3862;
            border-radius: 999px;
            padding: 3px 11px;
            font-size: 12.5px;
            font-weight: 700;
        }

        .badge-estado {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 11.5px;
            font-weight: 700;
            white-space: nowrap;
        }

        .badge-activo   { background: #dcf3e6; color: #1e7e4a; }
        .badge-inactivo { background: #f1f1f1; color: #6b6b6b; }

        /* ---------- ACCIONES ---------- */

        .acciones { display: flex; gap: 7px; justify-content: center; }

        .btn-accion {
            width: 33px;
            height: 33px;
            border: none;
            border-radius: 9px;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: transform .15s, filter .15s;
        }

        .btn-accion:hover { transform: translateY(-1px); filter: brightness(.94); }

        .btn-historial    { background: #eef3fb; color: #1c3862; }
        .btn-deshabilitar { background: #fdf0d5; color: #8a6100; }
        .btn-reactivar    { background: #dcf3e6; color: #1e7e4a; }
        .btn-eliminar     { background: #fdecea; color: #c0392b; }

        .col-acciones { text-align: center !important; }

        .sin-resultados {
            padding: 46px 16px !important;
            text-align: center;
            color: #8a93a3;
            font-size: 14.5px;
            border-bottom: none !important;
        }

        .sin-resultados .bi {
            display: block;
            font-size: 34px;
            color: #cdd4e0;
            margin-bottom: 10px;
        }

        .aviso-linea {
            background: #fdf0d5;
            color: #8a6100;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 13.5px;
            margin-bottom: 14px;
        }

        /* Mensaje flotante de resultado de una acción */
        .toast-aviso {
            position: fixed;
            right: 24px;
            bottom: 24px;
            min-width: 250px;
            max-width: 340px;
            padding: 14px 18px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            color: #fff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, .22);
            opacity: 0;
            transform: translateY(14px);
            transition: opacity .25s, transform .25s;
            pointer-events: none;
            z-index: 3000;
        }

        .toast-aviso.visible { opacity: 1; transform: translateY(0); }
        .toast-aviso.ok { background: #1e7e4a; }
        .toast-aviso.error { background: #c0392b; }

        @media (max-width: 768px) {
            .main-content { margin-left: 220px; }
            .buscador-body { padding: 18px; }
            .panel-cabecera { flex-direction: column; align-items: stretch; }
            .search-form { width: 100%; }
            .btn-back { position: static; transform: none; }
            .fila-superior { flex-direction: column; gap: 10px; }
        }

        @media (prefers-reduced-motion: reduce) {
            * { transition: none !important; animation: none !important; }
        }
    </style>
</head>

<body>

<div class="main-wrapper">

    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como
            <c:choose>
                <c:when test="${esAdmin}">administrador</c:when>
                <c:otherwise>docente</c:otherwise>
            </c:choose>
        </div>

        <div class="buscador-body">

            <div class="fila-superior">
                <a href="javascript:history.back()" class="btn-back">
                    &larr; Pestaña anterior
                </a>

                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                     alt="Logo UTEZ" class="utez-logo">
            </div>

            <c:if test="${param.aviso eq 'noexiste'}">
                <div class="aviso-linea">Esa matrícula ya no existe en el sistema.</div>
            </c:if>

            <div class="panel">

                <div class="panel-cabecera">
                    <div>
                        <h2 class="panel-titulo">Alumnos</h2>
                        <p class="panel-subtitulo" id="contadorResultados">
                            ${listaAlumnos.size()} registrado<c:if test="${listaAlumnos.size() ne 1}">s</c:if>
                        </p>
                    </div>

                    <%--
                        Ya no es un <form> que recarga: el filtrado ocurre mientras
                        se escribe. El name="q" se conserva por si la página se abre
                        con ?q= en la URL.
                    --%>
                    <div class="search-form">
                        <i class="bi bi-search icono-lupa"></i>

                        <label for="inputBuscarAlumno" hidden>Buscar alumno</label>

                        <input type="text"
                               id="inputBuscarAlumno"
                               name="q"
                               value="<c:out value='${terminoBusqueda}' />"
                               placeholder="Nombre, matrícula, correo o grupo"
                               autocomplete="off"
                               class="form-control-search">

                        <span class="spinner-busqueda" id="spinnerBusqueda"></span>

                        <button type="button" class="clear-btn" id="btnLimpiar"
                                title="Limpiar" aria-label="Limpiar búsqueda">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                </div>

                <div class="tabla-scroll">
                    <table class="tabla-alumnos">
                        <thead>
                        <tr>
                            <th>Matrícula</th>
                            <th>Nombre</th>
                            <th>Grado</th>
                            <th>Grupo</th>
                            <th>Carrera</th>
                            <th>Correo</th>
                            <th>Estado</th>
                            <%-- La columna de acciones es exclusiva del administrador. --%>
                            <c:if test="${esAdmin}">
                                <th class="col-acciones">Acciones</th>
                            </c:if>
                        </tr>
                        </thead>

                        <tbody id="cuerpoTabla">

                        <c:choose>
                            <c:when test="${not empty listaAlumnos}">
                                <c:forEach var="alumno" items="${listaAlumnos}">
                                    <tr class="${alumno.activo eq 'N' ? 'inactivo' : ''}"
                                        data-matricula="${alumno.matricula}">

                                        <td class="celda-matricula">${alumno.matricula}</td>

                                        <td class="celda-corta" title="${alumno.nombreCompleto}">
                                                ${alumno.nombreCompleto}
                                        </td>

                                        <td>${alumno.grado}</td>

                                        <td><span class="chip-grupo">${alumno.grupo}</span></td>

                                        <td class="celda-corta" title="${alumno.carrera}">
                                                ${alumno.carrera}
                                        </td>

                                        <td class="celda-corta" title="${alumno.correo}">
                                                ${alumno.correo}
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${alumno.activo eq 'N'}">
                                                    <span class="badge-estado badge-inactivo">Deshabilitado</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-estado badge-activo">Activo</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <c:if test="${esAdmin}">
                                            <td class="col-acciones">
                                                <div class="acciones">
                                                    <a class="btn-accion btn-historial"
                                                       href="${pageContext.request.contextPath}/DetalleAlumnoServlet?matricula=${alumno.matricula}"
                                                       title="Ver historial">
                                                        <i class="bi bi-clock-history"></i>
                                                    </a>

                                                    <c:choose>
                                                        <c:when test="${alumno.activo eq 'N'}">
                                                            <button type="button" class="btn-accion btn-reactivar"
                                                                    data-accion="reactivar" title="Reactivar">
                                                                <i class="bi bi-arrow-counterclockwise"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn-accion btn-deshabilitar"
                                                                    data-accion="deshabilitar" title="Deshabilitar">
                                                                <i class="bi bi-slash-circle"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <button type="button" class="btn-accion btn-eliminar"
                                                            data-accion="eliminar" title="Eliminar">
                                                        <i class="bi bi-trash3"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="${esAdmin ? 8 : 7}" class="sin-resultados">
                                        <i class="bi bi-inbox"></i>
                                        Todavía no hay alumnos registrados.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>

                        </tbody>
                    </table>
                </div>

            </div>

        </div>

    </main>

</div>

<div class="toast-aviso" id="toastAviso"></div>

<script>
    (function () {
        var contextPath = "${pageContext.request.contextPath}";
        var esAdmin = ${esAdmin ? 'true' : 'false'};
        var totalColumnas = esAdmin ? 8 : 7;

        var campo = document.getElementById('inputBuscarAlumno');
        var cuerpo = document.getElementById('cuerpoTabla');
        var contador = document.getElementById('contadorResultados');
        var spinner = document.getElementById('spinnerBusqueda');
        var btnLimpiar = document.getElementById('btnLimpiar');
        var toast = document.getElementById('toastAviso');

        var temporizador = null;
        var peticionActual = 0;

        // ---------- utilidades ----------

        function escaparHtml(texto) {
            var div = document.createElement('div');
            div.textContent = texto == null ? '' : texto;
            return div.innerHTML;
        }

        function mostrarToast(mensaje, tipo) {
            toast.textContent = mensaje;
            toast.className = 'toast-aviso visible ' + (tipo === 'ok' ? 'ok' : 'error');
            setTimeout(function () { toast.classList.remove('visible'); }, 3200);
        }

        function filaVacia(mensaje) {
            return '<tr><td colspan="' + totalColumnas + '" class="sin-resultados">'
                + '<i class="bi bi-inbox"></i>' + escaparHtml(mensaje) + '</td></tr>';
        }

        // ---------- pintado de la tabla ----------

        function botonesAccion(a) {
            if (!esAdmin) return '';

            var inactivo = a.activo === 'N';

            var alternar = inactivo
                ? '<button type="button" class="btn-accion btn-reactivar" data-accion="reactivar" title="Reactivar"><i class="bi bi-arrow-counterclockwise"></i></button>'
                : '<button type="button" class="btn-accion btn-deshabilitar" data-accion="deshabilitar" title="Deshabilitar"><i class="bi bi-slash-circle"></i></button>';

            return '<td class="col-acciones"><div class="acciones">'
                + '<a class="btn-accion btn-historial" href="' + contextPath
                + '/DetalleAlumnoServlet?matricula=' + encodeURIComponent(a.matricula)
                + '" title="Ver historial"><i class="bi bi-clock-history"></i></a>'
                + alternar
                + '<button type="button" class="btn-accion btn-eliminar" data-accion="eliminar" title="Eliminar"><i class="bi bi-trash3"></i></button>'
                + '</div></td>';
        }

        function pintar(lista, termino) {
            if (!lista.length) {
                cuerpo.innerHTML = filaVacia(termino
                    ? 'No se encontró ningún alumno que coincida con "' + termino + '".'
                    : 'Todavía no hay alumnos registrados.');

                contador.textContent = '0 resultados';
                return;
            }

            var html = '';

            lista.forEach(function (a) {
                var inactivo = a.activo === 'N';

                html += '<tr class="' + (inactivo ? 'inactivo' : '') + '" data-matricula="'
                    + escaparHtml(a.matricula) + '">'
                    + '<td class="celda-matricula">' + escaparHtml(a.matricula) + '</td>'
                    + '<td class="celda-corta" title="' + escaparHtml(a.nombreCompleto) + '">'
                    + escaparHtml(a.nombreCompleto) + '</td>'
                    + '<td>' + escaparHtml(a.grado) + '</td>'
                    + '<td><span class="chip-grupo">' + escaparHtml(a.grupo) + '</span></td>'
                    + '<td class="celda-corta" title="' + escaparHtml(a.carrera) + '">'
                    + escaparHtml(a.carrera) + '</td>'
                    + '<td class="celda-corta" title="' + escaparHtml(a.correo) + '">'
                    + escaparHtml(a.correo) + '</td>'
                    + '<td><span class="badge-estado ' + (inactivo ? 'badge-inactivo' : 'badge-activo')
                    + '">' + (inactivo ? 'Deshabilitado' : 'Activo') + '</span></td>'
                    + botonesAccion(a)
                    + '</tr>';
            });

            cuerpo.innerHTML = html;

            contador.textContent = lista.length + (lista.length === 1 ? ' resultado' : ' resultados');
        }

        // ---------- búsqueda en vivo ----------

        function buscar(termino) {
            /*
             * Cada petición lleva número. Si el usuario escribe rápido, puede
             * llegar antes la respuesta de una búsqueda vieja que la de la nueva;
             * comparando el número se descartan las que ya no corresponden.
             */
            var miNumero = ++peticionActual;

            spinner.classList.add('visible');

            fetch(contextPath + '/BuscarAlumnosServlet?formato=json&q=' + encodeURIComponent(termino), {
                headers: { 'Accept': 'application/json' }
            })
                .then(function (res) {
                    if (res.status === 401) throw new Error('sesion');
                    return res.json();
                })
                .then(function (lista) {
                    if (miNumero !== peticionActual) return; // llegó tarde, se ignora
                    spinner.classList.remove('visible');
                    pintar(lista, termino);
                })
                .catch(function (e) {
                    if (miNumero !== peticionActual) return;
                    spinner.classList.remove('visible');

                    if (e.message === 'sesion') {
                        window.location.href = contextPath + '/index.jsp';
                        return;
                    }
                    mostrarToast('No se pudo conectar con el servidor.', 'error');
                });
        }

        campo.addEventListener('input', function () {
            btnLimpiar.classList.toggle('visible', campo.value.length > 0);

            // Espera de 300 ms: sin esto se lanzaría una consulta por cada tecla.
            clearTimeout(temporizador);
            temporizador = setTimeout(function () {
                buscar(campo.value.trim());
            }, 300);
        });

        btnLimpiar.addEventListener('click', function () {
            campo.value = '';
            btnLimpiar.classList.remove('visible');
            campo.focus();
            buscar('');
        });

        // Enter no debe recargar: la búsqueda ya ocurrió al escribir.
        campo.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                clearTimeout(temporizador);
                buscar(campo.value.trim());
            }
        });

        // ---------- acciones sobre un alumno ----------

        function ejecutarAccion(matricula, accion) {
            var params = new URLSearchParams();
            params.append('matricula', matricula);
            params.append('accion', accion);

            fetch(contextPath + '/AlumnoAccionesServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                    'Accept': 'application/json'
                },
                body: params.toString()
            })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    mostrarToast(data.message, data.status);
                    if (data.status === 'ok') {
                        buscar(campo.value.trim()); // refresca la tabla
                    }
                })
                .catch(function () {
                    mostrarToast('No se pudo completar la acción.', 'error');
                });
        }

        // Delegación: los botones se vuelven a crear en cada búsqueda,
        // así que se escucha en el tbody y no en cada botón.
        cuerpo.addEventListener('click', function (e) {
            var boton = e.target.closest('button[data-accion]');
            if (!boton) return;

            var fila = boton.closest('tr');
            var matricula = fila.getAttribute('data-matricula');
            var accion = boton.dataset.accion;

            if (accion === 'eliminar') {
                /*
                 * Las llaves foráneas son ON DELETE CASCADE: esto borra también
                 * la bitácora y los reportes del alumno. Se pide escribir la
                 * matrícula para que no ocurra por un clic accidental.
                 */
                var confirmacion = prompt(
                    'Eliminar borra también TODO el historial y los reportes de este alumno.\n\n' +
                    'Escribe la matrícula ' + matricula + ' para confirmar:');

                if (confirmacion === null) return;

                if (confirmacion.trim().toUpperCase() !== matricula.toUpperCase()) {
                    mostrarToast('La matrícula no coincide. No se eliminó nada.', 'error');
                    return;
                }
            }

            if (accion === 'deshabilitar'
                && !confirm('¿Deshabilitar a ' + matricula + '? No podrá iniciar sesión, pero su historial se conserva.')) {
                return;
            }

            ejecutarAccion(matricula, accion);
        });

        // ---------- arranque ----------

        campo.focus();
        campo.setSelectionRange(campo.value.length, campo.value.length);
        btnLimpiar.classList.toggle('visible', campo.value.length > 0);
    })();
</script>

</body>
</html>
