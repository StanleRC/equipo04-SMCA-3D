
<%--
    FRAGMENTO: Encabezado común de todas las pantallas con sidebar.
    QUÉ ABRE: <html>, <head> y <body>. Lo cierra footer.jsp.

    El título se recibe como parámetro desde cada página:
        <jsp:include page="/views/layout/header.jsp">
            <jsp:param name="pageTitle" value="Bitácora - UTEZ" />
        </jsp:include>

    Si no se manda, usa "Bitácora Digital" por defecto.

    Aquí se cargan Bootstrap, los iconos y el CSS general. Cada pantalla añade
    después su propia hoja de estilos.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : "Bitácora Digital"}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.css">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css">
</head>
<body>