<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Cargar el CSS compartido antes del Header -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<!-- Header con Título -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Validar Incidencias - UTEZ" />
</jsp:include>

<div class="main-wrapper">
    <!-- Sidebar Admin / Docente -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <!-- Cuerpo de la Vista -->
        <div class="salones-body">

            <!-- Cabecera de 3 columnas: Alineación equilibrada (Sin 'M') -->
            <div class="salones-header-row">
                <div>
                    <a href="javascript:history.back()" class="btn-back">
                        ← Pestaña anterior
                    </a>
                </div>

                <div>
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
                </div>

                <!-- Bloque vacío compensador para centrar el logo -->
                <div></div>
            </div>

            <!-- Tarjeta Contenedora Principal (Gris) -->
            <div class="salones-card">

                <!-- SECCIÓN 1: CECADEC -->
                <div class="building-section">
                    <h3 class="building-title">CECADEC</h3>
                    <div class="buttons-grid">
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CC10" class="btn-salon">CC 10</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CC11" class="btn-salon">CC 11</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CC12" class="btn-salon">CC 12</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CC13" class="btn-salon">CC 13</a>
                    </div>
                </div>

                <!-- SECCIÓN 2: Docencia 4 -->
                <div class="building-section">
                    <h3 class="building-title">Docencia 4</h3>
                    <div class="buttons-grid">
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CA1" class="btn-salon">CA 1</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CA2" class="btn-salon">CA 2</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CA3" class="btn-salon">CA 3</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CA4" class="btn-salon">CA 4</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CA6" class="btn-salon">CA 6</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CA5" class="btn-salon">CA 5</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CA11" class="btn-salon">CA 11</a>
                    </div>
                </div>

                <!-- SECCIÓN 3: CEDIM -->
                <div class="building-section">
                    <h3 class="building-title">CEDIM</h3>
                    <div class="buttons-grid">
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CC1" class="btn-salon">CC 1</a>
                        <a href="${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=CC2" class="btn-salon">CC 2</a>
                    </div>
                </div>

            </div> <!-- /salones-card -->

        </div> <!-- /salones-body -->

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />