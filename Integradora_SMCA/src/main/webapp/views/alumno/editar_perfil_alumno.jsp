<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Perfil - Alumno</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <!-- CSS Personalizado para Editar Perfil -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/editar_perfil_alumno.css?v=2">
</head>
<body>

<!-- Incluimos el Sidebar del Alumno -->
<jsp:include page="/views/layout/sidebar_alumno.jsp" />

<!-- Contenido Principal -->
<div class="main-content">

    <!-- Banner Superior Azul -->
    <header class="top-header">
        <h1 class="top-title">Tu información</h1>
    </header>

    <!-- Cuerpo del contenido -->
    <div class="content-body">

        <!-- Enlace Pestaña Anterior -->
        <div class="mb-3">
            <a href="javascript:history.back()" class="back-link">
                <i class="bi bi-arrow-left"></i> <u>Pestaña anterior</u>
            </a>
        </div>

        <!-- Logo UTEZ y Subtítulo Centrados -->
        <div class="text-center mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 140px;">
            <p class="subtitle-text">Gestiona tu información personal, avatar institucional y credenciales de acceso.</p>
        </div>

        <!-- Tarjeta Principal de Formulario -->
        <div class="edit-card">
            <!-- La clase d-flex garantiza la estructura de 2 columnas -->
            <form action="${pageContext.request.contextPath}/actualizar_perfil_servlet" method="POST" enctype="multipart/form-data" class="edit-form d-flex w-100">

                <!-- Columna Izquierda: Subir Foto -->
                <div class="edit-card-left">
                    <div class="large-avatar">
                        <i class="bi bi-person-fill"></i>
                    </div>

                    <!-- Botón para subir foto -->
                    <label for="fotoInput" class="btn-subir-foto">Subir nueva foto</label>
                    <input type="file" id="fotoInput" name="fotoPerfil" accept="image/png, image/jpeg" class="d-none">

                    <p class="upload-info">
                        Formatos válidos: PNG, JPG.<br>
                        Tamaño máximo recomendado: 2 MB.
                    </p>
                </div>

                <!-- Columna Derecha: Formulario de Campos Académicos -->
                <div class="edit-card-right">
                    <h2 class="academic-section-title">Información academica</h2>

                    <div class="row g-3">
                        <!-- Nombre -->
                        <div class="col-md-6">
                            <label class="form-label-custom">Nombre</label>
                            <input type="text" name="nombre" class="form-control edit-input" placeholder="Nombre(s)" value="${sessionScope.usuario.nombre}">
                        </div>

                        <!-- Grupo -->
                        <div class="col-md-6">
                            <label class="form-label-custom">Grupo</label>
                            <input type="text" name="grupo" class="form-control edit-input" placeholder="Carrera">
                        </div>

                        <!-- Correo Institucional -->
                        <div class="col-md-6">
                            <label class="form-label-custom">CORREO INSTITUCIONAL</label>
                            <input type="email" name="correo" class="form-control edit-input" placeholder="Correo" value="${sessionScope.usuario.correo}">
                        </div>

                        <!-- Cuatrimestre -->
                        <div class="col-md-6">
                            <label class="form-label-custom">Cuatrimestre</label>
                            <input type="text" name="cuatrimestre" class="form-control edit-input" placeholder="Cuatrimestre">
                        </div>

                        <!-- Teléfono de Contacto -->
                        <div class="col-md-6">
                            <label class="form-label-custom">TELÉFONO DE CONTACTO</label>
                            <input type="tel" name="telefono" class="form-control edit-input" placeholder="Telefono">
                        </div>

                        <!-- Carrera -->
                        <div class="col-md-6">
                            <label class="form-label-custom">Carrera</label>
                            <input type="text" name="carrera" class="form-control edit-input" placeholder="Carrera">
                        </div>
                    </div>

                    <!-- Botones de Acción -->
                    <div class="d-flex justify-content-center gap-3 mt-4 pt-3">
                        <button type="button" class="btn btn-cancelar" onclick="history.back()">Cancelar</button>
                        <button type="submit" class="btn btn-guardar">Guardar cambios</button>
                    </div>

                </div>

            </form>
        </div>

    </div>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>