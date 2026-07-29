<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sidebar_alumno.css">

<aside class="figma-sidebar">
    <div class="d-flex flex-column w-100">

        <!-- Perfil del Alumno -->
        <div class="sidebar-profile-section">
            <div class="sidebar-avatar-wrapper">
                <div class="sidebar-avatar-img">
                    <i class="bi bi-person-fill"></i>
                </div>
                <a href="${pageContext.request.contextPath}/WEB-INF/views/alumno/editar_perfil.jsp" class="sidebar-avatar-edit" title="Editar perfil">
                    <i class="bi bi-pencil-fill"></i>
                </a>
            </div>
            <div class="sidebar-user-welcome">¡Bienvenido(a)!</div>
            <h3 class="sidebar-user-name">Julian Perez Perez</h3>
        </div>

        <!-- Menú de Navegación del Alumno -->
        <nav class="sidebar-menu-nav">
            <!-- Usa la clase 'active' para destacar la vista actual -->
            <a href="${pageContext.request.contextPath}/WEB-INF/views/alumno/tu_perfil.jsp" class="sidebar-item-link active">
                <span>Tu perfil</span>
                <i class="bi bi-arrow-right"></i>
            </a>

            <a href="${pageContext.request.contextPath}/WEB-INF/views/alumno/editar.jsp" class="sidebar-item-link">
                <span>Editar</span>
                <i class="bi bi-arrow-right"></i>
            </a>

            <a href="${pageContext.request.contextPath}/WEB-INF/views/alumno/historial.jsp" class="sidebar-item-link">
                <span>Historial</span>
                <i class="bi bi-arrow-right"></i>
            </a>
        </nav>
    </div>

    <!-- Botón Cerrar Sesión -->
    <div class="sidebar-footer-logout">
        <a href="${pageContext.request.contextPath}/index.jsp" class="sidebar-logout-link">
            <i class="bi bi-box-arrow-left"></i> Cerrar sesión
        </a>
    </div>
</aside>