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
            --verde-utez: #128970;
            --azul-utez: #224270;
            --gris-fondo: #F3F3F3;
        }

        body {
            background-color: #444444;
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
            background-color: #ffffff;
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
            background-color: var(--gris-fondo);
            border-radius: 20px;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.15);
            max-width: 900px;
            width: 100%;
            margin: auto;
            border: 1px solid #ccc;
        }

        .btn-registrar {
            background-color: var(--verde-utez);
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
            background-color: var(--azul-utez);
            color: white;
            border: none;
            border-radius: 20px;
            padding: 10px 45px;
            font-weight: bold;
        }

        .btn-cancelar:hover {
            background-color: #173154;
            color: white;
        }

        .form-control {
            border-radius: 15px;
            padding: 14px;
            border: 1px solid #ced4da;
            background-color: #ffffff;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
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
    <div class="sidebar">
        <div>
            <div class="text-center py-4 px-3">
                <div class="avatar-box position-relative d-inline-block mb-2">
                    <div style="width: 110px; height: 110px; background-color: #c0c0c0; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto; border: 3px solid white;">
                        <i class="bi bi-person-fill text-white" style="font-size: 3.5rem;"></i>
                    </div>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-circle bg-light text-dark p-2 shadow-sm"
                          style="cursor:pointer; top: 15px !important;">
                        <i class="bi bi-pencil-fill text-muted" style="font-size: 0.8rem;"></i>
                    </span>
                </div>
                <h6 class="fw-bold mb-0 mt-2">¡Bienvenido(a)!</h6>
                <small class="opacity-75">Pedro Urieta</small>
            </div>

            <div class="nav flex-column">
                <a href="#" class="nav-link">Buscar</a>
                <a href="#" class="nav-link">Bitácora</a>
                <a href="#" class="nav-link">Incidencias</a>
                <a href="#" class="nav-link active d-flex justify-content-between align-items-center">
                    <span>Registrar nuevo usuario</span>
                    <i class="bi bi-arrow-right fs-5"></i>
                </a>
            </div>
        </div>

        <div class="p-4">
            <a href="#" class="text-white text-decoration-none opacity-75"><i class="bi bi-box-arrow-left me-2"></i>
                Cerrar sesión</a>
        </div>
    </div>

    <div class="main-content">
        <div class="main-header">
            <h5 class="m-0 fw-bold" style="font-size: 1.3rem; letter-spacing: 0.5px;">¡Bienvenido(a)!, Ingresaste como
                administrador</h5>
        </div>

        <div class="p-4 d-flex align-items-center flex-grow-1">
            <div class="form-container p-5">

                <div class="text-center mb-2">
                    <img src="https://www.utez.edu.mx/wp-content/uploads/2024/08/LOGO_UTEZ-2016.png" alt="Logotipo UTEZ"
                         class="img-fluid mb-2" style="max-height: 150px;">
                    <h3 class="fw-bold text-secondary mt-3 mb-4" style="font-size: 1.6rem;">Registrar maestro</h3>
                </div>

                <form id="formRegistrarMaestro" novalidate>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="nombre" placeholder="Nombre(s)" maxlength="30" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="apellidoPaterno" placeholder="Apellido paterno" maxlength="30" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="apellidoMaterno" placeholder="Apellido materno" maxlength="30" required>
                            </div>
                            <div class="mb-3">
                                <input type="email" class="form-control" id="correo" placeholder="Correo" maxlength="30" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="password" class="form-control" id="contrasena" placeholder="Contraseña" required>
                            </div>
                            <div class="mb-3">
                                <input type="password" class="form-control" id="confirmarContrasena" placeholder="Confirme la contraseña" required>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="telefono" placeholder="Ingrese el teléfono" maxlength="10" required>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-4 mt-5">
                        <button type="button" id="btnCancelar" class="btn btn-cancelar shadow-sm">Cancelar</button>
                        <button type="submit" class="btn btn-registrar shadow-sm">Registrar</button>
                    </div>
                </form>

            </div>
        </div>
        <div class="py-3 bg-light text-center text-muted border-top" style="font-size: 0.75rem;">
            &copy; 2026 Integradora SMCA
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="valida-registro.js"></script>
</body>
</html>