<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Alumno - UTEZ</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.css">
    <link rel="stylesheet" href="../assets/css/bi/bootstrap-icons.css">

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

        .form-control.is-invalid, .dropdown-custom-btn.is-invalid {
            border-color: #dc3545 !important;
            background-image: none !important;
        }

        .form-control.is-valid, .dropdown-custom-btn.is-valid {
            border-color: #198754 !important;
            background-image: none !important;
        }

        /* Estilo para ajustar las etiquetas de error en los campos redondeados */
        .invalid-feedback {
            font-size: 0.85rem;
            padding-left: 10px;
            margin-top: 4px;
        }

        .dropdown-custom-btn {
            width: 100%;
            text-align: left;
            background-color: #ffffff;
            border: 1px solid #ced4da;
            border-radius: 15px;
            padding: 14px;
            color: #6c757d;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dropdown-custom-btn:focus, .dropdown-custom-btn:hover {
            background-color: #ffffff;
            border-color: #86b7fe;
            color: #212529;
            outline: 0;
        }

        .dropdown-menu-custom {
            width: 100%;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border: 1px solid #ced4da;
            padding: 0;
            overflow: hidden;
        }

        .dropdown-menu-custom .dropdown-item {
            padding: 12px 16px;
            border-bottom: 1px solid #f1f1f1;
        }

        .dropdown-menu-custom .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-menu-custom .dropdown-item:hover {
            background-color: var(--gris-fondo);
            color: #000;
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
                    <img src="https://www.utez.edu.mx/wp-content/uploads/2024/08/LOGO_UTEZ-2016.png" alt="Logotipo UTEZ" class="img-fluid mb-2" style="max-height: 150px;">
                    <h3 class="fw-bold text-secondary mt-3 mb-4" style="font-size: 1.6rem;">Registrar alumno</h3>
                </div>

                <form id="formRegistrarAlumno" action="registro-alumno" method="post" novalidate>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="text" class="form-control" id="nombre" name="nombre" placeholder="Nombre(s)" maxlength="30" required>
                                <div class="invalid-feedback" id="err-nombre">El nombre es obligatorio.</div>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="apellidoPaterno" name="apellidoPaterno" placeholder="Apellido paterno" maxlength="30" required>
                                <div class="invalid-feedback" id="err-apellidoPaterno">El apellido paterno es obligatorio.</div>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="apellidoMaterno" name="apellidoMaterno" placeholder="Apellido materno" maxlength="30" required>
                                <div class="invalid-feedback" id="err-apellidoMaterno">El apellido materno es obligatorio.</div>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" id="matricula" name="matricula" placeholder="Matricula" maxlength="10" required>
                                <div class="invalid-feedback" id="err-matricula">La matrícula es obligatoria.</div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="mb-3">
                                <input type="password" class="form-control" id="contrasena" name="contrasena" placeholder="Contraseña" required>
                                <div class="invalid-feedback">La contraseña no puede estar vacía.</div>
                            </div>
                            <div class="mb-3">
                                <input type="password" class="form-control" id="confirmarContrasena" placeholder="Confirme la contraseña" required>
                                <div class="invalid-feedback" id="err-confirmarContrasena">Las contraseñas no coinciden.</div>
                            </div>

                            <div class="row g-2">
                                <input type="hidden" id="carreraValue" name="carrera" required>
                                <input type="hidden" id="grupoValue" name="grupo" required>

                                <div class="col-7 position-relative">
                                    <button class="btn dropdown-custom-btn dropdown-toggle" type="button" id="btnCarrera" data-bs-toggle="dropdown" aria-expanded="false">
                                        <span id="textCarrera">Carrera</span>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-custom" aria-labelledby="btnCarrera">
                                        <li><a class="dropdown-item" href="#" data-value="Desarrollo de software">Desarrollo de software</a></li>
                                        <li><a class="dropdown-item" href="#" data-value="Diseño y animación">Diseño y animación</a></li>
                                        <li><a class="dropdown-item" href="#" data-value="Diseño de modas">Diseño de modas</a></li>
                                    </ul>
                                    <div class="invalid-feedback">Selecciona una carrera.</div>
                                </div>

                                <div class="col-5 position-relative">
                                    <button class="btn dropdown-custom-btn dropdown-toggle" type="button" id="btnGrupo" data-bs-toggle="dropdown" aria-expanded="false">
                                        <span id="textGrupo">Grupo</span>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-custom" aria-labelledby="btnGrupo">
                                        <li><a class="dropdown-item" href="#" data-value="3°A">3°A</a></li>
                                        <li><a class="dropdown-item" href="#" data-value="3°B">3°B</a></li>
                                        <li><a class="dropdown-item" href="#" data-value="3°C">3°C</a></li>
                                        <li><a class="dropdown-item" href="#" data-value="3°D">3°D</a></li>
                                    </ul>
                                    <div class="invalid-feedback">Selecciona un grupo.</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-4 mt-5">
                        <button type="button" id="btnCancelar" class="btn btn-cancelar shadow-sm">Cancelar</button>
                        <button type="submit" class="btn btn-registrar shadow-sm">Registrar</button>
                    </div>

                    <div class="text-center mt-4">
                        <small class="text-muted">¿No encuentras tu grupo? <a href="#" class="text-secondary fw-bold text-decoration-none">Registralo aquí</a></small>
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

<script>
    // 1. CONTROL DE DESPLEGABLES (DROPDOWNS)
    document.querySelectorAll('.dropdown-menu-custom .dropdown-item').forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            const value = this.getAttribute('data-value');
            const text = this.innerText;
            const parentMenu = this.closest('.dropdown-menu');

            if (parentMenu.getAttribute('aria-labelledby') === 'btnCarrera') {
                document.getElementById('textCarrera').innerText = text;
                document.getElementById('carreraValue').value = value;
                document.getElementById('btnCarrera').style.color = '#212529';
                document.getElementById('btnCarrera').classList.remove('is-invalid');
                document.getElementById('btnCarrera').classList.add('is-valid');
            } else {
                document.getElementById('textGrupo').innerText = text;
                document.getElementById('grupoValue').value = value;
                document.getElementById('btnGrupo').style.color = '#212529';
                document.getElementById('btnGrupo').classList.remove('is-invalid');
                document.getElementById('btnGrupo').classList.add('is-valid');
            }
        });
    });

    // 2. VALIDACIÓN DINÁMICA CON ADVERTENCIAS ESPECÍFICAS
    document.getElementById('formRegistrarAlumno').addEventListener('submit', function(e) {
        let formularioValido = true;
        const regexLetras = /^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$/;

        // Validar Nombre, Apellido Paterno y Apellido Materno
        const camposTexto = ['nombre', 'apellidoPaterno', 'apellidoMaterno'];
        camposTexto.forEach(id => {
            const input = document.getElementById(id);
            const labelError = document.getElementById('err-' + id);
            const valorLimpio = input.value.trim();

            if (!valorLimpio) {
                labelError.innerText = "Este campo es obligatorio.";
                input.classList.add('is-invalid');
                input.classList.remove('is-valid');
                formularioValido = false;
            } else if (!regexLetras.test(valorLimpio)) {
                labelError.innerText = "Solo se permiten letras (sin números ni caracteres especiales).";
                input.classList.add('is-invalid');
                input.classList.remove('is-valid');
                formularioValido = false;
            } else {
                input.classList.remove('is-invalid');
                input.classList.add('is-valid');
                input.value = valorLimpio;
            }
        });

        // Validar Matrícula (vacía o diferente de 10 dígitos)
        const matriculaInput = document.getElementById('matricula');
        const labelMatricula = document.getElementById('err-matricula');
        const matriculaLimpia = matriculaInput.value.trim();

        if (!matriculaLimpia) {
            labelMatricula.innerText = "La matrícula es obligatoria.";
            matriculaInput.classList.add('is-invalid');
            matriculaInput.classList.remove('is-valid');
            formularioValido = false;
        } else if (matriculaLimpia.length !== 10) {
            labelMatricula.innerText = "La matrícula debe tener exactamente 10 caracteres.";
            matriculaInput.classList.add('is-invalid');
            matriculaInput.classList.remove('is-valid');
            formularioValido = false;
        } else {
            matriculaInput.classList.remove('is-invalid');
            matriculaInput.classList.add('is-valid');
            matriculaInput.value = matriculaLimpia;
        }

        // Validar Contraseña
        const contra = document.getElementById('contrasena');
        if (!contra.value.trim()) {
            contra.classList.add('is-invalid');
            contra.classList.remove('is-valid');
            formularioValido = false;
        } else {
            contra.classList.remove('is-invalid');
            contra.classList.add('is-valid');
        }

        // Validar Confirmar Contraseña
        const confirmaContra = document.getElementById('confirmarContrasena');
        const labelConfirma = document.getElementById('err-confirmarContrasena');
        if (!confirmaContra.value.trim()) {
            labelConfirma.innerText = "Por favor, confirme su contraseña.";
            confirmaContra.classList.add('is-invalid');
            confirmaContra.classList.remove('is-valid');
            formularioValido = false;
        } else if (contra.value !== confirmaContra.value) {
            labelConfirma.innerText = "Las contraseñas no coinciden.";
            confirmaContra.classList.add('is-invalid');
            confirmaContra.classList.remove('is-valid');
            formularioValido = false;
        } else {
            confirmaContra.classList.remove('is-invalid');
            confirmaContra.classList.add('is-valid');
        }

        // Validar Carrera
        const carreraVal = document.getElementById('carreraValue').value;
        const btnCarrera = document.getElementById('btnCarrera');
        if (!carreraVal) {
            btnCarrera.classList.add('is-invalid');
            btnCarrera.classList.remove('is-valid');
            formularioValido = false;
        } else {
            btnCarrera.classList.remove('is-invalid');
            btnCarrera.classList.add('is-valid');
        }

        // Validar Grupo
        const grupoVal = document.getElementById('grupoValue').value;
        const btnGrupo = document.getElementById('btnGrupo');
        if (!grupoVal) {
            btnGrupo.classList.add('is-invalid');
            btnGrupo.classList.remove('is-valid');
            formularioValido = false;
        } else {
            btnGrupo.classList.remove('is-invalid');
            btnGrupo.classList.add('is-valid');
        }

        if (!formularioValido) {
            e.preventDefault();
        }
    });

    // Botón Cancelar
    document.getElementById('btnCancelar').addEventListener('click', function() {
        document.getElementById('formRegistrarAlumno').reset();
        document.getElementById('textCarrera').innerText = "Carrera";
        document.getElementById('carreraValue').value = "";
        document.getElementById('btnCarrera').style.color = '#6c757d';
        document.getElementById('textGrupo').innerText = "Grupo";
        document.getElementById('grupoValue').value = "";
        document.getElementById('btnGrupo').style.color = '#6c757d';

        document.querySelectorAll('.form-control, .dropdown-custom-btn').forEach(el => {
            el.classList.remove('is-invalid', 'is-valid');
        });
    });
</script>
<jsp:include page="../layout/footer.jsp" />