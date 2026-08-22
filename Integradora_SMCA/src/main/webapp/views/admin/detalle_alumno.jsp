<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de ${alumnoDetalle.nombre} - UTEZ</title>

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
            el flujo. Sin este margen el contenido arranca en x=0 y queda debajo
            de él: por eso el nombre salía cortado como "uel Guerrero Guevara".

            El wrapper NO es flex a propósito: siéndolo, .main-content recibía el
            100% del ancho y el margen lo empujaba fuera de la pantalla.
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

        .cuerpo { padding: 22px 30px 40px; }

        .btn-back {
            display: inline-block;
            color: #4a5568;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            margin-bottom: 16px;
        }

        .btn-back:hover { color: #1c3862; text-decoration: underline; }

        /* ---------- FICHA ---------- */

        .ficha {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 14px rgba(28, 56, 98, .09);
            padding: 20px 24px;
            margin-bottom: 20px;
        }

        .ficha-avatar {
            width: 78px;
            height: 78px;
            border-radius: 50%;
            overflow: hidden;
            background: #dfe3ea;
            flex-shrink: 0;
        }

        .ficha-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .ficha-datos { flex: 1; min-width: 220px; }

        .ficha-nombre {
            font-size: 19px;
            font-weight: 700;
            color: #1c3862;
            margin: 0 0 4px;
        }

        .ficha-linea { font-size: 13px; color: #7a8598; margin: 0; }

        .ficha-chips {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .chip {
            background: #eef3fb;
            color: #1c3862;
            border-radius: 999px;
            padding: 4px 12px;
            font-size: 12px;
            font-weight: 700;
        }

        /* Acciones del administrador sobre este alumno */
        .ficha-acciones {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }

        .btn-estado {
            border: none;
            border-radius: 10px;
            padding: 10px 18px;
            font-size: 13.5px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 7px;
            transition: filter .15s;
        }

        .btn-estado:hover { filter: brightness(.94); }
        .btn-estado:disabled { opacity: .6; cursor: progress; }

        .btn-deshabilitar { background: #fdf0d5; color: #8a6100; }
        .btn-reactivar    { background: #dcf3e6; color: #1e7e4a; }
        .btn-eliminar     { background: #fdecea; color: #c0392b; }

        /* ---------- TABLA ---------- */

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
            gap: 12px;
            padding: 20px 26px 16px;
            border-bottom: 1px solid #edf0f5;
        }

        .panel-titulo {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
            color: #1c3862;
        }

        .contador { font-size: 13px; color: #7a8598; }

        .tabla-scroll { width: 100%; overflow-x: auto; }

        .tabla-datos {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }

        .tabla-datos thead th {
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

        .tabla-datos tbody td {
            padding: 14px 12px;
            border-bottom: 1px solid #f0f2f6;
            font-size: 14px;
            color: #3f4a5a;
            vertical-align: middle;
        }

        .tabla-datos tbody tr:hover { background: #f7f9fc; }
        .tabla-datos tbody tr:last-child td { border-bottom: none; }

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

        .badge-validado   { background: #dcf3e6; color: #1e7e4a; }
        .badge-pendiente  { background: #fdf0d5; color: #8a6100; }
        .badge-descartado { background: #f1f1f1; color: #6b6b6b; }
        .badge-sinreporte { background: #eef1f6; color: #5a6b85; }
        .badge-activo     { background: #dcf3e6; color: #1e7e4a; }
        .badge-inactivo   { background: #f1f1f1; color: #6b6b6b; }

        .texto-encurso { color: #8a6100; font-weight: 700; }

        .celda-incidencia {
            max-width: 240px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .celda-incidencia.vacia { color: #9aa3ad; font-style: italic; }

        .sin-datos {
            padding: 46px 16px !important;
            text-align: center;
            color: #8a93a3;
            font-size: 14.5px;
            border-bottom: none !important;
        }

        .sin-datos .bi {
            display: block;
            font-size: 34px;
            color: #cdd4e0;
            margin-bottom: 10px;
        }

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
            .cuerpo { padding: 18px; }
        }

        @media (prefers-reduced-motion: reduce) {
            * { transition: none !important; }
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

        <div class="cuerpo">

            <a href="${pageContext.request.contextPath}/BuscarAlumnosServlet" class="btn-back">
                &larr; Volver al buscador
            </a>

            <div class="ficha">
                <div class="ficha-avatar">
                    <img src="${pageContext.request.contextPath}/assets/img/perfiles/${not empty alumnoDetalle.fotoPerfil ? alumnoDetalle.fotoPerfil : 'default.png'}"
                         alt="Foto de perfil"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/perfiles/default.png';">
                </div>

                <div class="ficha-datos">
                    <h2 class="ficha-nombre">
                        ${alumnoDetalle.nombre} ${alumnoDetalle.apellidoPaterno} ${alumnoDetalle.apellidoMaterno}
                    </h2>

                    <p class="ficha-linea">${alumnoDetalle.correo}</p>

                    <div class="ficha-chips">
                        <span class="chip">Matrícula: ${alumnoDetalle.matricula}</span>
                        <span class="chip">Grupo: ${alumnoDetalle.grupoIdGrupo}</span>

                        <span class="badge-estado ${alumnoActivo ? 'badge-activo' : 'badge-inactivo'}"
                              id="badgeEstadoAlumno">
                            <c:choose>
                                <c:when test="${alumnoActivo}">Activo</c:when>
                                <c:otherwise>Deshabilitado</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <%--
                    Solo el administrador puede cambiar el estado del alumno.
                    Quien lo impide de verdad es AlumnoAccionesServlet, que
                    responde 403 si quien llama no es admin.
                --%>
                <c:if test="${esAdmin}">
                    <div class="ficha-acciones">
                        <c:choose>
                            <c:when test="${alumnoActivo}">
                                <button type="button" class="btn-estado btn-deshabilitar"
                                        id="btnCambiarEstado" data-accion="deshabilitar">
                                    <i class="bi bi-slash-circle"></i> Deshabilitar
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn-estado btn-reactivar"
                                        id="btnCambiarEstado" data-accion="reactivar">
                                    <i class="bi bi-arrow-counterclockwise"></i> Reactivar
                                </button>
                            </c:otherwise>
                        </c:choose>

                        <button type="button" class="btn-estado btn-eliminar" id="btnEliminar">
                            <i class="bi bi-trash3"></i> Eliminar
                        </button>
                    </div>
                </c:if>
            </div>

            <div class="panel">

                <div class="panel-cabecera">
                    <h3 class="panel-titulo">Historial de uso e incidencias</h3>
                    <span class="contador">
                        ${listaHistorial.size()} registro<c:if test="${listaHistorial.size() ne 1}">s</c:if>
                    </span>
                </div>

                <div class="tabla-scroll">
                    <table class="tabla-datos">
                        <thead>
                        <tr>
                            <th>Grado</th>
                            <th>Grupo</th>
                            <th>Salón</th>
                            <th>PC</th>
                            <th>Fecha</th>
                            <th>Hora inicial</th>
                            <th>Hora final</th>
                            <th>Incidencia</th>
                            <th>Estado</th>
                        </tr>
                        </thead>

                        <tbody>
                        <c:choose>
                            <c:when test="${not empty listaHistorial}">
                                <c:forEach var="item" items="${listaHistorial}">
                                    <tr>
                                        <td>${item.grado}</td>
                                        <td><span class="chip-grupo">${item.grupo}</span></td>
                                        <td><strong>${item.salon}</strong></td>
                                        <td>${item.numeroPc}</td>
                                        <td>${item.fecha}</td>
                                        <td>${item.horaInicial}</td>

                                            <%-- hora_final admite NULL: la sesión sigue abierta. --%>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.horaFinal}">
                                                    ${item.horaFinal}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="texto-encurso">En curso</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="celda-incidencia ${item.incidencia eq 'Ninguna' ? 'vacia' : ''}"
                                            title="${item.incidencia}">
                                                ${item.incidencia}
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${item.estado eq 'Validado'}">
                                                    <span class="badge-estado badge-validado">Validado</span>
                                                </c:when>
                                                <c:when test="${item.estado eq 'Pendiente'}">
                                                    <span class="badge-estado badge-pendiente">Pendiente</span>
                                                </c:when>
                                                <c:when test="${item.estado eq 'Descartado'}">
                                                    <span class="badge-estado badge-descartado">Descartado</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-estado badge-sinreporte">Sin reporte</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>

                            <c:otherwise>
                                <tr>
                                    <td colspan="9" class="sin-datos">
                                        <i class="bi bi-inbox"></i>
                                        Este alumno todavía no tiene registros en la bitácora.
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
        var matricula = "${alumnoDetalle.matricula}";

        var toast = document.getElementById('toastAviso');
        var btnEstado = document.getElementById('btnCambiarEstado');
        var btnEliminar = document.getElementById('btnEliminar');

        // El docente no tiene estos botones: la vista ni siquiera los dibuja.
        if (!btnEstado && !btnEliminar) return;

        function mostrarToast(mensaje, tipo) {
            toast.textContent = mensaje;
            toast.className = 'toast-aviso visible ' + (tipo === 'ok' ? 'ok' : 'error');
            setTimeout(function () { toast.classList.remove('visible'); }, 3200);
        }

        function ejecutar(accion, alTerminar) {
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
                    if (data.status === 'ok' && alTerminar) alTerminar();
                })
                .catch(function () {
                    mostrarToast('No se pudo completar la acción.', 'error');
                });
        }

        if (btnEstado) {
            btnEstado.addEventListener('click', function () {
                var accion = btnEstado.dataset.accion;

                if (accion === 'deshabilitar'
                    && !confirm('¿Deshabilitar a ' + matricula + '? No podrá iniciar sesión, pero su historial se conserva.')) {
                    return;
                }

                btnEstado.disabled = true;

                ejecutar(accion, function () {
                    // Se recarga para que el badge y el botón queden coherentes.
                    window.location.reload();
                });

                setTimeout(function () { btnEstado.disabled = false; }, 2500);
            });
        }

        if (btnEliminar) {
            btnEliminar.addEventListener('click', function () {
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

                btnEliminar.disabled = true;

                ejecutar('eliminar', function () {
                    // Ya no hay a quién mostrar: se vuelve al buscador.
                    setTimeout(function () {
                        window.location.href = contextPath + '/BuscarAlumnosServlet';
                    }, 1200);
                });
            });
        }
    })();
</script>

</body>
</html>
