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

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Banner Superior Azul Marino -->
        <header class="top-header">
            <h1 class="top-title">Tu perfil</h1>
        </header>

        <!-- Cuerpo del Contenido -->
        <div class="content-body">

            <!-- Enlace de Regreso y Logo -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="javascript:history.back()" class="back-link">
                    ← Pestaña anterior
                </a>
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
                <div style="width: 120px;"></div>
            </div>

            <!-- Tarjeta Principal de Información Docente -->
            <div class="profile-card">

                <!-- Columna Izquierda: Avatar -->
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
                        <p class="user-fullname">
                            ${sessionScope.usuarioLogueado.nombre} ${sessionScope.usuarioLogueado.apellidos}
                        </p>
                        <span class="info-sublabel">Maestro</span>
                    </div>

                    <div class="info-group">
                        <p class="user-email font-monospace">
                            ${sessionScope.usuarioLogueado.correo}
                        </p>
                        <span class="info-sublabel">Correo</span>
                    </div>
                </div>

            </div>

        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />
