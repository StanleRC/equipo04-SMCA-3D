<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Agregar otro salón - UTEZ" />
</jsp:include>

<!-- CSS Agregar Salón -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/agregar_salon.css?v=1">

<div class="main-wrapper">
    <!-- Sidebar Admin -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="content-body">

            <!-- Fila Superior: Botón Atrás separado del margen + Logo UTEZ Centrado -->
            <div class="position-relative mb-4" style="min-height: 80px;">
                <div class="position-absolute start-0 top-50 translate-middle-y ms-4">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="bi bi-arrow-left"></i> <u>Pestaña anterior</u>
                    </a>
                </div>
                <div class="text-center">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" style="width: 200px; height: auto;">
                </div>
            </div>

            <!-- Tarjeta Gris Redondeada Centrada -->
            <div class="d-flex justify-content-center">
                <div class="agregar-card">
                    <h3 class="agregar-card-title text-center">Agregar otro salón</h3>

                    <form action="AgregarSalonServlet" method="POST">

                        <!-- Campo Docencia -->
                        <div class="form-group mb-4">
                            <label for="inputDocencia" class="form-label custom-label">Docencia</label>
                            <input
                                    type="text"
                                    id="inputDocencia"
                                    name="txtDocencia"
                                    class="form-control custom-input"
                                    placeholder="Docencia"
                                    required>
                        </div>

                        <!-- Campo Salón -->
                        <div class="form-group mb-4">
                            <label for="inputSalon" class="form-label custom-label">Salón</label>
                            <input
                                    type="text"
                                    id="inputSalon"
                                    name="txtSalon"
                                    class="form-control custom-input"
                                    placeholder="Salón"
                                    required>
                        </div>

                        <!-- Botones de Acción -->
                        <div class="d-flex justify-content-center gap-3 mt-4">
                            <a href="javascript:history.back()" class="btn-action btn-cancelar text-decoration-none text-center">Cancelar</a>
                            <button type="submit" class="btn-action btn-agregar">Agregar</button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />