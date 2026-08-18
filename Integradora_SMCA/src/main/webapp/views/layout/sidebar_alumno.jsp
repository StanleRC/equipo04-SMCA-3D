<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- CSS del Sidebar -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/sidebar_exact.css?v=5">

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Alertas personalizadas -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/alertas.css">

<script src="${pageContext.request.contextPath}/assets/js/alertas.js"
        defer></script>

<%--
    Antes el sidebar solo leía sessionScope.usuarioLogueado. Si el login guardaba
    al alumno en sessionScope.alumno, no salía ni la foto ni el nombre.
    Con este c:set se cubren los dos casos en un solo lugar.
--%>
<c:set var="perfil" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado : sessionScope.alumno}" />
<c:set var="fotoSidebar" value="${not empty perfil.fotoPerfil ? perfil.fotoPerfil : 'default.png'}" />

<aside class="figma-sidebar">

    <div class="sidebar-content">

        <!-- PERFIL DEL ALUMNO -->
        <div class="sidebar-profile-section">

            <div class="sidebar-avatar-wrapper">

                <%--
                    La imagen por defecto apuntaba a /assets/img/default.png, pero el
                    archivo vive en /assets/img/perfiles/. Por eso salía rota cuando
                    el alumno todavía no había subido foto.
                --%>
                <div class="sidebar-avatar-img">
                    <img src="${pageContext.request.contextPath}/assets/img/perfiles/${fotoSidebar}"
                         alt="Foto de perfil"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/perfiles/default.png';">
                </div>

                <!-- Editar perfil -->
                <a href="${pageContext.request.contextPath}/views/alumno/editar_perfil_alumno.jsp"
                   class="sidebar-avatar-edit"
                   title="Editar perfil">
                    <i class="bi bi-pencil-fill"></i>
                </a>

            </div>

            <!-- Bienvenida -->
            <p class="sidebar-user-welcome">
                ¡Bienvenido(a)!
            </p>

            <!-- Nombre completo -->
            <p class="sidebar-user-name">
                ${perfil.nombre} ${perfil.apellidoPaterno} ${perfil.apellidoMaterno}
            </p>

            <!-- Rol -->
            <span class="sidebar-user-role">Estudiante</span>

        </div>

        <!-- MENÚ DEL ALUMNO -->
        <nav class="sidebar-menu-nav">
            <a href="${pageContext.request.contextPath}/views/alumno/historial_alumno.jsp"
               class="sidebar-item-link">
                <span>Historial</span>
            </a>
        </nav>

    </div>

    <!-- WIDGET DE HORA E INCIDENCIA -->
    <div class="sidebar-widget-zona">

        <div class="sidebar-reloj">
            <i class="bi bi-clock"></i>
            <span id="relojSidebarTexto">Cargando hora...</span>
        </div>

        <a href="${pageContext.request.contextPath}/views/alumno/crear_incidencia_alumno.jsp"
           class="sidebar-btn-incidencia">
            <i class="bi bi-exclamation-triangle-fill"></i>
            Registrar incidencia
        </a>

    </div>

    <!-- CERRAR SESIÓN -->
    <div class="sidebar-footer-logout">

        <a href="javascript:void(0);"
           onclick="confirmarCierreSesion(
                   event,
                   '${pageContext.request.contextPath}/logoutServlet'
                   )"
           class="sidebar-logout-link">

            <i class="bi bi-box-arrow-left"></i>
            Cerrar sesión

        </a>

    </div>

</aside>

<script>
    function actualizarRelojSidebar() {
        const elemento = document.getElementById('relojSidebarTexto');
        if (!elemento) return;

        const ahora = new Date();
        const fecha = ahora.toLocaleDateString('es-MX', { weekday: 'short', day: 'numeric', month: 'short' });
        const hora = ahora.toLocaleTimeString('es-MX');

        elemento.textContent = fecha + ' | ' + hora;
    }

    actualizarRelojSidebar();
    setInterval(actualizarRelojSidebar, 1000);
</script>
