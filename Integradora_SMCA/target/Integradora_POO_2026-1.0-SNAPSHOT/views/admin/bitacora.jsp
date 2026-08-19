<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Bitácora de Accesos - UTEZ" />
</jsp:include>

<!-- Usamos el mismo CSS que en incidencias para igualar el diseño -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/incidencias_utez.css?v=1">

<div class="main-wrapper">
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>
        <div>
            <a href="javascript:history.back()" class="btn-back">
                ← Pestaña anterior
            </a>
        </div>
        <div class="panel-body">
            <div class="panel-header-row">

                <div>
                    <a href="javascript:history.back()" class="btn-back">
                        ← Pestaña anterior
                    </a>
                </div>

                <div class="panel-logo">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
                </div>

                <div class="panel-user"></div>
            </div>

            <div class="panel-card">
                <!-- ENCABEZADO ALINEADO CON LA TABLA -->
                <div class="table-header-info">
                    <h2 class="panel-title">
                        <c:choose>
                            <c:when test="${empty labActual or labActual == 'Todos'}">
                                Todos los laboratorios
                            </c:when>
                            <c:otherwise>
                                Bitácora del Aula: <c:out value="${labActual}" />
                            </c:otherwise>
                        </c:choose>
                    </h2>

                    <p class="panel-subtitle">
                        <c:choose>
                            <c:when test="${empty labActual or labActual == 'Todos'}">
                                Historial de accesos de todos los laboratorios
                            </c:when>
                            <c:otherwise>
                                Historial de accesos registrados en <c:out value="${labActual}" />
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>

                <!-- CONTENEDOR DE LA TABLA ESTILO INCIDENCIAS -->
                <div class="table-wrap">
                    <table class="custom-incidencias-table">
                        <thead>
                        <tr>
                            <th>No. Bitácora</th>
                            <th>Alumno</th>
                            <th>Matrícula</th>
                            <th>Aula</th>
                            <th>PC</th>
                            <th>Fecha</th>
                            <th>Hora Inicial</th>
                            <th>Hora Final</th>
                        </tr>
                        </thead>
                        <tbody>

                        <c:if test="${empty listaBitacora}">
                            <tr class="empty-row">
                                <td colspan="8" style="text-align: center; padding: 20px; color: #666;">
                                    No hay registros de accesos <c:if test="${not empty labActual and labActual ne 'Todos'}">en el aula <c:out value="${labActual}" /></c:if>.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="fila" items="${listaBitacora}">
                            <tr>
                                <!-- Asumiendo que tu DTO/Modelo tiene estos atributos, si se llaman distinto ajusta el nombre después del "fila." -->
                                <td>${fila.idBitacora != null ? fila.idBitacora : 'N/A'}</td>
                                <td>${fila.nombreCompleto}</td>
                                <td>${fila.matricula}</td>
                                <td><strong>${fila.salon}</strong></td>
                                <td>${fila.numeroPc}</td>
                                <td>${fila.fecha}</td>
                                <td>${fila.horaInicio}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty fila.horaFinal}">
                                            ${fila.horaFinal}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #8a6100; font-weight: bold;">En curso</span>
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