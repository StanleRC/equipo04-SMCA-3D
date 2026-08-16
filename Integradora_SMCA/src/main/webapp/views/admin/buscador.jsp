<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Buscador - UTEZ</title>

    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            min-height: 100%;
            font-family: Arial, sans-serif;
        }

        /* CONTENEDOR GENERAL */
        .main-wrapper {
            display: flex;
            width: 100%;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        /* CONTENIDO */
        .main-content {
            flex: 1;
            min-width: 0;
            background: white;
            margin: 0;
            padding: 0;
        }

        /* BARRA AZUL */
        .top-welcome-bar {
            width: 100%;
            height: 47px;
            background-color: #1c3862;
            color: white;

            display: flex;
            justify-content: center;
            align-items: center;

            font-size: 16px;
            font-weight: bold;
        }

        /* CUERPO */
        .buscador-body {
            width: 100%;
            padding: 20px 30px;
        }

        /* PARTE SUPERIOR */
        .header-layout {
            position: relative;
            width: 100%;
            height: 45px;

            display: flex;
            align-items: center;
        }

        /* BOTÓN ATRÁS */
        .btn-back {
            color: #000;
            font-size: 14px;
            font-weight: 600;
            text-decoration: underline;
        }

        .btn-back:hover {
            color: #1c3862;
        }

        /* LOGO */
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

        /* BUSCADOR */
        .search-container {
            width: 100%;
            display: flex;
            justify-content: flex-end;
            margin-top: 2px;
            margin-bottom: 14px;
        }

        .search-input-box {
            position: relative;
            width: 248px;
        }

        .form-control-search {
            width: 100%;
            height: 37px;

            padding: 0 38px 0 15px;

            border: 1px solid #ccc;
            border-radius: 22px;

            font-size: 14px;
            outline: none;
        }

        .form-control-search:focus {
            border-color: #1c3862;
        }

        .search-icon {
            position: absolute;
            right: 13px;
            top: 50%;

            transform: translateY(-50%);

            font-size: 14px;
            cursor: pointer;
        }

        /* TABLA */
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

        /* ENCABEZADO */
        .custom-table thead {
            background-color: #1c3862;
        }

        .custom-table th {
            height: 49px;

            padding: 8px;

            background-color: #1c3862;
            color: white;

            border: 1px solid #31517d;

            font-size: 14px;
            font-weight: bold;
            text-align: center;
        }

        /* CELDAS */
        .custom-table td {
            height: 41px;

            padding: 8px;

            border: 1px solid #c8c8c8;

            font-size: 14px;
            vertical-align: middle;
        }

        .text-center {
            text-align: center;
        }

        .text-left {
            text-align: left;
            padding-left: 12px !important;
        }

        /* BOTÓN OPCIONES */
        .btn-opciones {
            display: inline-block;

            padding: 5px 15px;

            background-color: #1c3862;
            color: white !important;

            border-radius: 15px;

            font-size: 12px;
            text-decoration: none;
        }

        .btn-opciones:hover {
            background-color: #12243e;
        }

        /* RESPONSIVO */
        @media (max-width: 900px) {

            .buscador-body {
                padding: 20px;
            }

            .custom-table {
                min-width: 850px;
            }
        }
    </style>
</head>

<body>

<div class="main-wrapper">

    <!-- SIDEBAR -->
    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <!-- CONTENIDO -->
    <main class="main-content">

        <!-- BARRA SUPERIOR -->
        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="buscador-body">

            <!-- ATRÁS + LOGO -->
            <div class="header-layout">

                <a href="javascript:history.back()" class="btn-back">
                    &larr; Pestaña anterior
                </a>

                <div class="utez-logo-container">
                    <img
                            src="${pageContext.request.contextPath}/assets/img/logoutez.png"
                            alt="Logo UTEZ"
                            class="utez-logo">
                </div>

            </div>

            <!-- BUSCADOR -->
            <div class="search-container">

                <div class="search-input-box">

                    <input
                            type="text"
                            id="inputBuscarAlumno"
                            placeholder="Buscar alumno..."
                            class="form-control-search">

                    <span class="search-icon">🔍</span>

                </div>

            </div>

            <!-- TABLA -->
            <div class="custom-table-wrapper">

                <table class="custom-table">

                    <thead>
                    <tr>
                        <th style="width: 6%;">ID</th>
                        <th style="width: 25%;">Nombre</th>
                        <th style="width: 15%;">Matrícula</th>
                        <th style="width: 8%;">Grado</th>
                        <th style="width: 8%;">Grupo</th>
                        <th style="width: 22%;">Correo</th>
                        <th style="width: 16%;">Acciones</th>
                    </tr>
                    </thead>

                    <tbody id="tablaAlumnosBody">

                    <c:choose>

                        <c:when test="${not empty listaAlumnos}">

                            <c:forEach var="alumno" items="${listaAlumnos}">

                                <tr>

                                    <td class="text-center">
                                            ${alumno.id}
                                    </td>

                                    <td class="text-left">
                                            ${alumno.nombre}
                                            ${alumno.apellidoPaterno}
                                            ${alumno.apellidoMaterno}
                                    </td>

                                    <td class="text-center">
                                            ${alumno.matricula}
                                    </td>

                                    <td class="text-center">
                                            ${alumno.grado}
                                    </td>

                                    <td class="text-center">
                                            ${alumno.grupo}
                                    </td>

                                    <td class="text-left">
                                            ${alumno.correo}
                                    </td>

                                    <td class="text-center">

                                        <a
                                                href="${pageContext.request.contextPath}/views/admin/perfil_alumno.jsp?id=${alumno.id}"
                                                class="btn-opciones">
                                            Opciones
                                        </a>

                                    </td>

                                </tr>

                            </c:forEach>

                        </c:when>

                        <c:otherwise>

                            <c:forEach begin="1" end="6">

                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>

                            </c:forEach>

                        </c:otherwise>

                    </c:choose>

                    </tbody>

                </table>

            </div>

        </div>

    </main>

</div>

</body>
</html>