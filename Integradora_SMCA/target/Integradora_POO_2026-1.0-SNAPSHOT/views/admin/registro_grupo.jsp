<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Registro de grupo - UTEZ" />
</jsp:include>

<!-- CSS Registro de Grupo -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registro_grupo.css?v=1">

<div class="main-wrapper">
    <!-- Sidebar Admin -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="registro-grupo-body">

            <!-- Encabezado: Botón Atrás + Logo UTEZ -->
            <div class="header-section">
                <div class="back-link-wrapper">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="bi bi-arrow-left"></i> Pestaña anterior
                    </a>
                </div>
                <div class="logo-wrapper text-center">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo img-fluid">
                    <h2 class="page-subtitle mt-2">Registro de grupo</h2>
                </div>
            </div>

            <!-- Tarjeta Gris Principal -->
            <div class="registro-card">
                <h3 class="registro-card-title text-center">Ingresa los datos<br>del grupo</h3>

                <form action="RegistrarGrupoServlet" method="POST">

                    <!-- Campo Carrera (Select desplegable con flecha) -->
                    <div class="form-group mb-3">
                        <select name="txtCarrera" class="form-select custom-input custom-select" required>
                            <option value="" disabled selected hidden>Carrera</option>
                            <option value="DATSI">DATSI - Tecnologías de la Información</option>
                            <option value="DADM">DADM - Administración</option>
                            <option value="DATEC">DATEC - Mantenimiento</option>
                        </select>
                    </div>

                    <!-- Campo Cuatrimestre -->
                    <div class="form-group mb-3">
                        <input
                                type="text"
                                name="txtCuatrimestre"
                                class="form-control custom-input"
                                placeholder="Cuatrimestre"
                                required>
                    </div>

                    <!-- Campo Grupo -->
                    <div class="form-group mb-4">
                        <input
                                type="text"
                                name="txtGrupo"
                                class="form-control custom-input"
                                placeholder="Grupo"
                                required>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="d-flex justify-content-center gap-4 mt-4">
                        <a href="javascript:history.back()" class="btn-action btn-cancelar text-decoration-none text-center">Cancelar</a>
                        <button type="submit" class="btn-action btn-registrar">Registrar</button>
                    </div>

                </form>
            </div>
        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />