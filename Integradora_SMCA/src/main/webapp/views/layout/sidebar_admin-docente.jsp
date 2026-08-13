<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar_exact.css?v=2">

<!-- CDN de SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- Recursos de alertas personalizadas -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/alertas.css">
<script src="${pageContext.request.contextPath}/assets/js/alertas.js" defer></script>

<style>
    /* Corrección de scroll e interacción para el sidebar */
    .figma-sidebar {
        height: 100vh !important;
        position: fixed !important;
        top: 0 !important;
        left: 0 !important;
        overflow-y: auto !important; /* Habilita el desplazamiento vertical */
        display: flex !important;
        flex-direction: column !important;
        justify-content: space-between !important;
        z-index: 1000 !important;
        box-sizing: border-box !important;
    }

    /* Estilo limpio para la barra de desplazamiento (Scrollbar) */
    .figma-sidebar::-webkit-scrollbar {
        width: 6px;
    }
    .figma-sidebar::-webkit-scrollbar-thumb {
        background-color: rgba(255, 255, 255, 0.25);
        border-radius: 4px;
    }
    .figma-sidebar::-webkit-scrollbar-track {
        background: transparent;
    }

    /* Padding inferior de seguridad para el botón de cerrar sesión */
    .sidebar-footer-logout {
        padding-bottom: 20px !important;
        margin-top: auto !important;
    }
</style>

<aside class="figma-sidebar">
    <div class="w-100">
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
                Nuevo<br>registro
            </a>

            <a href="${pageContext.request.contextPath}/views/admin/perfil_admin-docente.jsp" class="sidebar-item-link">
                Tu perfil
            </a>

            <a href="${pageContext.request.contextPath}/views/admin/admin-docente_config_cuenta.jsp" class="sidebar-item-link">
                Editar
            </a>
        </nav>
    </div>

    <!-- Pie de página: Cerrar Sesión con Alerta -->
    <div class="sidebar-footer-logout">
        <a href="javascript:void(0);"
           onclick="confirmarCierreSesion(event, '${pageContext.request.contextPath}/index.jsp')"
           class="sidebar-logout-link">
            <i class="bi bi-box-arrow-right"></i> Cerrar sesión
        </a>
    </div>
</aside>