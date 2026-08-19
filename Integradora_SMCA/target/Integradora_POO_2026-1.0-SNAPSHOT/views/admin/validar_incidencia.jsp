<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Validar Incidencias - UTEZ</title>

    <!-- Bootstrap 5 CSS y Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

    <!-- Hoja de Estilos Personalizada -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/validar_incidencia.css?v=6">

    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Validar Incidencias - UTEZ" />
</jsp:include>

<div class="main-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Banner Superior Azul -->
        <div class="validar-top-blue-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="validar-page-body">

            <!-- Encabezado: Enlace de regreso, Logo centrado y Etiqueta del Laboratorio -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <a href="${pageContext.request.contextPath}/views/admin/incidencias.jsp" class="back-link">
                    &larr; Pesta&ntilde;a anterior
                </a>

                <!-- SECCIÓN CENTRAL: LOGO + ETIQUETA DINÁMICA -->
                <div class="text-center">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo m-0">
                    <div class="mt-2">
                        <span class="badge px-3 py-2 fs-6 shadow-sm"
                              style="background-color: #1a365d; color: #ffffff; border-radius: 8px;">
                            Docencia / Laboratorio: ${not empty labActual ? labActual : 'CC2'}
                        </span>
                    </div>
                </div>

                <div style="width: 120px;"></div>
            </div>

            <!-- Tabla de Incidencias -->
            <div class="table-container table-responsive">
                <table class="table custom-table align-middle">
                    <thead>
                    <tr>
                        <th>Grado</th>
                        <th>Grupo</th>
                        <th>PC</th>
                        <th>Matr&iacute;cula</th>
                        <th>Nombre</th>
                        <th>Fecha</th>
                        <th>Incidencia</th>
                        <th>Validar</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%-- Obtiene la lista enviada por el Servlet --%>
                    <c:set var="itemsTabla" value="${not empty listaIncidencias ? listaIncidencias : incidencias}" />

                    <c:forEach var="inc" items="${itemsTabla}">
                        <tr>
                            <td>${not empty inc.grado ? inc.grado : 'N/A'}</td>
                            <td>${not empty inc.grupo ? inc.grupo : 'N/A'}</td>
                            <td>${not empty inc.numero_pc ? inc.numero_pc : inc.pc}</td>
                            <td>${not empty inc.matricula ? inc.matricula : 'N/A'}</td>
                            <td>${not empty inc.nombre_alumno ? inc.nombre_alumno : inc.nombre}</td>
                            <td>${not empty inc.fecha_reporte ? inc.fecha_reporte : inc.fecha}</td>
                            <td>${not empty inc.descripcion_falla ? inc.descripcion_falla : inc.incidencia}</td>
                            <td>
                                <button type="button"
                                        class="btn-validar-tabla"
                                        onclick="abrirModalPregunta('${not empty inc.id_reporte ? inc.id_reporte : inc.idReporte}')">
                                    Validar
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty itemsTabla}">
                        <tr>
                            <td colspan="8" class="text-muted py-4 text-center">
                                No hay incidencias registradas para revisar en este laboratorio.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

        </div>

    </main>
</div>

<!-- MODAL 1: ¿LA INCIDENCIA ES VERÍDICA? -->
<div class="modal fade" id="modalPregunta" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content text-center p-4">
            <div class="mb-3">
                <span class="icon-circle-question">?</span>
            </div>
            <h3 class="fw-bold text-secondary mb-4">&iquest;La incidencia es ver&iacute;dica?</h3>
            <div class="d-flex justify-content-center gap-3">
                <button type="button" class="btn-modal-save" onclick="mostrarFormularioDetalle()">
                    S&iacute;, validar
                </button>
                <form id="formDescartar" action="${pageContext.request.contextPath}/ValidarIncidenciasServlet" method="POST">
                    <input type="hidden" name="idReporte" id="idReporteDescartar">
                    <input type="hidden" name="accion" value="descartar">
                    <input type="hidden" name="lab" value="${labActual}">
                    <button type="submit" class="btn-modal-cancel">
                        No
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- MODAL 2: FORMULARIO DETALLE Y EVIDENCIA -->
<div class="modal fade" id="modalFormulario" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-4 text-center">
            <h4 class="fw-bold text-secondary mb-3">Validar incidencia</h4>

            <form action="${pageContext.request.contextPath}/ValidarIncidenciasServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="idReporte" id="idReporteValidar">
                <input type="hidden" name="accion" value="validar">
                <input type="hidden" name="lab" value="${labActual}">

                <div class="mb-3">
                    <textarea name="txtDescripcion" class="form-control rounded-3" rows="4" placeholder="Ingresa una breve descripción..."></textarea>
                </div>

                <div class="mb-4 upload-box">
                    <i class="bi bi-upload fs-2"></i>
                    <p class="m-0 fw-bold">Subir evidencia</p>
                    <small class="text-secondary">(opcional)</small>
                    <input type="file" name="fileEvidencia" class="form-control mt-2" accept="image/*">
                </div>

                <div class="d-flex justify-content-center gap-3">
                    <button type="submit" class="btn-modal-save">
                        Reportar
                    </button>
                    <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal">
                        Cancelar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let modalPreguntaBS = null;
    let modalFormularioBS = null;

    function abrirModalPregunta(idReporte) {
        document.getElementById('idReporteDescartar').value = idReporte;
        document.getElementById('idReporteValidar').value = idReporte;

        modalPreguntaBS = new bootstrap.Modal(document.getElementById('modalPregunta'));
        modalPreguntaBS.show();
    }

    function mostrarFormularioDetalle() {
        if (modalPreguntaBS) modalPreguntaBS.hide();
        modalFormularioBS = new bootstrap.Modal(document.getElementById('modalFormulario'));
        modalFormularioBS.show();
    }

    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('msj') === 'ok') {
            Swal.fire({
                title: '¡Incidencia procesada con éxito!',
                icon: 'success',
                confirmButtonText: 'Aceptar',
                confirmButtonColor: '#00875a',
                customClass: { popup: 'rounded-4' }
            }).then(() => {
                const lab = '${labActual}';
                window.location.href = '${pageContext.request.contextPath}/ValidarIncidenciasServlet?lab=' + encodeURIComponent(lab);
            });
        }
    });
</script>

<jsp:include page="/views/layout/footer.jsp" />
</body>
</html>