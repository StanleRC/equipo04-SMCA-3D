<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- CSS del Sidebar -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/sidebar_exact.css?v=3">

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Alertas personalizadas -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/alertas.css">

<script src="${pageContext.request.contextPath}/assets/js/alertas.js"
        defer></script>

<aside class="figma-sidebar">

    <div class="sidebar-content">

        <!-- PERFIL DEL ALUMNO -->
        <div class="sidebar-profile-section">

            <div class="sidebar-avatar-wrapper">

                <!-- Foto del alumno -->
                <div class="sidebar-avatar-img">
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado.fotoPerfil}">
                            <img src="${pageContext.request.contextPath}/assets/img/perfiles/${sessionScope.usuarioLogueado.fotoPerfil}"
                                 alt="Foto de perfil"
                                 style="width: 100%; height: 100%; object-fit: cover;">
                        </c:when>
                        <c:when test="${not empty sessionScope.alumno.fotoPerfil}">
                            <img src="${pageContext.request.contextPath}/assets/img/perfiles/${sessionScope.alumno.fotoPerfil}"
                                 alt="Foto de perfil"
                                 style="width: 100%; height: 100%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/img/default_profile.png"
                                 alt="Foto de perfil predeterminada"
                                 style="width: 100%; height: 100%; object-fit: cover;">
                        </c:otherwise>
                    </c:choose>
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

            <!-- Nombre del alumno -->
            <p class="sidebar-user-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                        ${sessionScope.usuarioLogueado.nombre} ${sessionScope.usuarioLogueado.apellidoPaterno} ${sessionScope.usuarioLogueado.apellidoMaterno}
                    </c:when>
                    <c:otherwise>
                        ${sessionScope.alumno.nombre} ${sessionScope.alumno.apellidoPaterno} ${sessionScope.alumno.apellidoMaterno}
                    </c:otherwise>
                </c:choose>
            </p>

        </div>

        <!-- MENÚ DEL ALUMNO -->
        <nav class="sidebar-menu-nav">

            <a href="${pageContext.request.contextPath}/PerfilAlumnoServlet"
               class="sidebar-item-link">
                <span>Tu perfil</span>
            </a>

            <a href="${pageContext.request.contextPath}/views/alumno/historial_alumno.jsp"
               class="sidebar-item-link">
                <span>Historial</span>
            </a>

        </nav>

    </div>

    <!-- WIDGET DE HORA E INCIDENCIA -->
    <div style="padding: 0 15px; margin-bottom: 15px; text-align: center;">

        <div style="background-color: rgba(255, 255, 255, 0.12); color: #ffffff; padding: 8px 10px; border-radius: 8px; font-size: 0.85rem; margin-bottom: 10px; display: flex; align-items: center; justify-content: center; gap: 6px;">
            <i class="bi bi-clock"></i>
            <span id="relojSidebarTexto">Cargando hora...</span>
        </div>

        <a href="${pageContext.request.contextPath}/views/alumno/crear_incidencia_alumno.jsp"
           style="display: flex; align-items: center; justify-content: center; gap: 8px; width: 100%; background-color: #dc3545; color: #ffffff; padding: 10px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 0.85rem; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: background 0.3s;"
           onmouseover="this.style.backgroundColor='#b02a37'"
           onmouseout="this.style.backgroundColor='#dc3545'">
            <i class="bi bi-exclamation-triangle-fill"></i>
            Registrar incidencia.
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
        const ahora = new Date();
        const opciones = { weekday: 'short', day: 'numeric', month: 'short' };
        const fecha = ahora.toLocaleDateString('es-ES', opciones);
        const hora = ahora.toLocaleTimeString('es-ES');

        const elemento = document.getElementById('relojSidebarTexto');
        if (elemento) {
            elemento.textContent = fecha + ' | ' + hora;
        }
    }

    setInterval(actualizarRelojSidebar, 1000);
    actualizarRelojSidebar();
</script>