<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="layout/header.jsp">
    <jsp:param name="pageTitle" value="Panel de Pruebas - Bitácora Digital" />
</jsp:include>

<div class="main-wrapper">
    <jsp:include page="layout/sidebar.jsp" />

    <div class="flex-grow-1 d-flex flex-column" style="background-color: #fafafa; min-height: 100vh;">

        <div class="top-blue-bar">
            ¡Bienvenido(a)!, Entorno de Pruebas de Desarrollo
        </div>

        <div class="content-body flex-grow-1 d-flex align-items-center justify-content-center">
            <div class="container text-center" style="max-width: 700px;">

                <div class="mb-4">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="max-height: 90px;" class="img-fluid">
                </div>

                <h3 class="fw-bold mb-2" style="color: #00876c;">Menú de Ruta de Archivos</h3>
                <p class="text-muted mb-5">Usa este panel para dar clic y verificar cómo van quedando tus nuevas pantallas JSP.</p>

                <div class="card border-0 shadow-sm p-4 text-start" style="border-radius: 16px; background-color: #ffffff;">
                    <h5 class="fw-semibold mb-3 text-secondary">Módulos Solicitados:</h5>

                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/buscador.jsp" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3">
                            <div>
                                <i class="bi bi-search text-success me-3 fs-5"></i>
                                <span class="fw-medium">1. Pantalla de Buscador</span>
                                <div class="text-muted small ps-5">`buscador.jsp` - Barra e historial de búsquedas</div>
                            </div>
                            <span class="badge bg-secondary rounded-pill">Probar</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/bitacora.jsp" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3">
                            <div>
                                <i class="bi bi-table text-primary me-3 fs-5"></i>
                                <span class="fw-medium">2. Tabla de Bitácora General</span>
                                <div class="text-muted small ps-5">`bitacora.jsp` - Historial de registros con filtros</div>
                            </div>
                            <span class="badge bg-secondary rounded-pill">Probar</span>
                        </a>

                        <a href="${pageContext.request.contextPath}/incidencias.jsp" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3">
                            <div>
                                <i class="bi bi-check-circle-fill text-danger me-3 fs-5"></i>
                                <span class="fw-medium">3. Validación de Incidencias</span>
                                <div class="text-muted small ps-5">`incidencias.jsp` - Reportes por aula y botones de validar</div>
                            </div>
                            <span class="badge bg-secondary rounded-pill">Probar</span>
                        </a>
                    </div>
                </div>

                <div class="mt-4 text-muted small">
                    Ubicación del archivo actual: <code class="bg-light p-1 rounded">src/main/webapp/index.jsp</code>
                </div>

            </div>
        </div>
    </div>
</div>

<jsp:include page="layout/footer.jsp" />