<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Buscador - Bitácora Digital" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/buscar_exact.css">

<div class="main-wrapper">
    <jsp:include page="layout/sidebar.jsp" />

    <div class="flex-grow-1 d-flex flex-column" style="min-height: 100vh;">

        <div class="search-top-blue-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="search-page-body flex-grow-1 d-flex align-items-center justify-content-center">
            <div class="container text-center" style="margin-top: -60px;">

                <div class="mb-5">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 90px;" class="img-fluid">
                </div>

                <div class="search-card-pill text-start">

                    <form action="BuscarServlet" method="GET" class="search-form-row">
                        <i class="bi bi-search search-icon-left me-3"></i>
                        <input type="text" name="txtBuscar" class="form-control search-input-field p-0" placeholder="¿Qué deseas buscar?" autocomplete="off">
                        <button type="submit" class="search-btn-submit ms-2">
                            <i class="bi bi-send-fill fs-5"></i>
                        </button>
                    </form>

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
    </div>
</div>

<jsp:include page="layout/footer.jsp" />