<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>

<%-- Se incluye el Header con el título de la pestaña y de la barra azul --%>
<jsp:include page="/layout/header.jsp">
    <jsp:param name="pageTitle" value="UTEZ - Configuración de Cuenta" />
    <jsp:param name="pageHeader" value="Configuración de Cuenta" />
</jsp:include>

<div class="container-fluid">
    <div class="text-center mb-4">
        <img src="${pageContext.request.contextPath}/assets/img/logo-utez.png" alt="Logo UTEZ" style="max-width: 160px; height: auto;">
        <p class="text-muted mt-3" style="max-width: 600px; margin: 0 auto; font-size: 0.95rem;">
            Gestiona tu información personal, avatar institucional y credenciales de acceso.
        </p>
    </div>

    <div class="row justify-content-center">
        <div class="col-xl-9 col-lg-11">
            <div class="card shadow-sm p-4 bg-white">
                <div class="row g-4">

                    <div class="col-md-4 text-center border-end d-flex flex-column align-items-center justify-content-center py-3">
                        <div class="mb-3">
                            <img src="${pageContext.request.contextPath}/assets/img/default-avatar.png" class="rounded-circle img-thumbnail" style="width: 140px; height: 140px; object-fit: cover;" alt="Avatar">
                        </div>
                        <a href="#" class="fw-bold text-decoration-none" style="color: var(--verde-utez); font-size: 1.1rem;">
                            Subir nueva foto
                        </a>
                        <p class="text-muted mt-3 mb-0" style="font-size: 0.75rem; line-height: 1.4;">
                            Formatos válidos: PNG, JPG.<br>
                            Tamaño máximo recomendado: 2 MB.
                        </p>
                    </div>

                    <div class="col-md-8 py-2 px-md-4">
                        <div class="alert alert-light border-0 mb-4 p-2 d-flex align-items-center" style="background-color: #f1f3f5; border-radius: 8px;">
                            <span class="text-dark ms-2" style="font-size: 0.95rem;">
                                <strong>Rol de usuario:</strong> administrador
                            </span>
                        </div>

                        <form action="${pageContext.request.contextPath}/RegisterMaestroServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label text-uppercase fw-bold text-secondary" style="font-size: 0.75rem; letter-spacing: 0.5px;">Nombre</label>
                                <input type="text" name="nombre" class="form-control form-control-lg shadow-sm" placeholder="Nombre(s)" style="border-radius: 8px;">
                            </div>

                            <div class="mb-3">
                                <label class="form-label text-uppercase fw-bold text-secondary" style="font-size: 0.75rem; letter-spacing: 0.5px;">Correo Institucional</label>
                                <input type="email" name="correo" class="form-control form-control-lg shadow-sm" placeholder="Correo" style="border-radius: 8px;">
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-uppercase fw-bold text-secondary" style="font-size: 0.75rem; letter-spacing: 0.5px;">Teléfono de Contacto</label>
                                <input type="text" name="telefono" class="form-control form-control-lg shadow-sm" placeholder="Teléfono" style="border-radius: 8px;">
                            </div>

                            <div class="text-end">
                                <button type="submit" class="btn btn-utez-green btn-lg px-4 rounded-pill shadow-sm fw-semibold" style="font-size: 0.95rem;">
                                    Guardar cambios
                                </button>
                            </div>
                        </form>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<%-- Se incluye el Footer para cerrar todas las etiquetas abiertas del diseño --%>
<jsp:include page="/layout/footer.jsp" />