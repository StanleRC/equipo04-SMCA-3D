<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Tu Perfil - Bitácora Digital" />
</jsp:include>

<!-- CSS del Perfil -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/perfil_docente.css?v=3">

<div class="main-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal (Desplazada 240px a la derecha) -->
    <main class="main-content">

        <!-- Banner Superior Azul Marino -->
        <header class="top-header">
            <h1 class="top-title">Tu perfil</h1>
        </header>

        <!-- Cuerpo del Contenido -->
        <div class="content-body">

            <!-- Fila Superior: Botón Atrás separado del margen + Logo UTEZ Centrado -->
            <div class="position-relative mb-4" style="min-height: 80px;">
                <div class="position-absolute start-0 top-50 translate-middle-y ms-4">
                    <a href="javascript:history.back()" class="back-link">
                        <i class="bi bi-arrow-left"></i> <u>Pestaña anterior</u>
                    </a>
                </div>
                <div class="text-center">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="width: 200px; height: auto;">
                </div>
            </div>

            <!-- Tarjeta Principal de Información Docente -->
            <div class="profile-card">

                <!-- Columna Izquierda: Avatar Gris -->
                <div class="profile-card-left">
                    <div class="large-avatar-circle">
                        <i class="bi bi-person-fill"></i>
                    </div>
                </div>

                <!-- Columna Derecha: Información del Docente -->
                <div class="profile-card-right">
                    <h2 class="section-title">Información docente</h2>

                    <h3 class="area-title">Área: DATID</h3>

                    <div class="info-group mb-3">
                        <p class="user-fullname">${sessionScope.usuario.nombre != null ? sessionScope.usuario.nombre : 'Ing. Pedro Urieta'}</p>
                        <span class="info-sublabel">Maestro</span>
                    </div>

                    <div class="info-group">
                        <p class="user-email">${sessionScope.usuario.correo != null ? sessionScope.usuario.correo : 'PedroUrieta@utez.edu.mx'}</p>
                        <span class="info-sublabel">Correo</span>
                    </div>
                </div>

            </div>

        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />