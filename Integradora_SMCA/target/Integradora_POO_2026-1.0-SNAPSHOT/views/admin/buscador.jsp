<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Buscador - Bitácora Digital" />
</jsp:include>

<!-- CSS del Buscador -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/buscar_exact.css?v=3">

<div class="main-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal (Desplazada 240px a la derecha) -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="search-top-blue-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <!-- Cuerpo del Buscador Centrado -->
        <div class="search-page-body">
            <div class="search-container">

                <!-- Logo UTEZ Centrado -->
                <div class="text-center mb-4">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="width: 200px; height: auto;">
                </div>

                <!-- Tarjeta / Píldora del Buscador -->
                <div class="search-card-pill">

                    <form action="BuscarServlet" method="GET" class="search-form-row">
                        <i class="bi bi-search search-icon-left me-3"></i>
                        <input type="text" name="txtBuscar" class="form-control search-input-field p-0" placeholder="¿Qué deseas buscar?" autocomplete="off">
                        <button type="submit" class="search-btn-submit ms-2">
                            <i class="bi bi-send-fill fs-5"></i>
                        </button>
                    </form>

                    <!-- Historial de Búsquedas -->
                    <div class="search-history-container">
                        <div class="search-history-item">
                            <i class="bi bi-clock me-3"></i> <span>20253ds101</span>
                        </div>
                        <div class="search-history-item">
                            <i class="bi bi-clock me-3"></i> <span>CC11 Docencia 4</span>
                        </div>
                        <div class="search-history-item">
                            <i class="bi bi-clock me-3"></i> <span>20253ds099</span>
                        </div>
                        <div class="search-history-item">
                            <i class="bi bi-clock me-3"></i> <span>20253ds089</span>
                        </div>
                        <div class="search-history-item">
                            <i class="bi bi-clock me-3"></i> <span>20253ds078</span>
                        </div>
                    </div>

                </div>

            </div>
        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />