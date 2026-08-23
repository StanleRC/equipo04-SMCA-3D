<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!-- MARCA_TABLA_BITACORA_V2 -->

<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Bitácora de Accesos - UTEZ" />
</jsp:include>

<!-- CSS Personalizado Base -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<style>
    /* Estilos idénticos a Incidencias */
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

    .tabla-datos tbody tr:hover {
        background-color: #f4f6fa;
    }

    /* Semáforo de estados */
    .badge-estado {
        display: inline-block;
        padding: 4px 12px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        white-space: nowrap;
    }

    .badge-validado   { background: #dcf3e6; color: #1e7e4a; }
    .badge-pendiente  { background: #fdf0d5; color: #8a6100; }
    .badge-descartado { background: #f1f1f1; color: #6b6b6b; }
    .badge-sinreporte { background: #eef1f6; color: #5a6b85; }

    .texto-encurso {
        color: #8a6100;
        font-weight: 700;
    }

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

    .contador-filas {
        font-size: 13px;
        color: #666;
    }

    .sin-datos {
        padding: 34px 12px !important;
        color: #777;
        text-align: center;
    }

    /* Botones de ordenamiento estilizados */
    .filter-actions-row {
        display: flex;
        gap: 10px;
        margin-bottom: 12px;
    }

    .btn-filter {
        background-color: #1c3862;
        color: #ffffff;
        border: none;
        padding: 6px 14px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: background-color 0.2s ease;
    }

    .btn-filter:hover {
        background-color: #142847;
    }
</style>

<div class="main-wrapper">

    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="salones-body">

            <!-- Enlace regresar -->
            <div class="mb-2">
                <a href="${pageContext.request.contextPath}/SeleccionarBitacoraServlet" class="btn-back">
                    &larr; <u>Elegir otro laboratorio</u>
                </a>
            </div>

            <!-- Logo centrado -->
            <div class="text-center mb-3">
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                     alt="Logo UTEZ" style="max-height: 130px;">
            </div>

            <!-- Encabezado con título del aula y contador -->
            <div class="encabezado-tabla">
                <h2 class="titulo-lab">
                    <c:choose>
                        <c:when test="${empty labActual or labActual eq 'Todos'}">
                            Bitácora de todos los laboratorios
                        </c:when>
                        <c:otherwise>
                            Bitácora del aula <c:out value="${labActual}" />
                        </c:otherwise>
                    </c:choose>
                </h2>
                <span class="contador-filas">
                    ${listaBitacora.size()} registro<c:if test="${listaBitacora.size() ne 1}">s</c:if>
                </span>
            </div>

            <!-- Filtros de ordenación -->
            <div class="filter-actions-row">
                <button type="button" class="btn-filter" data-orden="fecha">
                    Fecha <i class="bi bi-funnel"></i>
                </button>
                <button type="button" class="btn-filter" data-orden="hora">
                    Hora <i class="bi bi-funnel"></i>
                </button>
            </div>

            <!-- Tabla de datos -->
            <div class="tabla-wrapper">
                <table class="tabla-datos" id="tablaBitacora">
                    <thead>
                    <tr>
                        <th style="width: 8%;">Salón</th>
                        <th style="width: 6%;">PC</th>
                        <th style="width: 12%;">Matrícula</th>
                        <th style="width: 22%;">Nombre</th>
                        <th style="width: 11%;">Fecha</th>
                        <th style="width: 12%;">Hora inicial</th>
                        <th style="width: 12%;">Hora final</th>
                        <th style="width: 17%;">Estado</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listaBitacora}">
                            <c:forEach var="fila" items="${listaBitacora}">
                                <tr>
                                    <td><strong>${fila.salon}</strong></td>
                                    <td>${fila.numeroPc}</td>
                                    <td>${fila.matricula}</td>
                                    <td class="al-inicio">${fila.nombreCompleto}</td>
                                    <td>${fila.fecha}</td>
                                    <td>${fila.horaInicio}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty fila.horaFinal}">
                                                ${fila.horaFinal}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="texto-encurso">En curso</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${fila.estado eq 'Validado'}">
                                                <span class="badge-estado badge-validado">Validado</span>
                                            </c:when>
                                            <c:when test="${fila.estado eq 'Pendiente'}">
                                                <span class="badge-estado badge-pendiente">Pendiente</span>
                                            </c:when>
                                            <c:when test="${fila.estado eq 'Descartado'}">
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
                                <td colspan="8" class="sin-datos">
                                    No hay registros de acceso
                                    <c:if test="${not empty labActual and labActual ne 'Todos'}">
                                        en el aula <c:out value="${labActual}" />
                                    </c:if>.
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

<script>
    // Ordenamiento dinámico de la tabla
    (function () {
        var tabla = document.getElementById('tablaBitacora');
        if (!tabla) return;

        var ascendente = {};

        document.querySelectorAll('.btn-filter').forEach(function (boton) {
            boton.addEventListener('click', function () {
                var clave = boton.dataset.orden;
                var columna = (clave === 'fecha') ? 4 : 5;

                var cuerpo = tabla.tBodies[0];
                var filas = Array.prototype.slice.call(cuerpo.rows);

                if (filas.length < 2) return;

                ascendente[clave] = !ascendente[clave];
                var factor = ascendente[clave] ? 1 : -1;

                filas.sort(function (a, b) {
                    var x = a.cells[columna].textContent.trim();
                    var y = b.cells[columna].textContent.trim();

                    if (clave === 'fecha') {
                        x = x.split('/').reverse().join('');
                        y = y.split('/').reverse().join('');
                    }

                    return x.localeCompare(y) * factor;
                });

                filas.forEach(function (fila) { cuerpo.appendChild(fila); });
            });
        });
    })();
</script>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />