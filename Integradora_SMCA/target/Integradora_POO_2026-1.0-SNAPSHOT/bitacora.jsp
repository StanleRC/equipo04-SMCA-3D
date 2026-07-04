<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Selección de Aula - Bitácora" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cssbitacorayinsidencias_Aulas.css">

<div class="main-wrapper">
    <jsp:include page="layout/sidebar.jsp" />

    <div class="flex-grow-1 d-flex flex-column" style="min-height: 100vh;">
        <div class="classroom-top-blue-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="classroom-page-body flex-grow-1">
            <div class="d-flex justify-content-between align-items-center mb-2">
                <a href="index.jsp" class="classroom-back-link">← Pestaña anterior</a>
                <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="UTEZ" style="max-height: 65px;">
                <div style="width: 100px;"></div>
            </div>

            <h3 class="text-center classroom-main-title">Bitacora de incidencias</h3>

            <div class="building-card">
                <h5 class="building-title">Docencia 1</h5>
                <div class="classrooms-grid">
                    <a href="#" class="btn-classroom-pill">CC1</a>
                    <a href="#" class="btn-classroom-pill">CC2</a>
                    <a href="#" class="btn-classroom-pill">CC3</a>
                </div>
            </div>

            <div class="building-card">
                <h5 class="building-title">Docencia 2</h5>
                <div class="classrooms-grid">
                    <a href="#" class="btn-classroom-pill">CC4</a>
                    <a href="#" class="btn-classroom-pill">CC5</a>
                </div>
            </div>

            <div class="building-card">
                <h5 class="building-title">Docencia 3</h5>
                <div class="classrooms-grid">
                    <a href="#" class="btn-classroom-pill">CC6</a>
                    <a href="#" class="btn-classroom-pill">CC7</a>
                    <a href="#" class="btn-classroom-pill">CC8</a>
                </div>
            </div>

            <div class="building-card">
                <h5 class="building-title">Docencia 4</h5>
                <div class="classrooms-grid">
                    <a href="#" class="btn-classroom-pill">CC9</a>
                    <a href="#" class="btn-classroom-pill">CC10</a>
                    <a href="#" class="btn-classroom-pill">CC11</a>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />