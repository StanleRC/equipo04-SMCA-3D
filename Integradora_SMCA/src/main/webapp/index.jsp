<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<jsp:include page="/layout/header.jsp">
    <jsp:param name="pageTitle" value="Inicio - Mi Sistema" />
    <jsp:param name="pageHeader" value="Panel de Control Principal" />
</jsp:include>

<div class="container-fluid py-4">
    <div class="card shadow-sm p-4">
        <h2 class="text-secondary">¡Bienvenido de nuevo!</h2>
        <p class="lead">Esta es la página principal de tu aplicación. El menú de la izquierda y el título de arriba se cargan desde tu plantilla.</p>

        <hr class="my-4">

        <p>Haz clic en el siguiente botón para ir a la nueva página de prueba externa y comprobar que el diseño se mantiene idéntico:</p>

        <a href="${pageContext.request.contextPath}/prueba.jsp" class="btn btn-primary btn-lg">
            Ir a la Página de Prueba ➡️
        </a>
    </div>
</div>

<jsp:include page="/layout/footer.jsp" />/layout/footer.jsp" />