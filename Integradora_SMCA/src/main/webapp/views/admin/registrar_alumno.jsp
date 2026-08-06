<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Registrar alumno - UTEZ" />
</jsp:include>

<!-- CSS Registrar Alumno -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/registrar_alumno.css?v=1">

<div class="main-wrapper">
    <!-- Sidebar Admin -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="registrar-body">

            <!-- Encabezado: Botón Atrás + Logo UTEZ -->
            <div class="header-section">
                <div class="back-link-wrapper">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="bi bi-arrow-left"></i> Pestaña anterior
                    </a>
                </div>
                <div class="logo-wrapper">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo img-fluid">
                </div>
            </div>

            <!-- Tarjeta Principal Gris -->
            <div class="registrar-card">
                <h3 class="registrar-card-title text-center">Registrar alumno</h3>

                <form action="RegistrarAlumnoServlet" method="POST">

                    <div class="row g-3">
                        <!-- Columna Izquierda -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="text" name="txtNombre" class="form-control custom-input" placeholder="Nombre(s)" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" name="txtApellidoPaterno" class="form-control custom-input" placeholder="Apellido paterno" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" name="txtApellidoMaterno" class="form-control custom-input" placeholder="Apellido materno" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" name="txtMatricula" class="form-control custom-input" placeholder="Matricula" required>
                            </div>
                        </div>

                        <!-- Columna Derecha -->
                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="password" name="txtPassword" class="form-control custom-input" placeholder="Contraseña" required>
                            </div>
                            <div class="mb-3">
                                <input type="password" name="txtConfirmPassword" class="form-control custom-input" placeholder="Confirme la contraseña" required>
                            </div>

                            <!-- Carrera y Grupo lado a lado -->
                            <div class="row g-2 mb-3">
                                <div class="col-7">
                                    <select name="carrera" class="form-select custom-input custom-select" required>
                                        <option value="" disabled selected hidden>Carrera</option>
                                        <option value="DS">Desarrollo de software</option>
                                        <option value="DA">Diseño y animación</option>
                                        <option value="DM">Diseño de modas</option>
                                    </select>
                                </div>
                                <div class="col-5">
                                    <select name="grupo" class="form-select custom-input custom-select" required>
                                        <option value="" disabled selected hidden>Grupo</option>
                                        <option value="3A">3°A</option>
                                        <option value="3B">3°B</option>
                                        <option value="3C">3°C</option>
                                        <option value="3D">3°D</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="d-flex justify-content-center gap-4 mt-4">
                        <a href="javascript:history.back()" class="btn-action btn-cancelar text-decoration-none text-center">Cancelar</a>
                        <button type="submit" class="btn-action btn-registrar">Registrar</button>
                    </div>

                    <!-- Enlace inferior de registro de grupo -->
                    <div class="text-center mt-3">
                        <span class="no-grupo-text">¿No encuentras tu grupo? </span>
                        <a href="${pageContext.request.contextPath}/views/admin/admin_registro_grupo.jsp" class="registralo-link">Regístralo aquí</a>
                    </div>

                </form>
            </div>
        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />