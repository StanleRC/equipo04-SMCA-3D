<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Bitácora de incidencias - UTEZ" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

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
        min-width: 900px;
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
        height: 41px;
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
    }
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
                    Bitácora de incidencias
                    <c:if test="${not empty labActual and labActual ne 'Todos'}">
                        &mdash; <c:out value="${labActual}" />
                    </c:if>
                </h2>

                <span class="contador-filas">
                    ${listaBitacora.size()} registro<c:if test="${listaBitacora.size() ne 1}">s</c:if>
                </span>
            </div>

            <div class="tabla-wrapper">
                <table class="tabla-datos" id="tablaBitacora">
                    <thead>
                    <tr>
                        <th style="width: 9%;">Salón</th>
                        <th style="width: 6%;">PC</th>
                        <th style="width: 14%;">Matrícula</th>
                        <th style="width: 24%;">Nombre</th>
                        <th style="width: 12%;">Fecha</th>
                        <th style="width: 10%;">Hora inicial</th>
                        <th style="width: 10%;">Hora final</th>
                        <th style="width: 15%;">Estado</th>
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

                                        <%-- hora_final admite NULL: la sesión sigue abierta. --%>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty fila.horaFinal}">${fila.horaFinal}</c:when>
                                            <c:otherwise><span class="text-muted">En curso</span></c:otherwise>
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
                            <%-- Antes se pintaban filas vacías, que parecían un error de carga. --%>
                            <tr>
                                <td colspan="8" class="sin-datos">
                                    <c:choose>
                                        <c:when test="${not empty labActual and labActual ne 'Todos'}">
                                            Todavía no hay registros de uso en
                                            <c:out value="${labActual}" />.
                                        </c:when>
                                        <c:otherwise>
                                            Todavía no hay registros en la bitácora.
                                        </c:otherwise>
                                    </c:choose>
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

<jsp:include page="/views/layout/footer.jsp" />
