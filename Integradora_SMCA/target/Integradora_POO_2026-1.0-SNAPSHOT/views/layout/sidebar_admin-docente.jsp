<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar_exact.css?v=2">

<aside class="figma-sidebar">
    <!-- Sección Superior: Avatar y Nombre -->
    <div class="sidebar-profile-section">
        <div class="sidebar-avatar-wrapper">
            <div class="sidebar-avatar-img">
                <i class="bi bi-person-fill"></i>
            </div>
            <!-- Botón Editar con Lápiz -->
            <a href="${pageContext.request.contextPath}/views/admin/admin-docente_config_cuenta.jsp" class="sidebar-avatar-edit" title="Editar foto">
                <i class="bi bi-pencil"></i>
            </a>
        </div>
        <!-- Texto de Bienvenida y Nombre -->
        <p class="sidebar-user-welcome">¡Bienvenido(a)!</p>
        <p class="sidebar-user-name">${sessionScope.usuario.nombre != null ? sessionScope.usuario.nombre : 'Pedro Urieta'}</p>
    </div>

    <!-- Menú de Navegación -->
    <nav class="sidebar-menu-nav">
        <a href="${pageContext.request.contextPath}/views/admin/buscador.jsp" class="sidebar-item-link">
            Buscar
        </a>

        <a href="${pageContext.request.contextPath}/views/admin/bitacora.jsp" class="sidebar-item-link">
            Bitácora
        </a>

        <a href="${pageContext.request.contextPath}/views/admin/incidencias.jsp" class="sidebar-item-link">
            Incidencias
        </a>

        <a href="${pageContext.request.contextPath}/views/admin/crear_registro.jsp" class="sidebar-item-link">
            Registrar<br>nuevo usuario
        </a>

        <a href="${pageContext.request.contextPath}/views/admin/perfil_admin-docente.jsp" class="sidebar-item-link">
            Tu perfil
        </a>

        <a href="${pageContext.request.contextPath}/views/admin/admin-docente_config_cuenta.jsp" class="sidebar-item-link">
            Editar
        </a>
    </nav>

    <!-- Pie de página: Cerrar Sesión -->
    <div class="sidebar-footer-logout">
        <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout-link">
            <i class="bi bi-box-arrow-right"></i> Cerrar sesión
        </a>
    </div>
</aside>