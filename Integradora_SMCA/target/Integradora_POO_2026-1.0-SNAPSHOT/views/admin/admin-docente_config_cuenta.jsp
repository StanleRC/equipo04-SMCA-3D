<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Configuración de Cuenta - Bitácora" />
</jsp:include>

<!-- CSS de Configuración de Cuenta -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/config_perfil.css?v=3">

<div class="main-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal (Desplazada 240px a la derecha) -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="profile-top-blue-bar">
            Configuración de Cuenta
        </div>

        <!-- Cuerpo Centrado del Formulario -->
        <div class="profile-page-body">
            <div class="container">

                <!-- Logo UTEZ Centrado -->
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="profile-logo-img img-fluid">
                </div>

                <!-- Tarjeta Principal de Configuración -->
                <div class="profile-main-card">

                    <p class="text-center profile-instruction-text mb-4">
                        Gestiona tu información personal, avatar institucional y credenciales de acceso.
                    </p>

                    <form action="ActualizarPerfilServlet" method="POST" enctype="multipart/form-data">
                        <div class="row align-items-center">

                            <!-- Columna Izquierda: Cargar Foto -->
                            <div class="col-md-5 avatar-upload-section text-center">
                                <div class="avatar-preview-circle">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <button type="button" class="btn-upload-link">Subir nueva foto</button>
                                <p class="avatar-specs-text">
                                    Formatos válidos: PNG, JPG.<br>Tamaño máximo recomendado: 2 MB.
                                </p>
                            </div>

                            <!-- Columna Derecha: Campos del Formulario -->
                            <div class="col-md-7 profile-form-section">
                                <div class="user-role-badge">
                                    Rol de usuario: <span class="text-muted font-weight-normal">administrador</span>
                                </div>

                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Nombre</label>
                                    <input type="text" name="txtNombre" class="form-control profile-form-input" placeholder="Nombre(s)" autocomplete="off">
                                </div>

                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Correo Institucional</label>
                                    <input type="email" name="txtCorreo" class="form-control profile-form-input" placeholder="Correo" autocomplete="off">
                                </div>

                                <div class="form-group mb-4">
                                    <label class="profile-form-label">Teléfono de Contacto</label>
                                    <input type="text" name="txtTelefono" class="form-control profile-form-input" placeholder="Telefono" autocomplete="off">
                                </div>

                                <div class="text-end mt-4">
                                    <button type="submit" class="btn-profile-save">Guardar cambios</button>
                                </div>
                            </div>

                        </div>
                    </form>

                </div>

            </div>
        </div>
    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />