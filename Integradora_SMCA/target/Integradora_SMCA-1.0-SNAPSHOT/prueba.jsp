<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<jsp:include page="/layout/header.jsp">
    <jsp:param name="pageTitle" value="Prueba - Mi Sistema" />
    <jsp:param name="pageHeader" value="Sección de Prueba Externa" />
</jsp:include>

<div class="container-fluid py-4">
    <div class="card border-success p-4">
        <h3 class="text-success">¡Funciona Correctamente! 🎉</h3>
        <p>Como puedes ver, estás en una página completamente distinta (`prueba.jsp`), pero el menú lateral izquierdo, la barra superior y el pie de página de abajo se siguen viendo exactamente en su lugar.</p>

        <div class="alert alert-info mt-3">
            <strong>Nota:</strong> No tuviste que copiar ni una sola línea del código del menú aquí. Si el día de mañana cambias una opción en <code>header.jsp</code>, se actualizará en el Index y aquí al mismo tiempo.
        </div>

        <div class="mt-4">
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-secondary">
                ⬅️ Volver al Inicio
            </a>
        </div>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />