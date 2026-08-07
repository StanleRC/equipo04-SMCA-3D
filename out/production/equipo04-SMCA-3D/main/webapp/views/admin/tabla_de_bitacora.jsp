<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Header -->
<jsp:include page="/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Bitácora de Incidencias - UTEZ" />
</jsp:include>

<!-- CSS Personalizado -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bitacora_incidencias.css?v=1">

<div class="main-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- Área de Contenido Principal -->
    <main class="main-content">

        <!-- Barra Azul Superior -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="bitacora-container">
            <!-- Sub-encabezado: Botón Atrás + Logo + Avatar del usuario -->
            <div class="bitacora-header-row">
                <div class="header-left">
                    <a href="javascript:history.back()" class="btn-back">
                        <i class="bi bi-arrow-left"></i> Pestaña anterior
                    </a>
                </div>

                <div class="header-center">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
                    <h2 class="bitacora-title">Bitacora de incidencias</h2>
                </div>

                <div class="header-right">
                    <div class="user-avatar-badge">J</div>
                </div>
            </div>

            <!-- Botones de Filtro -->
            <div class="filter-actions-row">
                <button class="btn-filter">Fecha <i class="bi bi-funnel"></i></button>
                <button class="btn-filter">Hora <i class="bi bi-funnel"></i></button>
            </div>

            <!-- Tabla de Datos -->
            <div class="table-responsive custom-table-wrapper">
                <table class="table table-bordered custom-bitacora-table">
                    <thead>
                    <tr>
                        <th>Salón</th>
                        <th>PC</th>
                        <th>Matricula</th>
                        <th>Nombre</th>
                        <th>Fecha</th>
                        <th>Hora inicial</th>
                        <th>Hora final</th>
                        <th>Estado</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>CC 11</td>
                        <td>08</td>
                        <td>20253ds121</td>
                        <td class="text-start">Julian Perez Perez</td>
                        <td>12/06/2026</td>
                        <td>12:00</td>
                        <td>14:00</td>
                        <td>Validado</td>
                    </tr>
                    <tr>
                        <td>CC 11</td>
                        <td>07</td>
                        <td>20253ds041</td>
                        <td class="text-start">Luis Uriel Vargas Espino</td>
                        <td>12/06/2026</td>
                        <td>12:10</td>
                        <td>14:00</td>
                        <td>Pendiente</td>
                    </tr>
                    <tr>
                        <td>CC 10</td>
                        <td>12</td>
                        <td>20253ds089</td>
                        <td class="text-start">Brandon Valdez Lopez</td>
                        <td>12/06/2026</td>
                        <td>14:12</td>
                        <td>16:12</td>
                        <td>Descartado</td>
                    </tr>
                    <tr>
                        <td>CC 10</td>
                        <td>13</td>
                        <td>20253ds190</td>
                        <td class="text-start">Liliana Cabrera Martinez</td>
                        <td>12/06/2026</td>
                        <td>12:00</td>
                        <td>14:00</td>
                        <td>Pendiente</td>
                    </tr>
                    <tr>
                        <td>CC 10</td>
                        <td>07</td>
                        <td>20253ds121</td>
                        <td class="text-start">Sofia Martinez Sanchez</td>
                        <td>12/06/2026</td>
                        <td>12:00</td>
                        <td>14:00</td>
                        <td>Validado</td>
                    </tr>
                    <tr>
                        <td>CC 9</td>
                        <td>06</td>
                        <td>20253ds131</td>
                        <td class="text-start">Emilio Castañeda Flores</td>
                        <td>12/06/2026</td>
                        <td>12:00</td>
                        <td>14:00</td>
                        <td>Descartado</td>
                    </tr>
                    <!-- Filas vacías adicionales como en el diseño original -->
                    <tr><td>&nbsp;</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
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