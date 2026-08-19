<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacora_insidencias_Aulas.css?v=12">

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Seleccionar Laboratorio - UTEZ" />
</jsp:include>

<div class="main-wrapper">
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="salones-body">

            <div class="salones-header-row">
                <div>
                    <a href="javascript:history.back()" class="btn-back">
                        ← Pestaña anterior
                    </a>
                </div>

                <div>
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
                </div>

                <div></div>
            </div>

            <div class="salones-card">

                <!-- CECADEC -->
                <div class="building-section">
                    <h3 class="building-title">CECADEC</h3>
                    <div class="buttons-grid">
                        <!-- OJO: Cambia "BitacoraServlet" por el nombre real de tu Servlet que consulta la bitácora -->
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CC10" class="btn-salon">CC 10</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CC11" class="btn-salon">CC 11</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CC12" class="btn-salon">CC 12</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CC13" class="btn-salon">CC 13</a>
                    </div>
                </div>

                <!-- Docencia 4 -->
                <div class="building-section">
                    <h3 class="building-title">Docencia 4</h3>
                    <div class="buttons-grid">
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CA1" class="btn-salon">CA 1</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CA2" class="btn-salon">CA 2</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CA3" class="btn-salon">CA 3</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CA4" class="btn-salon">CA 4</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CA5" class="btn-salon">CA 5</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CA6" class="btn-salon">CA 6</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CA11" class="btn-salon">CA 11</a>
                    </div>
                </div>

                <!-- CEDIM -->
                <div class="building-section">
                    <h3 class="building-title">CEDIM</h3>
                    <div class="buttons-grid">
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CC1" class="btn-salon">CC 1</a>
                        <a href="${pageContext.request.contextPath}/BitacoraServlet?lab=CC2" class="btn-salon">CC 2</a>
                    </div>
                </div>

            </div>

        </div>

    </main>
</div>

<jsp:include page="/views/layout/footer.jsp" />