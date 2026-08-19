<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- CSS del Sidebar -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/sidebar_exact.css?v=4">

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Alertas personalizadas -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/alertas.css">

<script src="${pageContext.request.contextPath}/assets/js/alertas.js"
        defer></script>

<aside class="figma-sidebar">

    <!--
         CONTENIDO DEL SIDEBAR
        -->
    <div class="sidebar-content">

        <!-- PERFIL ADMIN / DOCENTE -->
        <div class="sidebar-profile-section">

            <div class="sidebar-avatar-wrapper">

                <!-- Variable dinámica con la foto del usuario -->
                <c:set var="fotoSidebar" value="${not empty sessionScope.usuarioLogueado.fotoPerfil ? sessionScope.usuarioLogueado.fotoPerfil : sessionScope.docente.fotoPerfil}" />

                <!-- Avatar Dinámico Limpio -->
                <div class="sidebar-avatar-img" style="width: 100px; height: 100px; border-radius: 50%; overflow: hidden; margin: 0 auto; background-color: #00875a;">
                    <img src="${pageContext.request.contextPath}/assets/img/perfiles/${not empty fotoSidebar ? fotoSidebar : 'default.png'}"
                         alt=""
                         style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%; display: block;"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/perfiles/default.png';">
                </div>

                <!-- Editar foto -->
                <a href="${pageContext.request.contextPath}/views/admin/perfil_admin-docente.jsp"
                   class="sidebar-avatar-edit"
                   title="Editar foto">
                    <i class="bi bi-pencil"></i>
                </a>

            </div>

            <!-- Bienvenida -->
            <p class="sidebar-user-welcome">
                ¡Bienvenido(a)!
            </p>

            <!-- Nombre Real del Docente/Admin -->
            <p class="sidebar-user-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                        ${sessionScope.usuarioLogueado.nombre} ${sessionScope.usuarioLogueado.apellidoPaterno} ${sessionScope.usuarioLogueado.apellidoMaterno}
                    </c:when>
                    <c:when test="${not empty sessionScope.docente}">
                        ${sessionScope.docente.nombre} ${sessionScope.docente.apellidoPaterno} ${sessionScope.docente.apellidoMaterno}
                    </c:when>
                    <c:otherwise>
                        ${sessionScope.usuario.nombre} ${sessionScope.usuario.apellidoPaterno} ${sessionScope.usuario.apellidoMaterno}
                    </c:otherwise>
                </c:choose>
            </p>

        </div>

        <!-- ==========================================
             MENÚ ADMIN / DOCENTE
             ========================================== -->
        <nav class="sidebar-menu-nav">

            <a href="${pageContext.request.contextPath}/views/admin/buscador.jsp"
               class="sidebar-item-link">
                Buscar
            </a>

            <a href="${pageContext.request.contextPath}/views/admin/bitacora.jsp"
               class="sidebar-item-link">
                Bitácora
            </a>

            <a href="${pageContext.request.contextPath}/views/admin/incidencias.jsp"
               class="sidebar-item-link">
                Incidencias
            </a>

            <a href="${pageContext.request.contextPath}/views/admin/crear_registro.jsp"
               class="sidebar-item-link">
                Nuevo<br>registro
            </a>

            <a href="${pageContext.request.contextPath}/views/admin/perfil_admin-docente.jsp"
               class="sidebar-item-link">
                Tu perfil
            </a>
            <a>
            </a>
        </nav>

    </div>

    <!-- CERRAR SESIÓN -->
    <div class="sidebar-footer-logout">

        <a href="javascript:void(0);"
           onclick="confirmarCierreSesion(
                   event,
                   '${pageContext.request.contextPath}/logoutServlet'
                   )"
           class="sidebar-logout-link">

            <i class="bi bi-box-arrow-right"></i>
            Cerrar sesión

        </a>

    </div>

</aside>