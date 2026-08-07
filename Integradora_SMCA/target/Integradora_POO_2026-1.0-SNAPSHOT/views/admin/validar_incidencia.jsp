<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Validar Incidencia - UTEZ" />
</jsp:include>

<!-- CSS Formulario Validar Incidencia -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/validar_incidencia.css?v=1">

<div class="main-wrapper">
    <!-- Sidebar del Admin -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="validar-incidencia-body">
            <!-- Logo UTEZ Centrado -->
            <div class="text-center mb-3">
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo img-fluid">
            </div>

            <!-- Tarjeta Principal Gris con Bordes Redondeados -->
            <div class="validar-card">
                <h3 class="validar-card-title text-center">Validar incidencia</h3>

                <form action="ValidarIncidenciaServlet" method="POST" enctype="multipart/form-data">

                    <!-- Campo de Texto para la Descripción -->
                    <div class="mb-4">
                        <textarea
                                name="txtDescripcion"
                                class="form-control custom-textarea"
                                rows="4"
                                placeholder="Ingresa una breve descripción..."></textarea>
                    </div>

                    <!-- Caja para Subir Evidencia -->
                    <div class="mb-4">
                        <label for="inputEvidencia" class="upload-evidence-box">
                            <i class="bi bi-upload upload-icon"></i>
                            <span class="upload-title">Subir evidencia</span>
                            <span class="upload-subtitle">(opcional)</span>
                            <input type="file" id="inputEvidencia" name="fileEvidencia" class="d-none" accept="image/*">
                        </label>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="d-flex justify-content-center gap-3 mt-4">
                        <button type="submit" class="btn-action btn-reportar">Reportar</button>
                        <a href="javascript:history.back()" class="btn-action btn-cancelar text-decoration-none text-center">Cancelar</a>
                    </div>

                </form>
            </div>
        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />