<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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

    <!-- ==========================================
         CONTENIDO DEL SIDEBAR
         ========================================== -->
    <div class="sidebar-content">

        <!-- PERFIL ADMIN / DOCENTE -->
        <div class="sidebar-profile-section">

            <div class="sidebar-avatar-wrapper">

                <!-- Avatar -->
                <div class="sidebar-avatar-img">
                    <i class="bi bi-person-fill"></i>
                </div>

                <!-- Editar foto -->
                <a href="${pageContext.request.contextPath}/views/admin/admin-docente_config_cuenta.jsp"
                   class="sidebar-avatar-edit"
                   title="Editar foto">

                    <i class="bi bi-pencil"></i>

                </a>

            </div>

            <!-- Bienvenida -->
            <p class="sidebar-user-welcome">
                ¡Bienvenido(a)!
            </p>

            <!-- Nombre -->
            <p class="sidebar-user-name">
                ${sessionScope.usuario.nombre != null
                        ? sessionScope.usuario.nombre
                        : 'Pedro Urieta'}
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

            <a href="${pageContext.request.contextPath}/views/admin/admin-docente_config_cuenta.jsp"
               class="sidebar-item-link">
                Editar
            </a>

        </nav>

    </div>


    <!-- ==========================================
         CERRAR SESIÓN
         ========================================== -->
    <div class="sidebar-footer-logout">

        <a href="javascript:void(0);"
           onclick="confirmarCierreSesion(
                   event,
                   '${pageContext.request.contextPath}/index.jsp'
                   )"
           class="sidebar-logout-link">

            <i class="bi bi-box-arrow-right"></i>
            Cerrar sesión

        </a>

    </div>

</aside>