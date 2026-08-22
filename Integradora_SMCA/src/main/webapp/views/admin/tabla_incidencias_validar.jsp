<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/incidencias_utez.css?v=1">

<div class="main-wrapper">
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="panel-body">
                <div class="mb-2">
                    <a href="javascript:history.back()" class="btn-back">
                        &larr; <u>pestaña anterior</u>
                    </a>
                </div>
                <div class="text-center mb-3">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                         alt="Logo UTEZ" style="max-height: 200px;">
                </div>

                <div class="panel-user"></div>

            <div class="panel-card">
                <!-- ENCABEZADO ALINEADO CON LA TABLA -->
                <div class="table-header-info">
                    <h2 class="panel-title">
                        <c:choose>
                            <c:when test="${empty laboratorioSeleccionado or laboratorioSeleccionado == 'Todos'}">
                                Todos los laboratorios
                            </c:when>
                            <c:otherwise>
                                Ingresaste a <c:out value="${edificioSeleccionado}" /> <c:out value="${aulaSeleccionada}" />
                            </c:otherwise>
                        </c:choose>
                    </h2>

                    <p class="panel-subtitle">
                        <c:choose>
                            <c:when test="${empty laboratorioSeleccionado or laboratorioSeleccionado == 'Todos'}">
                                Ingresaste a las incidencias de todos los laboratorios
                            </c:when>
                            <c:otherwise>
                                Laboratorio: <c:out value="${edificioSeleccionado}" /> <c:out value="${aulaSeleccionada}" />
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <div class="table-wrap">
                    <table class="custom-incidencias-table">
                        <thead>
                        <tr>
                            <th>Bitácora</th>
                            <th>Alumno</th>
                            <th>Matricula</th>
                            <th>PC</th>
                            <th>Laboratorio</th>
                            <th>Prioridad</th>
                            <th>Hora Salida</th>
                            <th>Descripción</th>
                            <th>Fecha</th>
                            <th>Acción</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty incidencias}">
                            <tr class="empty-row">
                                <td colspan="10">No hay incidencias registradas.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="inc" items="${incidencias}">
                            <tr>
                                <td>${inc.id_bitacora}</td>
                                <td>${inc.nombre_alumno} ${inc.apellido_paterno} ${inc.apellido_materno}</td>
                                <td>${inc.alumno_matricula}</td>
                                <td>${inc.numero_pc}</td>
                                <td>${inc.nombre_lab}</td>
                                <td>
                                    <span class="badge
                                        ${inc.prioridad == 'Alta' ? 'bg-danger' :
                                          inc.prioridad == 'Media' ? 'bg-warning text-dark' : 'bg-success'}">
                                            ${inc.prioridad}
                                    </span>
                                </td>
                                <td>${inc.hora_salida}</td>
                                <td>${inc.descripcion_falla}</td>
                                <td>
                                    <fmt:formatDate value="${inc.fecha_reporte}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/views/admin/validar_incidencia.jsp?id=${inc.id_reporte}" class="btn-validar">
                                        Validar
                                    </a>
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