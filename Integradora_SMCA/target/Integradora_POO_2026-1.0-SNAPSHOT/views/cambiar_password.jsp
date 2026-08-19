<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Sin código validado no se puede llegar aquí.
    Boolean autorizado = (Boolean) session.getAttribute("autorizadoCambioPass");
    if (autorizado == null || !autorizado) {
        response.sendRedirect(request.getContextPath() + "/recuperarPassServlet");
        return;
    }
    // Esta pantalla nunca debe quedar en el caché del navegador.
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva contraseña - UTEZ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.5">

    <style>
        .paso-indicador {
            display: block;
            text-align: center;
            font-size: 11px;
            letter-spacing: .12em;
            text-transform: uppercase;
            color: #8a8a8a;
            margin-bottom: 6px;
        }

        .titulo-pantalla {
            text-align: center;
            color: #444;
            font-size: 19px;
            font-weight: 600;
            margin-bottom: 6px;
        }

        .subtitulo-pantalla {
            text-align: center;
            color: #7a7a7a;
            font-size: 13px;
            margin-bottom: 22px;
        }

        .campo-con-boton {
            position: relative;
        }

        .campo-con-boton .form-control {
            padding-right: 44px;
        }

        .btn-ver-pass {
            position: absolute;
            top: 50%;
            right: 6px;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #8a8a8a;
            font-size: 17px;
            line-height: 1;
            padding: 6px 8px;
            cursor: pointer;
        }

        .btn-ver-pass:hover { color: #444; }
        .btn-ver-pass:focus-visible { outline: 2px solid #0d6efd; border-radius: 4px; }

        /* Lista de requisitos: la señal más útil de esta pantalla */
        .requisitos {
            list-style: none;
            margin: 14px 0 4px;
            padding: 12px 14px;
            background: #f7f8fa;
            border-radius: 8px;
            font-size: 12.5px;
        }

        .requisitos li {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #8a8a8a;
            padding: 3px 0;
            transition: color .15s ease;
        }

        .requisitos li::before {
            content: "\F28A"; /* bi-circle */
            font-family: "bootstrap-icons";
            font-size: 12px;
            color: #c8c8c8;
        }

        .requisitos li.cumplido {
            color: #1e7e4a;
        }

        .requisitos li.cumplido::before {
            content: "\F26B"; /* bi-check-circle-fill */
            color: #1e7e4a;
        }

        .barra-fuerza {
            height: 4px;
            border-radius: 4px;
            background: #e6e8ec;
            overflow: hidden;
            margin-top: 12px;
        }

        .barra-fuerza span {
            display: block;
            height: 100%;
            width: 0;
            background: #c0392b;
            transition: width .2s ease, background .2s ease;
        }

        .panel-exito {
            text-align: center;
            padding: 10px 0 4px;
        }

        .panel-exito .bi {
            font-size: 46px;
            color: #1e7e4a;
        }

        @media (prefers-reduced-motion: reduce) {
            * { transition: none !important; }
        }
    </style>
</head>
<body class="login-body">

<div class="login-page-container">

    <header class="login-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
        <h1 class="system-title">Bitácora digital</h1>
    </header>

    <main class="login-card">

        <div id="bloqueFormulario">
            <span class="paso-indicador">Paso 3 de 3</span>
            <h2 class="titulo-pantalla">Crea tu nueva contraseña</h2>
            <p class="subtitulo-pantalla">Elige una que no uses en otros sitios.</p>

            <div id="alertBox" class="alert alert-danger text-center p-2 mb-3 d-none" style="font-size: 13px;" role="alert"></div>

            <form id="formCambiarPass" novalidate>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">Nueva contraseña</label>
                    <div class="campo-con-boton">
                        <input type="password" class="form-control" id="newPassword" name="newPassword"
                               minlength="8" maxlength="16" autocomplete="new-password" required>
                        <button type="button" class="btn-ver-pass" data-objetivo="newPassword"
                                aria-label="Mostrar contraseña">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <div class="barra-fuerza" aria-hidden="true"><span id="barraFuerza"></span></div>
                </div>

                <div class="mb-2">
                    <label for="confirmPassword" class="form-label">Confirmar contraseña</label>
                    <div class="campo-con-boton">
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                               maxlength="16" autocomplete="new-password" required>
                        <button type="button" class="btn-ver-pass" data-objetivo="confirmPassword"
                                aria-label="Mostrar contraseña">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                </div>

                <ul class="requisitos" id="requisitos">
                    <li data-regla="longitud">Entre 8 y 16 caracteres</li>
                    <li data-regla="letra">Al menos una letra</li>
                    <li data-regla="numero">Al menos un número</li>
                    <li data-regla="coincide">Las dos contraseñas coinciden</li>
                </ul>

                <div class="button-container mt-3">
                    <button type="submit" id="btnCambiar" class="btn btn-success w-100" disabled>
                        <span id="spinnerBtn" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                        Guardar contraseña
                    </button>
                </div>
            </form>
        </div>

        <!-- Confirmación: sustituye al alert() del navegador -->
        <div id="bloqueExito" class="panel-exito d-none" role="status">
            <i class="bi bi-check-circle-fill"></i>
            <h2 class="titulo-pantalla mt-3">Contraseña actualizada</h2>
            <p class="subtitulo-pantalla">Ya puedes entrar con tu nueva contraseña.</p>
            <a href="${pageContext.request.contextPath}/index.jsp?cambioPass=exito" class="btn btn-success w-100">
                Ir al login
            </a>
            <p class="subtitulo-pantalla mt-3 mb-0" style="font-size:12px;">
                Te llevamos automáticamente en <span id="segundos">4</span> s.
            </p>
        </div>

    </main>

</div>

<script>
    var contextPath = "${pageContext.request.contextPath}";

    var form = document.getElementById('formCambiarPass');
    var inputPass = document.getElementById('newPassword');
    var inputConfirm = document.getElementById('confirmPassword');
    var alertBox = document.getElementById('alertBox');
    var btnCambiar = document.getElementById('btnCambiar');
    var spinnerBtn = document.getElementById('spinnerBtn');
    var barraFuerza = document.getElementById('barraFuerza');
    var listaRequisitos = document.getElementById('requisitos');

    // Mismas reglas que valida el servlet. Si cambias una, cambia la otra.
    function evaluarReglas() {
        var pass = inputPass.value;
        var confirm = inputConfirm.value;

        return {
            longitud: pass.length >= 8 && pass.length <= 16,
            letra: /[a-zA-Z]/.test(pass),
            numero: /[0-9]/.test(pass),
            coincide: pass.length > 0 && pass === confirm
        };
    }

    function pintarEstado() {
        var reglas = evaluarReglas();
        var cumplidas = 0;

        Object.keys(reglas).forEach(function (clave) {
            var item = listaRequisitos.querySelector('[data-regla="' + clave + '"]');
            if (item) item.classList.toggle('cumplido', reglas[clave]);
            if (reglas[clave]) cumplidas++;
        });

        // La barra mide qué tan completa está la contraseña, no su entropía real.
        var porcentaje = (cumplidas / 4) * 100;
        barraFuerza.style.width = porcentaje + '%';
        barraFuerza.style.background = porcentaje < 50 ? '#c0392b'
            : (porcentaje < 100 ? '#e0a63a' : '#1e7e4a');

        btnCambiar.disabled = cumplidas !== 4;
        return cumplidas === 4;
    }

    inputPass.addEventListener('input', pintarEstado);
    inputConfirm.addEventListener('input', pintarEstado);

    // Mostrar / ocultar contraseña
    document.querySelectorAll('.btn-ver-pass').forEach(function (boton) {
        boton.addEventListener('click', function () {
            var campo = document.getElementById(boton.dataset.objetivo);
            var oculto = campo.type === 'password';
            campo.type = oculto ? 'text' : 'password';
            boton.querySelector('i').className = oculto ? 'bi bi-eye-slash' : 'bi bi-eye';
            boton.setAttribute('aria-label', oculto ? 'Ocultar contraseña' : 'Mostrar contraseña');
            campo.focus();
        });
    });

    function mostrarError(mensaje) {
        alertBox.textContent = mensaje;
        alertBox.classList.remove('d-none');
    }

    function mostrarExito() {
        document.getElementById('bloqueFormulario').classList.add('d-none');
        document.getElementById('bloqueExito').classList.remove('d-none');

        var restante = 4;
        var etiqueta = document.getElementById('segundos');
        var destino = contextPath + '/index.jsp?cambioPass=exito';

        setInterval(function () {
            restante--;
            etiqueta.textContent = restante;
            if (restante <= 0) window.location.href = destino;
        }, 1000);
    }

    form.addEventListener('submit', function (e) {
        e.preventDefault();

        if (!pintarEstado()) {
            mostrarError('Revisa los requisitos de la contraseña.');
            return;
        }

        alertBox.classList.add('d-none');
        btnCambiar.disabled = true;
        spinnerBtn.classList.remove('d-none');

        var params = new URLSearchParams();
        params.append('accion', 'actualizarPassword');
        params.append('newPassword', inputPass.value);
        // El servidor vuelve a comparar: nunca confía solo en el navegador.
        params.append('confirmPassword', inputConfirm.value);

        fetch(contextPath + '/recuperarPassServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: params.toString()
        })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                spinnerBtn.classList.add('d-none');

                if (data.status === 'ok') {
                    mostrarExito();
                } else {
                    btnCambiar.disabled = false;
                    mostrarError(data.message);
                }
            })
            .catch(function () {
                spinnerBtn.classList.add('d-none');
                btnCambiar.disabled = false;
                mostrarError('No pudimos conectar con el servidor. Revisa tu conexión.');
            });
    });

    pintarEstado();
</script>
</body>
</html>
