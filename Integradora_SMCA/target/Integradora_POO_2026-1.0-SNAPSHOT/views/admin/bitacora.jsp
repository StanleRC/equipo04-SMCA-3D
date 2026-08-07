<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Cargar el CSS compartido antes del Header -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<!-- Header para el Título -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Agregar Salón - UTEZ" />
</jsp:include>

<div class="main-wrapper">
    <!-- Sidebar para administradores -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <!-- Cuerpo de la Vista -->
        <div class="salones-body">

            <!-- Cabezera -->
            <div class="salones-header-row">
                <div>
                    <a href="javascript:history.back()" class="btn-back">
                        ← Pestaña anterior
                    </a>
                </div>

                <div>
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
                </div>

                <!-- Bloque vacío para mantener el equilibrio y centrar el logo -->
                <div></div>
            </div>

            <!-- Tarjeta Contenedora Principal-->
            <div class="salones-card">

                <!-- SECCIÓN 1: CECADEC -->
                <div class="building-section">
                    <h3 class="building-title">CECADEC</h3>
                    <div class="buttons-grid">
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CC10" class="btn-salon">CC 10</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CC11" class="btn-salon">CC 11</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CC12" class="btn-salon">CC 12</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CC13" class="btn-salon">CC 13</a>
                    </div>
                </div>

                <!-- SECCIÓN 2: Docencia 4 -->
                <div class="building-section">
                    <h3 class="building-title">Docencia 4</h3>
                    <div class="buttons-grid">
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CA1" class="btn-salon">CA 1</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CA2" class="btn-salon">CA 2</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CA3" class="btn-salon">CA 3</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CA4" class="btn-salon">CA 4</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CA6" class="btn-salon">CA 6</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CA6_2" class="btn-salon">CA 6</a>
                        <a href="${pageContext.request.contextPath}/views/admin/tabla_de_bitacora.jsp?lab=CA11" class="btn-salon">CA 11</a>
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

                <div class="card-footer-link">
                    <a href="${pageContext.request.contextPath}/views/admin/agregar_salon.jsp" class="link-add-room">
                        ¿Desea agregar otro salón?
                    </a>
                </div>

            </div> <!-- /card de los salones-->

        </div> <!-- /body de los salones -->

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />