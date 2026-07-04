<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar_exact.css">

<aside class="figma-sidebar">
    <div class="d-flex flex-column w-100">

        <div class="sidebar-profile-section">
            <div class="sidebar-avatar-wrapper">
                <div class="sidebar-avatar-img">
                    <i class="bi bi-person-fill"></i>
                </div>
                <div class="sidebar-avatar-edit">
                    <i class="bi bi-pencil-fill"></i>
                </div>
            </div>
            <p class="text-white-50 small m-0" style="font-size: 13px;">¡Bienvenido(a)!</p>
            <h3 class="sidebar-user-text">Pedro Urieta</h3>
        </div>

        <nav class="sidebar-menu-nav">
            <a href="${pageContext.request.contextPath}/buscador.jsp" class="sidebar-item-link">
                <span>Buscar</span>
            </a>

            <a href="${pageContext.request.contextPath}/bitacora.jsp" class="sidebar-item-link">
                <span>Bitácora</span>
            </a>

            <a href="${pageContext.request.contextPath}/incidencias.jsp" class="sidebar-item-link">
                <span>Incidencias</span>
            </a>

            <a href="${pageContext.request.contextPath}/crear_registro.jsp" class="sidebar-item-link active-view">
                <span>Registrar nuevo usuario</span>
                <i class="bi bi-arrow-right fs-5 text-white"></i>
            </a>
        </nav>
    </div>

    <div class="sidebar-footer-logout">
        <a href="${pageContext.request.contextPath}/login.jsp" class="sidebar-logout-link">
            <i class="bi bi-box-arrow-left me-3 fs-5"></i> Cerrar sesión
        </a>
    </div>
</aside>