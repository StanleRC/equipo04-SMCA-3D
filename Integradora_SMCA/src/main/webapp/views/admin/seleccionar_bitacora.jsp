<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Seleccionar Laboratorio - UTEZ" />
</jsp:include>

<style>
    .aviso-vacio {
        background: #fdf0d5;
        color: #8a6100;
        border-radius: 10px;
        padding: 16px 18px;
        font-size: 14px;
        line-height: 1.5;
        margin: 10px 0;
    }

    .contador-labs {
        font-size: 13px;
        color: #8a8a8a;
        text-align: center;
        margin-bottom: 4px;
    }

    .btn-todos {
        display: inline-block;
        margin-top: 6px;
        font-size: 13px;
        color: #1c3862;
        text-decoration: underline;
    }
</style>

<div class="main-wrapper">
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="salones-body">

            <div class="salones-header-row">
                <div>
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                         alt="Logo UTEZ" class="utez-logo">
                </div>

                <div></div>
            </div>

            <p class="contador-labs">
                Selecciona un laboratorio para ver su bitácora de accesos
                <c:if test="${totalLaboratorios gt 0}">
                    &middot; ${totalLaboratorios} disponible<c:if test="${totalLaboratorios ne 1}">s</c:if>
                </c:if>
            </p>

            <div class="salones-card">

                <c:choose>
                    <c:when test="${not empty laboratoriosPorEdificio}">

                        <%--
                            Idéntico a incidencias.jsp. La única diferencia es a dónde
                            apunta el botón: allá va a ValidarIncidenciasServlet y aquí
                            a BitacoraServlet.

                            Los laboratorios salen de la tabla LABORATORIO, no escritos
                            a mano, así que agregar un aula en la base la hace aparecer
                            sola en esta pantalla.
                        --%>
                        <c:forEach var="grupo" items="${laboratoriosPorEdificio}">
                            <div class="building-section">
                                <h3 class="building-title">${grupo.key}</h3>

                                <div class="buttons-grid">
                                    <c:forEach var="lab" items="${grupo.value}">
                                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=${lab.aula}"
                                           class="btn-salon"
                                           title="${lab.nombreLab}">
                                                ${lab.aula}
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>

                        <div class="text-center">
                            <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=Todos"
                               class="btn-todos">
                                Ver la bitácora de todos los laboratorios
                            </a>
                        </div>

                    </c:when>

                    <c:otherwise>
                        <%--
                            Si ves esto teniendo laboratorios en la base, casi seguro
                            abriste el .jsp directo en vez de pasar por
                            SeleccionarBitacoraServlet: nadie llenó el atributo.
                        --%>
                        <div class="aviso-vacio">
                            No hay laboratorios registrados en el sistema.
                            Agrégalos en la tabla <strong>laboratorio</strong> y aparecerán aquí
                            automáticamente.
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>

        </div>

    </main>
</div>

<jsp:include page="/views/layout/footer.jsp" />
