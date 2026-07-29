<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Configuración de Cuenta - Bitácora" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/config_perfil.css">

<div class="main-wrapper">
    <jsp:include page="layout/sidebar.jsp" />

    <div class="flex-grow-1 d-flex flex-column" style="min-height: 100vh;">

        <div class="profile-top-blue-bar">
            Configuración de Cuenta
        </div>

        <div class="profile-page-body flex-grow-1 d-flex align-items-center justify-content-center">
            <div class="container">

                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 75px;" class="img-fluid">
                </div>

                <div class="profile-main-card">

                    <p class="text-center profile-instruction-text mb-4">
                        Gestiona tu información personal, avatar institucional y credenciales de acceso.
                    </p>

                    <form action="ActualizarPerfilServlet" method="POST" enctype="multipart/form-data">
                        <div class="row">

                            <div class="col-md-5 avatar-upload-section text-center">
                                <div class="avatar-preview-circle">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <button type="button" class="btn-upload-link">Subir nueva foto</button>
                                <p class="avatar-specs-text">
                                    Formatos válidos: PNG, JPG.<br>Tamaño máximo recomendado: 2 MB.
                                </p>
                            </div>

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
    </div>
</div>

<jsp:include page="layout/footer.jsp" />