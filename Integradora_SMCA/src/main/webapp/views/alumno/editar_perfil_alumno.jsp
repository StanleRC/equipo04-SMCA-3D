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
<c:set var="alu" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado : sessionScope.alumno}" />

<div class="main-content">

    <header class="top-header">
        <h1 class="top-title">Tu información</h1>
    </header>

    <div class="content-body">

        <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 140px;">
            <p class="subtitle-text">Gestiona tu información personal, avatar institucional y credenciales de acceso.</p>
        </div>

        <%--
            EditarPerfilServlet redirige con ?guardado=1 o ?guardado=0.
            Antes esta vista buscaba ?msj=error, un parámetro que nadie enviaba,
            así que ningún mensaje llegaba a mostrarse.
        --%>
        <c:if test="${param.guardado eq '1'}">
            <div class="alert alert-success alert-dismissible fade show text-center mb-4" role="alert">
                Tus datos se actualizaron correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        </c:if>

        <c:if test="${param.guardado eq '0'}">
            <div class="alert alert-danger alert-dismissible fade show text-center mb-4" role="alert">
                No se pudieron guardar los cambios. Revisa que el correo no esté en uso.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
            </div>
        </c:if>

        <div class="edit-card">
            <form id="formEditarAlumno" action="${pageContext.request.contextPath}/EditarPerfilServlet" method="POST" enctype="multipart/form-data" class="edit-form d-flex w-100">

                <div class="edit-card-left">
                    <div class="large-avatar mb-3">
                        <c:choose>
                            <c:when test="${not empty alu.fotoPerfil}">
                                <img id="previewFoto"
                                     src="${pageContext.request.contextPath}/assets/img/perfiles/${alu.fotoPerfil}"
                                     alt="Foto de perfil"
                                     class="rounded-circle img-fluid"
                                     style="width: 150px; height: 150px; object-fit: cover;"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/perfiles/default.png';">
                            </c:when>
                            <c:otherwise>
                                <div id="avatarIcon" class="d-flex align-items-center justify-content-center rounded-circle bg-secondary text-white" style="width: 150px; height: 150px; font-size: 64px;">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <img id="previewFoto"
                                     src=""
                                     alt="Foto de perfil"
                                     class="rounded-circle img-fluid d-none"
                                     style="width: 150px; height: 150px; object-fit: cover;">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <label for="fotoInput" class="btn-subir-foto">Subir nueva foto</label>
                    <input type="file" id="fotoInput" name="fotoPerfil" accept="image/png, image/jpeg" class="d-none" onchange="previewImage(event)">

                    <p class="upload-info mt-2" id="notaArchivo">
                        Formatos válidos: PNG, JPG.<br>
                        Tamaño máximo: 2 MB.
                    </p>
                </div>

                <div class="edit-card-right">
                    <h2 class="academic-section-title">Información académica</h2>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom" for="txtNombre">Nombre(s)</label>
                            <input type="text" id="txtNombre" name="nombre" class="form-control edit-input" placeholder="Nombre(s)" value="${alu.nombre}" maxlength="60" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom" for="txtApellidoPaterno">Apellido Paterno</label>
                            <input type="text" id="txtApellidoPaterno" name="apellidoPaterno" class="form-control edit-input" placeholder="Apellido Paterno" value="${alu.apellidoPaterno}" maxlength="60" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom" for="txtApellidoMaterno">Apellido Materno</label>
                            <input type="text" id="txtApellidoMaterno" name="apellidoMaterno" class="form-control edit-input" placeholder="Apellido Materno" value="${alu.apellidoMaterno}" maxlength="60" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom" for="txtCorreo">Correo institucional</label>
                            <input type="email" id="txtCorreo" name="correo" class="form-control edit-input" placeholder="Correo" value="${alu.correo}" maxlength="120" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom" for="txtGrupo">Grupo</label>
                            <input type="text" id="txtGrupo" name="grupo" class="form-control edit-input" placeholder="Grupo" value="${alu.grupoIdGrupo}" readonly>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label-custom" for="txtCuatrimestre">Cuatrimestre</label>
                            <input type="text" id="txtCuatrimestre" name="cuatrimestre" class="form-control edit-input" value="3°" readonly>
                        </div>

                        <div class="col-12">
                            <label class="form-label-custom" for="txtCarrera">Carrera</label>
                            <input type="text" id="txtCarrera" name="carrera" class="form-control edit-input" value="Desarrollo de Software Multiplataforma" readonly>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-4 pt-3">
                        <button type="button" class="btn btn-cancelar" onclick="history.back()">Cancelar</button>
                        <button type="submit" id="btnGuardar" class="btn btn-guardar">Guardar cambios</button>
                    </div>

                </div>

            </form>
        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function previewImage(event) {
        const archivo = event.target.files[0];
        const img = document.getElementById('previewFoto');
        const icon = document.getElementById('avatarIcon');
        const nota = document.getElementById('notaArchivo');

        if (!archivo) return;

        // Validar aquí evita subir 5 MB para que el servlet lo descarte al final.
        if (['image/png', 'image/jpeg'].indexOf(archivo.type) === -1) {
            event.target.value = '';
            nota.textContent = 'Ese archivo no es PNG ni JPG.';
            nota.style.color = '#c0392b';
            return;
        }

        if (archivo.size > 2 * 1024 * 1024) {
            event.target.value = '';
            nota.textContent = 'La imagen pesa más de 2 MB.';
            nota.style.color = '#c0392b';
            return;
        }

        const reader = new FileReader();
        reader.onload = function () {
            img.src = reader.result;
            img.classList.remove('d-none');
            if (icon) icon.classList.add('d-none');
        };
        reader.readAsDataURL(archivo);

        nota.textContent = 'Imagen lista: ' + archivo.name;
        nota.style.color = '#1e7e4a';
    }

    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('formEditarAlumno');
        const btnGuardar = document.getElementById('btnGuardar');

        form.addEventListener('submit', function (event) {
            const campos = ['txtNombre', 'txtApellidoPaterno', 'txtApellidoMaterno', 'txtCorreo'];

            for (let i = 0; i < campos.length; i++) {
                const campo = document.getElementById(campos[i]);
                if (campo.value.trim() === '') {
                    event.preventDefault();
                    campo.focus();
                    return;
                }
            }

            // Subir la foto tarda: sin esto es fácil dar doble clic y mandar todo dos veces.
            btnGuardar.disabled = true;
            btnGuardar.textContent = 'Guardando...';
        });

        // Limpiar la URL para que al recargar no reaparezca el mensaje.
        if (window.location.search.indexOf('guardado=') !== -1 && window.history.replaceState) {
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    });

    window.APP_CONFIG = {
        usuarioNombre: "${alu.nombre}",
        contextPath: "${pageContext.request.contextPath}"
    };
</script>
</body>
</html>
