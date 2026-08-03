<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Crear Registro - Bitácora Digital" />
</jsp:include>

<!-- Hoja de Estilos Externa -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/crear_registro.css?v=1">

<div class="main-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal (Desplazada 240px) -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="search-top-blue-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <!-- Cuerpo Centrado -->
        <div class="register-choice-body">
            <div class="container text-center register-choice-container">

                <!-- Logo UTEZ Centrado -->
                <div class="mb-4">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="register-logo-img img-fluid">
                </div>

                <!-- Tarjeta Principal de Selección -->
                <div class="selection-card mx-auto">
                    <h2 class="fw-bold mb-4" style="color: #334155; font-size: 24px;">¿A quién deseas registrar?</h2>

                    <div class="d-flex flex-wrap justify-content-center gap-3">
                        <!-- Profesor -->
                        <a href="${pageContext.request.contextPath}/views/admin/registrar_maestro.jsp" class="btn btn-selection">
                            Profesor
                        </a>

                        <!-- Grupo -->
                        <a href="${pageContext.request.contextPath}/views/admin/registro_grupo.jsp" class="btn btn-selection">
                            Grupo
                        </a>

                        <!-- Alumno -->
                        <a href="${pageContext.request.contextPath}/views/admin/registrar_alumno.jsp" class="btn btn-selection">
                            Alumno
                        </a>
                    </div>
                </div>

            </div>
        </div>
    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />