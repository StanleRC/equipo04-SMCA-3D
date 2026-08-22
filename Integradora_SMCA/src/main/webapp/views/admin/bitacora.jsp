<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Bitácora de Accesos - UTEZ" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/incidencias_utez.css?v=1">

<style>
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

    .texto-encurso { color: #8a6100; font-weight: bold; }

    .celda-incidencia {
        text-align: left;
        max-width: 260px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }

    .celda-incidencia.vacia { color: #9aa3ad; font-style: italic; }

    .resumen-estados {
        display: flex;
        gap: 14px;
        flex-wrap: wrap;
        font-size: 12.5px;
        color: #5a6b85;
        margin-top: 8px;
    }

    .resumen-estados span { display: inline-flex; align-items: center; gap: 5px; }

    .punto {
        width: 9px;
        height: 9px;
        border-radius: 50%;
        display: inline-block;
    }

    .punto-validado   { background: #1e7e4a; }
    .punto-pendiente  { background: #d9a326; }
    .punto-sinreporte { background: #9aa3ad; }
</style>

<div class="main-wrapper">
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="panel-body">

            <%-- El enlace "Pestaña anterior" estaba repetido dos veces. --%>
            <div class="panel-header-row">
                <div>
                    <%-- Al servlet, no al .jsp: abrir el jsp directo lo deja sin datos. --%>
                    <a href="${pageContext.request.contextPath}/SeleccionarBitacoraServlet"
                       class="btn-back">
                        &larr; Elegir otro laboratorio
                    </a>
                </div>

                <div class="panel-logo">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                         alt="Logo UTEZ" class="utez-logo">
                </div>

                <div class="panel-user"></div>
            </div>

            <div class="panel-card">

                <div class="table-header-info">
                    <h2 class="panel-title">
                        <c:choose>
                            <c:when test="${empty labActual or labActual eq 'Todos'}">
                                Todos los laboratorios
                            </c:when>
                            <c:otherwise>
                                Bitácora del aula: <c:out value="${labActual}" />
                            </c:otherwise>
                        </c:choose>
                    </h2>

                    <p class="panel-subtitle">
                        ${listaBitacora.size()} registro<c:if test="${listaBitacora.size() ne 1}">s</c:if>
                        de acceso
                        <c:if test="${not empty labActual and labActual ne 'Todos'}">
                            en <c:out value="${labActual}" />
                        </c:if>
                    </p>

                    <div class="resumen-estados">
                        <span><i class="punto punto-validado"></i> Validado: el docente ya revisó el reporte</span>
                        <span><i class="punto punto-pendiente"></i> Pendiente: falta que lo revise</span>
                        <span><i class="punto punto-sinreporte"></i> Sin reporte: el alumno no reportó falla</span>
                    </div>
                </div>

                <div class="table-wrap">
                    <table class="custom-incidencias-table">
                        <thead>
                        <tr>
                            <th>No.</th>
                            <th>Alumno</th>
                            <th>Matrícula</th>
                            <th>Aula</th>
                            <th>PC</th>
                            <th>Fecha</th>
                            <th>Hora inicial</th>
                            <th>Hora final</th>
                            <th>Incidencia</th>
                            <th>Estado</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:if test="${empty listaBitacora}">
                            <tr class="empty-row">
                                <td colspan="10" style="text-align:center; padding:24px; color:#666;">
                                    No hay registros de acceso
                                    <c:if test="${not empty labActual and labActual ne 'Todos'}">
                                        en el aula <c:out value="${labActual}" />
                                    </c:if>.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="fila" items="${listaBitacora}">
                            <tr>
                                <td>${fila.idBitacora}</td>
                                <td>${fila.nombreCompleto}</td>
                                <td>${fila.matricula}</td>
                                <td><strong>${fila.salon}</strong></td>
                                <td>${fila.numeroPc}</td>
                                <td>${fila.fecha}</td>
                                <td>${fila.horaInicio}</td>

                                    <%-- hora_final admite NULL: la sesión sigue abierta. --%>
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

                                <td class="celda-incidencia ${empty fila.incidencia ? 'vacia' : ''}"
                                    title="${fila.incidencia}">
                                    <c:choose>
                                        <c:when test="${not empty fila.incidencia}">
                                            ${fila.incidencia}
                                        </c:when>
                                        <c:otherwise>Sin falla reportada</c:otherwise>
                                    </c:choose>
                                </td>

                                    <%--
                                        El estado no sale de bitacora: viene de
                                        reporte_falla.estado_reporte por el LEFT JOIN del DAO.
                                        'Validado' lo pone el docente desde la pantalla de
                                        incidencias; mientras no lo haga, queda 'Pendiente'.
                                    --%>
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

                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </main>
</div>

<jsp:include page="/views/layout/footer.jsp" />
