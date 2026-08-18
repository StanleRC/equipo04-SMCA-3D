<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Validar incidencias - UTEZ" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    .tabla-wrapper {
        width: 100%;
        overflow-x: auto;
        border: 1px solid #1c3862;
    }

    .tabla-datos {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
        min-width: 950px;
    }

    .tabla-datos th {
        height: 52px;
        padding: 8px;
        background-color: #1c3862;
        color: #fff;
        border: 1px solid #31517d;
        font-size: 14px;
        font-weight: 700;
        text-align: center;
    }

    .tabla-datos td {
        height: 44px;
        padding: 8px;
        border: 1px solid #c8c8c8;
        font-size: 14px;
        text-align: center;
        vertical-align: middle;
    }

    .tabla-datos td.al-inicio {
        text-align: left;
        padding-left: 12px;
    }

    .tabla-datos tbody tr:hover { background-color: #f4f6fa; }

    .acciones-fila {
        display: flex;
        gap: 6px;
        justify-content: center;
    }

    .btn-validar,
    .btn-descartar {
        border: none;
        border-radius: 6px;
        padding: 6px 14px;
        font-size: 12px;
        font-weight: 700;
        color: #fff;
        cursor: pointer;
    }

    .btn-validar   { background-color: #0d8a72; }
    .btn-validar:hover { background-color: #0a7560; }

    .btn-descartar { background-color: #9aa3ad; }
    .btn-descartar:hover { background-color: #7d858f; }

    .badge-estado {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        white-space: nowrap;
    }

    .badge-validado   { background: #dcf3e6; color: #1e7e4a; }
    .badge-descartado { background: #f1f1f1; color: #6b6b6b; }

    .encabezado-tabla {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 12px;
    }

    .titulo-lab {
        font-size: 20px;
        font-weight: 700;
        color: #1c3862;
        margin: 0;
    }

    .contador-filas { font-size: 13px; color: #666; }

    .sin-datos { padding: 34px 12px !important; color: #777; }
</style>

<div class="main-wrapper">

    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="salones-body">

            <div class="mb-2">
                <a href="javascript:history.back()" class="btn-back">
                    &larr; <u>Pestaña anterior</u>
                </a>
            </div>

            <div class="text-center mb-3">
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                     alt="Logo UTEZ" style="max-height: 130px;">
            </div>

            <div class="encabezado-tabla">
                <h2 class="titulo-lab">
                    Ingresaste a <c:out value="${labActual}" />
                </h2>
                <span class="contador-filas">
                    ${listaIncidencias.size()} incidencia<c:if test="${listaIncidencias.size() ne 1}">s</c:if>
                </span>
            </div>

            <div class="tabla-wrapper">
                <table class="tabla-datos">
                    <thead>
                    <tr>
                        <th style="width: 8%;">Grado</th>
                        <th style="width: 8%;">Grupo</th>
                        <th style="width: 6%;">PC</th>
                        <th style="width: 14%;">Matrícula</th>
                        <th style="width: 20%;">Nombre</th>
                        <th style="width: 11%;">Fecha</th>
                        <th style="width: 18%;">Incidencia</th>
                        <th style="width: 15%;">Validar</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listaIncidencias}">
                            <c:forEach var="inc" items="${listaIncidencias}">
                                <tr>
                                    <td><strong>${inc.grado}</strong></td>
                                    <td><strong>${inc.grupo}</strong></td>
                                    <td>${inc.numeroPc}</td>
                                    <td>${inc.matricula}</td>
                                    <td class="al-inicio">${inc.nombreCompleto}</td>
                                    <td>${inc.fecha}</td>
                                    <td class="al-inicio">${inc.incidencia}</td>

                                    <td>
                                        <c:choose>
                                            <%--
                                                Un reporte ya revisado no se vuelve a tocar:
                                                el DAO solo actualiza filas en 'Pendiente'.
                                            --%>
                                            <c:when test="${inc.estado eq 'Validado'}">
                                                <span class="badge-estado badge-validado">Validado</span>
                                            </c:when>

                                            <c:when test="${inc.estado eq 'Descartado'}">
                                                <span class="badge-estado badge-descartado">Descartado</span>
                                            </c:when>

                                            <c:otherwise>
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/ValidarIncidenciasServlet"
                                                      class="form-revision">

                                                    <input type="hidden" name="idReporte" value="${inc.idReporte}">
                                                    <input type="hidden" name="lab" value="${labActual}">
                                                    <input type="hidden" name="accion" value="">

                                                    <div class="acciones-fila">
                                                        <button type="button" class="btn-validar"
                                                                data-accion="validar">Validar</button>
                                                        <button type="button" class="btn-descartar"
                                                                data-accion="descartar">Descartar</button>
                                                    </div>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="sin-datos">
                                    No hay incidencias reportadas en
                                    <c:out value="${labActual}" />.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

        </div>

    </main>
</div>

<%-- Resultado que devuelve ValidarIncidenciasServlet en ?msj= --%>
<span id="flashMsj" hidden><c:out value="${param.msj}" /></span>

<script>
    (function () {
        // Cada botón escribe su acción en el campo oculto antes de enviar.
        document.querySelectorAll('.form-revision button[data-accion]').forEach(function (boton) {
            boton.addEventListener('click', function () {
                var form = boton.closest('form');
                var esValidar = boton.dataset.accion === 'validar';

                var confirmar = function () {
                    form.querySelector('input[name="accion"]').value = boton.dataset.accion;
                    form.querySelectorAll('button').forEach(function (b) { b.disabled = true; });
                    form.submit();
                };

                if (typeof Swal === 'undefined') {
                    confirmar();
                    return;
                }

                Swal.fire({
                    icon: 'question',
                    title: esValidar ? '¿Validar la incidencia?' : '¿Descartar la incidencia?',
                    text: 'Esta decisión no se puede revertir desde la pantalla.',
                    showCancelButton: true,
                    confirmButtonText: esValidar ? 'Sí, validar' : 'Sí, descartar',
                    cancelButtonText: 'Cancelar',
                    confirmButtonColor: esValidar ? '#0d8a72' : '#9aa3ad'
                }).then(function (res) {
                    if (res.isConfirmed) confirmar();
                });
            });
        });

        var msj = document.getElementById('flashMsj').textContent.trim();

        if (msj && typeof Swal !== 'undefined') {
            if (msj === 'ok') {
                Swal.fire({
                    icon: 'success', title: 'Incidencia revisada',
                    timer: 1800, showConfirmButton: false
                });
            } else if (msj === 'error') {
                Swal.fire({
                    icon: 'error', title: 'No se pudo procesar',
                    text: 'Puede que otra persona ya la haya revisado.'
                });
            }
        }

        // Se limpia la URL para que recargar no repita la alerta.
        if (msj && window.history.replaceState) {
            window.history.replaceState({}, document.title,
                window.location.pathname + window.location.search.replace(/[?&]msj=[^&]*/, '').replace(/^&/, '?'));
        }
    })();
</script>

<jsp:include page="/views/layout/footer.jsp" />
