<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<jsp:include page="/layout/header.jsp">
    <jsp:param name="pageTitle" value="Prueba - Mi Sistema" />
    <jsp:param name="pageHeader" value="Sección de Prueba Externa" />
</jsp:include>

<div class="container-fluid py-4">
    <div class="card border-success p-4">
        <h3 class="text-success">¡Funciona Correctamente! </h3>
        <p>hola equipo</p>

        <div class="alert alert-info mt-3">
            <strong>Nota:</strong>hola.
        </div>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary">
                ⬅️ Volver al Inicio
            </a>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />