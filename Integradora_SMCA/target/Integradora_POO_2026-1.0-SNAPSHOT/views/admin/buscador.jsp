<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    El URI de JSTL era http://java.sun.com/jsp/jstl/core, que es de JSTL 1.x (javax).
    Este proyecto usa jakarta.servlet, así que necesita JSTL 3.0 y el URI jakarta.tags.core.
    Con el viejo, Tomcat 10+ lanza "The absolute uri cannot be resolved" y la página ni compila.
--%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buscador de alumnos - UTEZ</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        * { box-sizing: border-box; }

        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100%;
            font-family: Arial, sans-serif;
        }

        .main-wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
        }

        .main-content {
            flex: 1;
            min-width: 0;
            background: #fff;
        }

        .top-welcome-bar {
            width: 100%;
            height: 47px;
            background-color: #1c3862;
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: bold;
        }

        .buscador-body {
            width: 100%;
            padding: 20px 30px;
        }

        .header-layout {
            position: relative;
            width: 100%;
            height: 45px;
            display: flex;
            align-items: center;
        }

        .btn-back {
            color: #000;
            font-size: 14px;
            font-weight: 600;
            text-decoration: underline;
        }

        .btn-back:hover { color: #1c3862; }

        .utez-logo-container {
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
        }

        .utez-logo {
            width: 170px;
            height: auto;
            display: block;
        }

        /* ---------- BUSCADOR ---------- */

        .search-container {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-top: 6px;
            margin-bottom: 14px;
        }

        .resultados-info {
            font-size: 13px;
            color: #666;
        }

        .search-form {
            position: relative;
            width: 280px;
            flex-shrink: 0;
        }

        .form-control-search {
            width: 100%;
            height: 37px;
            padding: 0 62px 0 15px;
            border: 1px solid #ccc;
            border-radius: 22px;
            font-size: 14px;
            outline: none;
        }

        .form-control-search:focus { border-color: #1c3862; }

        /* Antes era un <span> decorativo con una lupa: no hacía absolutamente nada
           al darle clic. Ahora es el botón que envía el formulario. */
        .search-btn,
        .clear-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 28px;
            height: 28px;
            border: none;
            background: none;
            border-radius: 50%;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .search-btn { right: 6px; color: #1c3862; }
        .search-btn:hover { background-color: #eef1f6; }

        .clear-btn { right: 34px; color: #999; }
        .clear-btn:hover { background-color: #f1f1f1; color: #444; }

        .aviso-linea {
            background: #fdf0d5;
            color: #8a6100;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 13px;
            margin-bottom: 12px;
        }

        /* ---------- TABLA ---------- */

        .custom-table-wrapper {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #1c3862;
        }

        .custom-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .custom-table thead { background-color: #1c3862; }

        .custom-table th {
            height: 49px;
            padding: 8px;
            background-color: #1c3862;
            color: #fff;
            border: 1px solid #31517d;
            font-size: 14px;
            font-weight: bold;
            text-align: center;
        }

        .custom-table td {
            height: 41px;
            padding: 8px;
            border: 1px solid #c8c8c8;
            font-size: 14px;
            vertical-align: middle;
            text-align: center;
        }

        .custom-table tbody tr:hover { background-color: #f4f6fa; }

        .text-left {
            text-align: left !important;
            padding-left: 12px !important;
        }

        /* Correos y nombres largos no deben romper el ancho de la tabla. */
        .celda-corta {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .sin-resultados {
            padding: 34px 12px !important;
            color: #777;
            font-size: 14px;
        }

        .btn-opciones {
            display: inline-block;
            padding: 5px 15px;
            background-color: #1c3862;
            color: #fff !important;
            border-radius: 15px;
            font-size: 12px;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn-opciones:hover { background-color: #12243e; }

        @media (max-width: 900px) {
            .buscador-body { padding: 20px; }
            .custom-table { min-width: 900px; }
            .search-container { flex-direction: column; align-items: stretch; }
            .search-form { width: 100%; }
        }
    </style>
</head>

<body>

<div class="main-wrapper">

    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="buscador-body">

            <div class="header-layout">
                <a href="javascript:history.back()" class="btn-back">
                    &larr; Pestaña anterior
                </a>

                <div class="utez-logo-container">
                    <img src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                         alt="Logo UTEZ"
                         class="utez-logo">
                </div>
            </div>

            <c:if test="${param.aviso eq 'noexiste'}">
                <div class="aviso-linea">
                    Esa matrícula ya no existe en el sistema.
                </div>
            </c:if>

            <div class="search-container">

                <div class="resultados-info">
                    <c:choose>
                        <c:when test="${not empty terminoBusqueda}">
                            Resultados para "<c:out value="${terminoBusqueda}" />":
                            <strong>${listaAlumnos.size()}</strong>
                        </c:when>
                        <c:otherwise>
                            Alumnos registrados: <strong>${listaAlumnos.size()}</strong>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%--
                    El input no estaba dentro de ningún <form>, así que escribir y
                    dar Enter no hacía nada. Ahora es un form GET real.
                --%>
                <form class="search-form" method="get"
                      action="${pageContext.request.contextPath}/BuscarAlumnosServlet">

                    <label for="inputBuscarAlumno" hidden>Buscar alumno</label>

                    <input type="text"
                           id="inputBuscarAlumno"
                           name="q"
                           value="<c:out value='${terminoBusqueda}' />"
                           placeholder="Nombre, matrícula, correo o grupo"
                           autocomplete="off"
                           class="form-control-search">

                    <c:if test="${not empty terminoBusqueda}">
                        <a href="${pageContext.request.contextPath}/BuscarAlumnosServlet"
                           class="clear-btn" title="Limpiar búsqueda" aria-label="Limpiar búsqueda">
                            <i class="bi bi-x-lg"></i>
                        </a>
                    </c:if>

                    <button type="submit" class="search-btn" aria-label="Buscar">
                        <i class="bi bi-search"></i>
                    </button>
                </form>

            </div>

            <div class="custom-table-wrapper">

                <table class="custom-table">

                    <thead>
                    <tr>
                        <th style="width: 14%;">Matrícula</th>
                        <th style="width: 22%;">Nombre</th>
                        <th style="width: 7%;">Grado</th>
                        <th style="width: 8%;">Grupo</th>
                        <th style="width: 17%;">Carrera</th>
                        <th style="width: 20%;">Correo</th>
                        <th style="width: 12%;">Acciones</th>
                    </tr>
                    </thead>

                    <tbody>

                    <c:choose>

                        <c:when test="${not empty listaAlumnos}">

                            <c:forEach var="alumno" items="${listaAlumnos}">
                                <tr>
                                    <td><strong>${alumno.matricula}</strong></td>

                                    <td class="text-left celda-corta" title="${alumno.nombreCompleto}">
                                            ${alumno.nombreCompleto}
                                    </td>

                                    <td>${alumno.grado}</td>

                                    <td>${alumno.grupo}</td>

                                    <td class="celda-corta" title="${alumno.carrera}">
                                            ${alumno.carrera}
                                    </td>

                                    <td class="text-left celda-corta" title="${alumno.correo}">
                                            ${alumno.correo}
                                    </td>

                                    <td>
                                            <%--
                                                El enlace original era perfil_alumno.jsp?id=${alumno.id}:
                                                ese archivo no existe en views/admin y la tabla alumno
                                                no tiene columna "id", su llave es la matrícula.
                                            --%>
                                        <a href="${pageContext.request.contextPath}/DetalleAlumnoServlet?matricula=${alumno.matricula}"
                                           class="btn-opciones">
                                            Ver historial
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                        </c:when>

                        <c:otherwise>
                            <%--
                                Antes se pintaban 6 filas vacías, que parecían un error de carga.
                                Un mensaje explícito dice qué está pasando.
                            --%>
                            <tr>
                                <td colspan="7" class="sin-resultados">
                                    <c:choose>
                                        <c:when test="${not empty terminoBusqueda}">
                                            No se encontró ningún alumno que coincida con
                                            "<c:out value="${terminoBusqueda}" />".
                                        </c:when>
                                        <c:otherwise>
                                            Todavía no hay alumnos registrados.
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:otherwise>

                    </c:choose>

                    </tbody>

                </table>

            </div>

        </div>

    </main>

</div>

<script>
    // El cursor arranca en el buscador, listo para escribir.
    (function () {
        var campo = document.getElementById('inputBuscarAlumno');
        if (!campo) return;

        campo.focus();
        campo.setSelectionRange(campo.value.length, campo.value.length);
    })();
</script>

</body>
</html>
