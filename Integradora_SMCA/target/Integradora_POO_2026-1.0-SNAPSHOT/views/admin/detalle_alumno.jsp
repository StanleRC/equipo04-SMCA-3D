<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de ${alumnoDetalle.nombre} - UTEZ</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        * { box-sizing: border-box; }

        html, body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: Arial, sans-serif;
        }

        .main-wrapper { display: flex; min-height: 100vh; }

        .main-content { flex: 1; min-width: 0; background: #fff; }

        .top-welcome-bar {
            height: 47px;
            background-color: #1c3862;
            color: #fff;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: bold;
        }

        .cuerpo { padding: 20px 30px; }

        .btn-back {
            color: #000;
            font-size: 14px;
            font-weight: 600;
            text-decoration: underline;
        }

        .btn-back:hover { color: #1c3862; }

        /* ---------- FICHA DEL ALUMNO ---------- */

        .ficha {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
            background: #f7f8fa;
            border: 1px solid #e2e6ee;
            border-radius: 14px;
            padding: 18px 22px;
            margin: 16px 0 20px;
        }

        .ficha-avatar {
            width: 78px;
            height: 78px;
            border-radius: 50%;
            overflow: hidden;
            background: #dfe3ea;
            flex-shrink: 0;
        }

        .ficha-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .ficha-datos { flex: 1; min-width: 220px; }

        .ficha-nombre {
            font-size: 19px;
            font-weight: 700;
            color: #1c3862;
            margin: 0 0 4px;
        }

        .ficha-linea {
            font-size: 13px;
            color: #5a6b85;
            margin: 0;
        }

        .ficha-chips {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 10px;
        }

        .chip {
            background: #e8edf6;
            color: #1c3862;
            border-radius: 999px;
            padding: 4px 12px;
            font-size: 12px;
            font-weight: 700;
        }

        /* ---------- TABLA ---------- */

        .tabla-wrapper {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #1c3862;
        }

        .tabla-datos {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
            min-width: 950px;
        }

        .tabla-datos th {
            height: 50px;
            padding: 8px;
            background-color: #1c3862;
            color: #fff;
            border: 1px solid #31517d;
            font-size: 14px;
            font-weight: 700;
            text-align: center;
        }

        .tabla-datos td {
            height: 41px;
            padding: 8px;
            border: 1px solid #c8c8c8;
            font-size: 14px;
            text-align: center;
            vertical-align: middle;
        }

        .tabla-datos td.al-inicio {
            text-align: left;
            padding-left: 12px;
        }

        .tabla-datos tbody tr:hover { background-color: #f4f6fa; }

        .badge-estado {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .badge-validado   { background: #dcf3e6; color: #1e7e4a; }
        .badge-pendiente  { background: #fdf0d5; color: #8a6100; }
        .badge-descartado { background: #f1f1f1; color: #6b6b6b; }
        .badge-sinreporte { background: #eef1f6; color: #5a6b85; }

        .sin-datos { padding: 34px 12px !important; color: #777; }

        .encabezado-tabla {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 10px;
        }

        .titulo-seccion {
            font-size: 18px;
            font-weight: 700;
            color: #1c3862;
            margin: 0;
        }

        .contador { font-size: 13px; color: #666; }
    </style>
</head>

<body>

<div class="main-wrapper">

    <jsp:include page="/views/layout/sidebar_admin-docente.jsp" />

    <main class="main-content">

        <div class="top-welcome-bar">
            ¡Bienvenido(a)!, Ingresaste como administrador
        </div>

        <div class="cuerpo">

            <a href="${pageContext.request.contextPath}/BuscarAlumnosServlet" class="btn-back">
                &larr; Volver al buscador
            </a>

            <div class="ficha">
                <div class="ficha-avatar">
                    <img src="${pageContext.request.contextPath}/assets/img/perfiles/${not empty alumnoDetalle.fotoPerfil ? alumnoDetalle.fotoPerfil : 'default.png'}"
                         alt="Foto de perfil"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/img/perfiles/default.png';">
                </div>

                <div class="ficha-datos">
                    <h2 class="ficha-nombre">
                        ${alumnoDetalle.nombre} ${alumnoDetalle.apellidoPaterno} ${alumnoDetalle.apellidoMaterno}
                    </h2>

                    <p class="ficha-linea">${alumnoDetalle.correo}</p>

                    <div class="ficha-chips">
                        <span class="chip">Matrícula: ${alumnoDetalle.matricula}</span>
                        <span class="chip">Grupo: ${alumnoDetalle.grupoIdGrupo}</span>
                    </div>
                </div>
            </div>

            <div class="encabezado-tabla">
                <h3 class="titulo-seccion">Historial de uso e incidencias</h3>
                <span class="contador">
                    ${listaHistorial.size()} registro<c:if test="${listaHistorial.size() ne 1}">s</c:if>
                </span>
            </div>

            <div class="tabla-wrapper">
                <table class="tabla-datos">
                    <thead>
                    <tr>
                        <th style="width: 7%;">Grado</th>
                        <th style="width: 7%;">Grupo</th>
                        <th style="width: 9%;">Salón</th>
                        <th style="width: 6%;">PC</th>
                        <th style="width: 12%;">Fecha</th>
                        <th style="width: 10%;">Hora inicial</th>
                        <th style="width: 10%;">Hora final</th>
                        <th style="width: 24%;">Incidencia</th>
                        <th style="width: 15%;">Estado</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:choose>
                        <c:when test="${not empty listaHistorial}">
                            <c:forEach var="item" items="${listaHistorial}">
                                <tr>
                                    <td><strong>${item.grado}</strong></td>
                                    <td><strong>${item.grupo}</strong></td>
                                    <td><strong>${item.salon}</strong></td>
                                    <td>${item.numeroPc}</td>
                                    <td>${item.fecha}</td>
                                    <td>${item.horaInicial}</td>

                                        <%-- hora_final admite NULL: la sesión sigue abierta. --%>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.horaFinal}">${item.horaFinal}</c:when>
                                            <c:otherwise>En curso</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="al-inicio">${item.incidencia}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${item.estado eq 'Validado'}">
                                                <span class="badge-estado badge-validado">Validado</span>
                                            </c:when>
                                            <c:when test="${item.estado eq 'Pendiente'}">
                                                <span class="badge-estado badge-pendiente">Pendiente</span>
                                            </c:when>
                                            <c:when test="${item.estado eq 'Descartado'}">
                                                <span class="badge-estado badge-descartado">Descartado</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-estado badge-sinreporte">Sin reporte</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>

                        <c:otherwise>
                            <tr>
                                <td colspan="9" class="sin-datos">
                                    Este alumno todavía no tiene registros en la bitácora.
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

</body>
</html>
