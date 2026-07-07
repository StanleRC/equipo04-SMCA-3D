<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Maestro - UTEZ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.css">

    <style>
        :root {
            --verde-utez: #002e2c;    /* El verde oscuro real de tu Figma */
            --azul-utez: #224270;
            --gris-fondo: #F3F3F3;
        }

        body {
            background-color: var(--gris-fondo);
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Estructura principal con Flexbox */
        .wrapper {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            background-color: var(--verde-utez);
            width: 280px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .main-content {
            flex-grow: 1;
            background-color: var(--gris-fondo);
            display: flex;
            flex-direction: column;
        }

        .sidebar .nav-link {
            color: white;
            padding: 18px 25px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            text-decoration: none;
            display: block;
            font-size: 1.1rem;
        }

        .sidebar .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.05);
        }

        .sidebar .nav-link.active {
            background-color: rgba(255, 255, 255, 0.15);
            border-left: 5px solid white;
        }

        .main-header {
            background-color: var(--azul-utez);
            color: white;
            padding: 20px 25px;
            text-align: center;
        }

        .form-container {
            background-color: #ffffff;
            border-radius: 20px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.08);
            max-width: 900px;
            width: 100%;
            margin: auto;
            border: none;
        }

        .btn-registrar {
            background-color: #008f8a; /* Verde brillante de acento de tu Figma */
            color: white;
            border: none;
            border-radius: 20px;
            padding: 10px 45px;
            font-weight: bold;
        }

        .btn-registrar:hover {
            background-color: #0e6e59;
            color: white;
        }

        .btn-cancelar {
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 10px 45px;
            font-weight: bold;
        }

        .btn-cancelar:hover {
            background-color: #5a6268;
            color: white;
        }

        .form-control {
            border-radius: 30px; /* Estilo píldora original */
            padding: 14px 20px;
            border: 1px solid #ced4da;
            background-color: #e8efed; /* Tono grisáceo sutil */
        }

        .avatar-box img {
            width: 110px;
            height: 110px;
            border-radius: 50%;
            background-color: #ffffff;
            object-fit: cover;
        }
    </style>
</head>
<body>

<div class="wrapper">
    <jsp:include page="../layout/sidebar.jsp" />

    <div class="main-content">
        <div class="main-header">
            <h5 class="m-0 fw-bold" style="font-size: 1.3rem; letter-spacing: 0.5px;">¡Bienvenido(a)!, Ingresaste como administrador</h5>
        </div>

        <div class="p-4 d-flex align-items-center flex-grow-1">
            <div class="form-container p-5">

                <div class="text-center mb-2">
                    <img src="https://www.utez.edu.mx/wp-content/uploads/2024/08/LOGO_UTEZ-2016.png" alt="Logotipo UTEZ" class="img-fluid mb-2" style="max-height: 80px;">
                    <h3 class="fw-bold text-secondary mt-3 mb-4" style="font-size: 1.6rem; color: var(--verde-utez) !important;">Registrar maestro</h3>
                </div>

                <form id="formRegistrarMaestro" action="${pageContext.request.contextPath}/RegisterMaestroServlet" method="POST" novalidate>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre(s)" maxlength="30" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="apellidoPaterno" name="apellidoPaterno" placeholder="Apellido paterno" maxlength="30" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="apellidoMaterno" name="apellidoMaterno" placeholder="Apellido materno" maxlength="30" required>
                            </div>
                            <div class="mb-3">
                                <input type="email" class="form-control" id="correo" name="correo" placeholder="Correo" maxlength="30" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="password" class="form-control" id="contrasena" name="pass" placeholder="Contraseña" required>
                            </div>
                            <div class="mb-3">
                                <input type="password" class="form-control" id="confirmarContrasena" name="confirmPass" placeholder="Confirme la contraseña" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="telefono" name="telefono" placeholder="Ingrese el teléfono" maxlength="10" required>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-4 mt-5">
                        <button type="button" id="btnCancelar" class="btn btn-cancelar shadow-sm" onclick="history.back()">Cancelar</button>
                        <button type="submit" class="btn btn-registrar shadow-sm">Registrar</button>
                    </div>
                </form>

            </div>
        </div>
        <div class="py-3 bg-white text-center text-muted border-top" style="font-size: 0.75rem;">
            &copy; 2026 Integradora SMCA - Universidad Tecnológica del Estado de Morelos
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/validar-registro.js"></script>
</body>
</html>