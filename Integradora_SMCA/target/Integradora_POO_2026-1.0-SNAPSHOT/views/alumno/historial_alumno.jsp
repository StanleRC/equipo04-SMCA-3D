<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de Incidencias</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5">
    <h2 class="mb-4 text-center">Mi Historial de Registros e Incidencias</h2>

    <div class="table-responsive shadow-sm bg-white p-3 rounded">
        <table class="table table-bordered align-middle text-center mb-0">
            <thead class="table-dark">
            <tr>
                <th>Grado</th>
                <th>Grupo</th>
                <th>PC</th>
                <th>Matrícula</th>
                <th>Nombre</th>
                <th>Fecha</th>
                <th>Incidencia</th>
                <th>Estado</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty misRegistros}">
                    <c:forEach var="reg" items="${misRegistros}">
                        <tr>
                            <td><c:out value="${reg.grado}" /></td>
                            <td><c:out value="${reg.grupo}" /></td>
                            <td><c:out value="${reg.numero_pc}" /></td>
                            <td><c:out value="${reg.matricula}" /></td>
                            <td class="text-start"><c:out value="${reg.nombre_completo}" /></td>
                            <td><c:out value="${reg.fecha}" /></td>
                            <td class="text-start"><c:out value="${reg.incidencia}" /></td>
                            <td>
                                <span class="${reg.estado eq 'Validado' or reg.estado eq 'VALIDADA' ? 'text-success fw-bold' :
                                              (reg.estado eq 'Descartado' or reg.estado eq 'DESCARTADA' ? 'text-danger fw-bold' :
                                              (reg.estado eq 'Pendiente' or reg.estado eq 'PENDIENTE' ? 'text-warning fw-bold' : 'text-muted'))}">
                                    <c:out value="${reg.estado}" />
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8" class="py-4 text-muted">
                            No cuentas con registros de asistencia en la bitácora.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>