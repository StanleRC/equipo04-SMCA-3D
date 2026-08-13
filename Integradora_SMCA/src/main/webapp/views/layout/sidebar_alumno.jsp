<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- CSS del Sidebar -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar_alumno.css?v=2">

<!-- CDN de SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Recursos globales de alertas -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
<script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

<style>
    /* Estilos forzados para garantizar el scroll en la barra lateral */
    .figma-sidebar {
        height: 100vh !important;
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        overflow-y: auto !important; /* Habilita el scroll vertical */
        display: flex !important;
        flex-direction: column !important;
        justify-content: space-between !important;
        z-index: 1000;
    }

    /* Ocultar barra de scroll estética si no quieres que se vea tosca */
    .figma-sidebar::-webkit-scrollbar {
        width: 6px;
    }
    .figma-sidebar::-webkit-scrollbar-thumb {
        background-color: rgba(255, 255, 255, 0.3);
        border-radius: 4px;
    }
</style>

<aside class="figma-sidebar">
    <div class="d-flex flex-column w-100">

        <!-- Perfil del Alumno -->
        <div class="sidebar-profile-section">
            <div class="sidebar-avatar-wrapper">
                <div class="sidebar-avatar-img">
                    <img src="${not empty sessionScope.usuarioFoto
                     ? pageContext.request.contextPath.concat(sessionScope.usuarioFoto)
                     : pageContext.request.contextPath.concat('/assets/img/default_profile.png')}"
                         alt="Foto Perfil">
                </div>
                <a href="${pageContext.request.contextPath}/views/alumno/editar_perfil_alumno.jsp"
                   class="sidebar-avatar-edit" title="Editar perfil">
                    <i class="bi bi-pencil-fill"></i>
                </a>
            </div>

            <div class="sidebar-user-welcome">¡Bienvenido(a)!</div>
            <div class="user-info-section">
                <h4 class="user-name-text">
                    ${sessionScope.usuarioLogueado.nombre} ${sessionScope.usuarioLogueado.apellidos}
                </h4>
            </div>
        </div>

        <!-- Menú de Navegación del Alumno -->
        <nav class="sidebar-menu-nav">
            <a href="${pageContext.request.contextPath}/views/alumno/perfil_alumno.jsp" class="sidebar-item-link">
                <span>Tu perfil</span>
                <i class="bi bi-arrow-right"></i>
            </a>

            <a href="${pageContext.request.contextPath}/views/alumno/historial_alumno.jsp" class="sidebar-item-link">
                <span>Historial</span>
                <i class="bi bi-arrow-right"></i>
            </a>
        </nav>
    </div>

    <!-- Botón Cerrar Sesión (Ahora siempre accesible haciendo scroll) -->
    <div class="sidebar-footer-logout" style="padding-bottom: 20px;">
        <a href="javascript:void(0);"
           onclick="confirmarCierreSesion(event, '${pageContext.request.contextPath}/index.jsp')"
           class="sidebar-logout-link">
            <i class="bi bi-box-arrow-left"></i> Cerrar sesión
        </a>
    </div>
</aside>