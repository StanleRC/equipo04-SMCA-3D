<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/sidebar_exact.css?v=6">

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/alertas.css">

<script src="${pageContext.request.contextPath}/assets/js/alertas.js"
        defer></script>

<%--
    El usuario puede estar en tres atributos distintos según por dónde entró.
    Se resuelve una sola vez aquí en lugar de repetir el c:choose en cada campo.
--%>
<c:set var="perfil" value="${not empty sessionScope.usuarioLogueado ? sessionScope.usuarioLogueado : (not empty sessionScope.docente ? sessionScope.docente : sessionScope.usuario)}" />
<c:set var="fotoSidebar" value="${not empty perfil.fotoPerfil ? perfil.fotoPerfil : 'default.png'}" />

<%--
    Mismo número que usa FiltroSoloAdmin.ROL_ADMIN. Si cambias uno, cambia el otro.
    Esto solo decide qué se DIBUJA; quien impide el acceso real es el filtro.
--%>
<c:set var="esAdmin" value="${sessionScope.esAdmin}" />

<aside class="figma-sidebar">

    <div class="sidebar-content">

        <div class="sidebar-profile-section">

            <div class="sidebar-avatar-wrapper">

                <%--
                    Aquí estaba el desajuste del avatar: este div traía width:100px y
                    height:100px en línea, pero el aro blanco mide 100px MENOS 3px de
                    borde y 2px de padding por lado. La foto quedaba 10px más grande
                    que su hueco y se montaba sobre el borde. El tamaño ahora lo
                    controla sidebar_exact.css con 100%.
                --%>
                <div class="sidebar-avatar-img">
                    <img src="${pageContext.request.contextPath}/assets/img/perfiles/${fotoSidebar}"
                         alt="Foto de perfil"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/perfiles/default.png';">
                </div>

                <a href="${pageContext.request.contextPath}/views/admin/perfil_admin-docente.jsp"
                   class="sidebar-avatar-edit"
                   title="Editar perfil">
                    <i class="bi bi-pencil-fill"></i>
                </a>

            </div>

            <p class="sidebar-user-welcome">
                ¡Bienvenido(a)!
            </p>

            <p class="sidebar-user-name">
                ${perfil.nombre} ${perfil.apellidoPaterno} ${perfil.apellidoMaterno}
            </p>

            <span class="sidebar-user-role">
                <c:choose>
                    <c:when test="${esAdmin}">Administrador</c:when>
                    <c:otherwise>Docente</c:otherwise>
                </c:choose>
            </span>

        </div>

        <nav class="sidebar-menu-nav">

            <%-- El buscador ahora entra por el servlet: si se abre el .jsp directo,
                 nadie llena listaAlumnos y la tabla sale vacía. --%>
            <a href="${pageContext.request.contextPath}/BuscarAlumnosServlet"
               class="sidebar-item-link">
                Buscar
            </a>
                <a href="${pageContext.request.contextPath}/views/admin/seleccionar_bitacora.jsp"
                    class="sidebar-item-link">
                   Bitácora
                </a>

            <a href="${pageContext.request.contextPath}/views/admin/incidencias.jsp"
               class="sidebar-item-link">
                Incidencias
            </a>

            <%--
                Alta de alumnos, maestros, grupos y salones: solo administrador.
                Al docente ni se le pinta la opción.
            --%>
            <c:if test="${esAdmin}">
                <a href="${pageContext.request.contextPath}/views/admin/crear_registro.jsp"
                   class="sidebar-item-link">
                    Nuevo<br>registro
                </a>
            </c:if>


            <%-- Se eliminó un <a></a> vacío que quedaba suelto al final del menú. --%>

        </nav>

    </div>

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

<%-- Aviso cuando alguien intentó entrar a una pantalla de admin escribiendo la URL. --%>
<c:if test="${param.acceso eq 'denegado'}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var mensaje = 'Esa sección es exclusiva del administrador.';
            if (typeof mostrarAlertaError === 'function') {
                mostrarAlertaError(mensaje);
            } else if (typeof Swal !== 'undefined') {
                Swal.fire({ icon: 'warning', title: 'Acceso restringido', text: mensaje });
            }
            if (window.history.replaceState) {
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        });
    </script>
</c:if>
