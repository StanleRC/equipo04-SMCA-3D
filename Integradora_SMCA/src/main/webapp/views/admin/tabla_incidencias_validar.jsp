<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Tabla de Incidencias (Validación) - UTEZ" />
</jsp:include>

<!-- CSS de Incidencias Validación -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/incidencias_validar.css?v=1">

<div class="main-wrapper">
    <!-- Sidebar Admin -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="incidencias-container">
            <!-- Encabezado con Botón Atrás + Logo UTEZ + Badge Usuario -->
            <div class="incidencias-header-row">
                <div class="header-left">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="bi bi-arrow-left"></i> Pestaña anterior
                    </a>
                </div>

                <div class="header-center">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
                </div>

                <div class="header-right">
                    <div class="user-avatar-badge">M</div>
                </div>
            </div>

            <!-- Título de Salón / Edificio -->
            <h2 class="incidencias-subtitle">Ingresaste a Docencia X CCX</h2>

            <!-- Tabla de Validación de Incidencias -->
            <div class="table-responsive custom-table-wrapper">
                <table class="table table-bordered custom-incidencias-table">
                    <thead>
                    <tr>
                        <th>Grado</th>
                        <th>Grupo</th>
                        <th>PC</th>
                        <th>Matrícula</th>
                        <th>Nombre</th>
                        <th>Fecha</th>
                        <th>Incidencia</th>
                        <th>Validar</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>3</td>
                        <td>D</td>
                        <td>08</td>
                        <td>20253ds121</td>
                        <td class="text-start">Julian Perez Perez</td>
                        <td>12/06/2026</td>
                        <td class="text-start">Manchas en la pantalla</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/views/admin/validar_incidencia.jsp?id=1" class="btn-validar">Validar</a>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>D</td>
                        <td>07</td>
                        <td>20253ds041</td>
                        <td class="text-start">Luis Uriel Vargas Espino</td>
                        <td>12/06/2026</td>
                        <td class="text-start">El teclado no sirve</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/views/admin/validar_incidencia.jsp?id=2" class="btn-validar">Validar</a>
                        </td>
                    </tr>
                    <tr>
                        <td>6</td>
                        <td>E</td>
                        <td>12</td>
                        <td>20253ds089</td>
                        <td class="text-start">Brandon Valdez Lopez</td>
                        <td>12/06/2026</td>
                        <td class="text-start">No prende el monitor</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/views/admin/validar_incidencia.jsp?id=3" class="btn-validar">Validar</a>
                        </td>
                    </tr>
                    <tr>
                        <td>9</td>
                        <td>A</td>
                        <td>13</td>
                        <td>20253ds190</td>
                        <td class="text-start">Liliana Cabrera Martinez</td>
                        <td>12/06/2026</td>
                        <td class="text-start">Ninguna</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/views/admin/validar_incidencia.jsp?id=4" class="btn-validar">Validar</a>
                        </td>
                    </tr>
                    <tr>
                        <td>6</td>
                        <td>E</td>
                        <td>07</td>
                        <td>20253ds121</td>
                        <td class="text-start">Sofia Martinez Sanchez</td>
                        <td>12/06/2026</td>
                        <td class="text-start">Manchas en la pantalla</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/views/admin/validar_incidencia.jsp?id=5" class="btn-validar">Validar</a>
                        </td>
                    </tr>
                    <tr>
                        <td>9</td>
                        <td>B</td>
                        <td>06</td>
                        <td>20253ds131</td>
                        <td class="text-start">Emilio Castañeda Flores</td>
                        <td>12/06/2026</td>
                        <td class="text-start">Manchas en la pantalla</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/views/admin/validar_incidencia.jsp?id=6" class="btn-validar">Validar</a>
                        </td>
                    </tr>
                    <!-- Filas vacías adicionales -->
                    <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                    <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                    <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

<!-- Footer -->
<jsp:include page="/views/layout/footer.jsp" />