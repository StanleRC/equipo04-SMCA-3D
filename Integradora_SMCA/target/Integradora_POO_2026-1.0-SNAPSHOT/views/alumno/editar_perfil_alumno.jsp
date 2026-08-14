<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Perfil - Alumno</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/editar_perfil_alumno.css?v=2">
</head>
<body>

<jsp:include page="/views/layout/sidebar_alumno.jsp" />

<div class="main-content">

    <header class="top-header">
        <h1 class="top-title">Tu información</h1>
    </header>

    <div class="content-body">



        <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 140px;">
            <p class="subtitle-text">Gestiona tu información personal, avatar institucional y credenciales de acceso.</p>
        </div>

        <c:if test="${param.msj eq 'error'}">
            <div class="alert alert-danger alert-dismissible fade show text-center mb-4" role="alert">
                Ocurrió un error al actualizar los datos. Por favor, intenta de nuevo.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="edit-card">
            <form action="${pageContext.request.contextPath}/EditarPerfilServlet" method="POST" enctype="multipart/form-data" class="edit-form d-flex w-100">

                <div class="edit-card-left">
                    <div class="large-avatar mb-3">
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioLogueado.fotoPerfil}">
                                <img id="previewFoto"
                                     src="${pageContext.request.contextPath}/assets/img/perfiles/${sessionScope.usuarioLogueado.fotoPerfil}"
                                     alt="Avatar Alumno"
                                     class="rounded-circle img-fluid"
                                     style="width: 150px; height: 150px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <div id="avatarIcon" class="d-flex align-items-center justify-content-center rounded-circle bg-secondary text-white" style="width: 150px; height: 150px; font-size: 64px;">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <img id="previewFoto"
                                     src=""
                                     alt="Avatar Alumno"
                                     class="rounded-circle img-fluid d-none"
                                     style="width: 150px; height: 150px; object-fit: cover;">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <label for="fotoInput" class="btn-subir-foto">Subir nueva foto</label>
                    <input type="file" id="fotoInput" name="fotoPerfil" accept="image/png, image/jpeg" class="d-none" onchange="previewImage(event)">

                    <p class="upload-info mt-2">
                        Formatos válidos: PNG, JPG.<br>
                        Tamaño máximo recomendado: 2 MB.
                    </p>
                </div>

                <div class="edit-card-right">
                    <h2 class="academic-section-title">Información académica</h2>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Nombre(s)</label>
                            <input type="text" name="nombre" class="form-control edit-input" placeholder="Nombre(s)" value="${sessionScope.usuarioLogueado.nombre}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Apellidos</label>
                            <input type="text" name="apellidos" class="form-control edit-input" placeholder="Apellidos" value="${sessionScope.usuarioLogueado.apellidos}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">CORREO INSTITUCIONAL</label>
                            <input type="email" name="correo" class="form-control edit-input" placeholder="Correo" value="${sessionScope.usuarioLogueado.correo}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Grupo</label>
                            <input type="text" name="grupo" class="form-control edit-input" placeholder="Grupo" value="${sessionScope.usuarioLogueado.grupoIdGrupo}" readonly>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Cuatrimestre</label>
                            <input type="text" name="cuatrimestre" class="form-control edit-input" value="3°" readonly>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom">Carrera</label>
                            <input type="text" name="carrera" class="form-control edit-input" value="Desarrollo de Software" readonly>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-4 pt-3">
                        <button type="button" class="btn btn-cancelar" onclick="history.back()">Cancelar</button>
                        <button type="submit" class="btn btn-guardar">Guardar cambios</button>
                    </div>

                </div>

            </form>
        </div>

    </div>

</div>

<script>
    function previewImage(event) {
        const reader = new FileReader();
        const img = document.getElementById('previewFoto');
        const icon = document.getElementById('avatarIcon');

        reader.onload = function() {
            img.src = reader.result;
            img.classList.remove('d-none');
            if (icon) icon.classList.add('d-none');
        };

        if (event.target.files[0]) {
            reader.readAsDataURL(event.target.files[0]);
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Definición de variables JSP antes de cargar el archivo JS -->
<script>
    window.APP_CONFIG = {
        usuarioNombre: "${sessionScope.usuarioLogueado.nombre}",
        contextPath: "${pageContext.request.contextPath}"
    };
</script>

<!-- Importar el archivo JS (con ?v=2 para obligar al navegador a recargar el JS actualizado) -->
<script src="${pageContext.request.contextPath}/assets/js/modal_bienvenida_alumno.js?v=2"></script>
</body>
</html>