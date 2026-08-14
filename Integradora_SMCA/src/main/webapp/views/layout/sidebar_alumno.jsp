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

        <!-- PERFIL DEL ALUMNO -->
        <div class="sidebar-profile-section">

            <div class="sidebar-avatar-wrapper">

                <!-- Foto del alumno -->
                <div class="sidebar-avatar-img">

                    <img
                            src="${not empty sessionScope.usuarioFoto
                            ? pageContext.request.contextPath.concat(sessionScope.usuarioFoto)
                            : pageContext.request.contextPath.concat('/assets/img/default_profile.png')}"
                            alt="Foto de perfil">

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

                ${sessionScope.usuarioLogueado.nombre}
                ${sessionScope.usuarioLogueado.apellidos}

            </p>

        </div>


        <!-- ==========================================
             MENÚ DEL ALUMNO
             ========================================== -->
        <nav class="sidebar-menu-nav">

            <a href="${pageContext.request.contextPath}/views/alumno/perfil_alumno.jsp"
               class="sidebar-item-link">

                <span>Tu perfil</span>


            </a>


            <a href="${pageContext.request.contextPath}/views/alumno/historial_alumno.jsp"
               class="sidebar-item-link">

                <span>Historial</span>


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
                   '${pageContext.request.contextPath}/logoutServlet'
                   )"
           class="sidebar-logout-link">

            <i class="bi bi-box-arrow-left"></i>
            Cerrar sesión

        </a>

    </div>

</aside>