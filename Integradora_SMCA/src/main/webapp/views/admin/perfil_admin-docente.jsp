<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Configuración de Cuenta - Bitácora" />
</jsp:include>

<!-- CSS de Configuración de Cuenta -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/config_perfil.css?v=4">

<!-- CDN de SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Recursos de alertas personalizadas -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
<script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

<div class="main-wrapper">
    <!-- Sidebar Exclusivo de Docente -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Por esto otro: -->
        <div class="profile-top-blue-bar">
            Configuración de Cuenta (<c:choose><c:when test="${sessionScope.esAdmin}">Administrador</c:when><c:otherwise>Docente</c:otherwise></c:choose>)
        </div>

        <!-- Cuerpo Centrado del Formulario -->
        <div class="profile-page-body">
            <div class="container">

                <!-- Logo UTEZ Centrado -->
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="width: 200px; height: auto;">
                </div>

                <!-- Tarjeta Principal de Configuración -->
                <div class="profile-main-card">

                    <p class="text-center profile-instruction-text mb-4">
                        Gestiona tu información personal, avatar institucional y credenciales de acceso.
                    </p>

                    <form id="formConfigCuenta" action="${pageContext.request.contextPath}/EditarPerfilServlet" method="POST" enctype="multipart/form-data">
                        <div class="row align-items-center">

                            <!-- Columna Izquierda: Cargar Foto -->
                            <div class="col-md-5 avatar-upload-section text-center">
                                <div style="width: 150px; height: 150px; border-radius: 50%; overflow: hidden; background-color: #e2e8f0; margin: 0 auto 15px auto; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
                                    <c:set var="fotoNombre" value="${not empty sessionScope.usuarioLogueado.fotoPerfil ? sessionScope.usuarioLogueado.fotoPerfil : sessionScope.docente.fotoPerfil}" />

                                    <img id="previewFoto"
                                         src="${pageContext.request.contextPath}/assets/img/perfiles/${not empty fotoNombre ? fotoNombre : 'default.png'}"
                                         alt=""
                                         style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%; display: block;"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/perfiles/default.png';">
                                </div>

                                <!-- Botón enlazado al Input File invisible -->
                                <label for="fotoInput" style="color: #0284c7; font-weight: 600; cursor: pointer; text-decoration: underline; font-size: 14px;">Subir nueva foto</label>
                                <input type="file" id="fotoInput" name="fotoPerfil" accept="image/png, image/jpeg" class="d-none" onchange="previewImage(event)">

                                <p id="notaArchivo" style="font-size: 12px; color: #64748b; margin-top: 8px; line-height: 1.4;">
                                    Formatos válidos: PNG, JPG.<br>Tamaño máximo recomendado: 2 MB.
                                </p>
                            </div>

                            <!-- Columna Derecha: Campos del Formulario -->
                            <div class="col-md-7 profile-form-section">
                                <div class="user-role-badge mb-3">
                                    Rol de usuario:
                                    <span class="text-muted font-weight-normal">
            <c:choose>
                <c:when test="${sessionScope.esAdmin}">Administrador</c:when>
                <c:otherwise>Docente</c:otherwise>
            </c:choose>
        </span>
                                </div>
                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Nombre(s)</label>
                                    <input type="text" id="txtNombre" name="nombre" class="form-control profile-form-input" placeholder="Nombre(s)" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado.nombre : sessionScope.docente.nombre}" autocomplete="off" required>
                                </div>

                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Apellido Paterno</label>
                                    <input type="text" id="txtApellidoPaterno" name="apellidoPaterno" class="form-control profile-form-input" placeholder="Apellido Paterno" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado.apellidoPaterno : sessionScope.docente.apellidoPaterno}" autocomplete="off" required>
                                </div>

                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Apellido Materno</label>
                                    <input type="text" id="txtApellidoMaterno" name="apellidoMaterno" class="form-control profile-form-input" placeholder="Apellido Materno" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado.apellidoMaterno : sessionScope.docente.apellidoMaterno}" autocomplete="off" required>
                                </div>

                                <div class="form-group mb-3">
                                    <label class="profile-form-label">Correo Institucional</label>
                                    <input type="email" id="txtCorreo" name="correo" class="form-control profile-form-input" placeholder="Correo" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado.correo : sessionScope.docente.correo}" autocomplete="off" required>
                                </div>

                                <!-- Botones de Acción Estilo UTEZ Directos -->
                                <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 25px;">
                                    <a href="javascript:history.back()"
                                       style="padding: 10px 22px; background-color: #6c757d; color: #ffffff !important; text-decoration: none !important; border-radius: 8px; font-weight: 600; font-size: 14px; display: inline-block;">
                                        Cancelar
                                    </a>
                                    <button type="submit" id="btnGuardar"
                                            style="padding: 10px 22px; background-color: #00875a; color: #ffffff !important; border: none; border-radius: 8px; font-weight: 600; font-size: 14px; cursor: pointer; display: inline-block;">
                                        Guardar cambios
                                    </button>
                                </div>
                            </div>

                        </div>
                    </form>

                </div>

            </div>
        </div>
    </main>
</div>

<!-- Resultado que devuelve EditarPerfilServlet en la URL (?guardado=1 o ?guardado=0) -->
<span id="flashGuardado" hidden><c:out value="${param.guardado}" /></span>

<!-- Scripts de Previsualización y Alerta -->
<script>
    function previewImage(event) {
        const archivo = event.target.files[0];
        const img = document.getElementById('previewFoto');
        const nota = document.getElementById('notaArchivo');

        if (!archivo) return;

        // Validar antes de enviar: el servlet rechaza cualquier otra cosa.
        const tiposValidos = ['image/png', 'image/jpeg'];
        if (tiposValidos.indexOf(archivo.type) === -1) {
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
        };
        reader.readAsDataURL(archivo);

        nota.textContent = 'Imagen lista: ' + archivo.name;
        nota.style.color = '#1e7e4a';
    }

    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('formConfigCuenta');
        const btnGuardar = document.getElementById('btnGuardar');

        if (form) {
            form.addEventListener('submit', function (event) {
                const nombre = document.getElementById('txtNombre').value.trim();
                const apellidoPaterno = document.getElementById('txtApellidoPaterno').value.trim();
                const apellidoMaterno = document.getElementById('txtApellidoMaterno').value.trim();
                const correo = document.getElementById('txtCorreo').value.trim();

                if (nombre === '' || apellidoPaterno === '' || apellidoMaterno === '' || correo === '') {
                    event.preventDefault();
                    if (typeof mostrarAlertaError === 'function') {
                        mostrarAlertaError('Por favor, completa todos los campos del formulario.');
                    } else {
                        alert('Por favor, completa todos los campos.');
                    }
                    return;
                }

                // Ya NO se muestra el mensaje de éxito aquí. Antes salía "¡Cambios realizados
                // de manera exitosa!" antes de enviar nada, así que aparecía incluso cuando la
                // base de datos rechazaba el cambio. Ahora el formulario se envía normal y la
                // confirmación llega del servidor en el bloque de abajo.
                btnGuardar.disabled = true;
                btnGuardar.textContent = 'Guardando...';
            });
        }

        // Resultado real del servlet
        const guardado = document.getElementById('flashGuardado').textContent.trim();

        if (guardado === '1') {
            if (typeof mostrarAlertaExito === 'function') {
                mostrarAlertaExito('¡Cambios realizados de manera exitosa!');
            } else if (typeof Swal !== 'undefined') {
                Swal.fire({ icon: 'success', title: 'Listo', text: '¡Cambios realizados de manera exitosa!', timer: 2200, showConfirmButton: false });
            }
        } else if (guardado === '0') {
            const mensaje = 'No se pudieron guardar los cambios. Revisa que el correo no esté en uso.';
            if (typeof mostrarAlertaError === 'function') {
                mostrarAlertaError(mensaje);
            } else if (typeof Swal !== 'undefined') {
                Swal.fire({ icon: 'error', title: 'Algo salió mal', text: mensaje });
            } else {
                alert(mensaje);
            }
        }

        // Limpiar la URL para que al recargar no vuelva a salir la alerta.
        if (guardado && window.history.replaceState) {
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    });
</script>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />
