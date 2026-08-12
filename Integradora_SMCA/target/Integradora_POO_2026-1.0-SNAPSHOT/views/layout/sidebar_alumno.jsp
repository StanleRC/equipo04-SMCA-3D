<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- CSS del Sidebar -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar_alumno.css?v=2">

<!-- CDN de SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Recursos globales de alertas -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
<script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

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


    <div class="sidebar-footer-logout">
        <a href="javascript:void(0);"
           onclick="confirmarCierreSesion(event, '${pageContext.request.contextPath}/index.jsp')"
           class="sidebar-logout-link">
            <i class="bi bi-box-arrow-left"></i> Cerrar sesión
        </a>
    </div>
</aside>