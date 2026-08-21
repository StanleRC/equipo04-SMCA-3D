<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar contraseña - UTEZ</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.5">

    <style>
        /* Estilos acotados a esta pantalla: no tocan index.css */
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
            line-height: 1.5;
            margin-bottom: 22px;
        }

        .campo-codigo {
            font-family: "SFMono-Regular", "Consolas", "Menlo", monospace;
            font-size: 28px;
            font-weight: 700;
            text-align: center;
            letter-spacing: .55em;
            text-indent: .55em; /* compensa el espaciado extra a la derecha */
            padding: 12px 0;
        }

        .campo-codigo::placeholder {
            color: #d0d0d0;
            font-weight: 400;
        }

        .pie-codigo {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #8a8a8a;
            margin-top: 10px;
        }

        .btn-reenviar {
            background: none;
            border: none;
            padding: 0;
            font-size: 12px;
            font-weight: 600;
            color: #0d6efd;
            cursor: pointer;
        }

        .btn-reenviar:disabled {
            color: #b0b0b0;
            cursor: default;
        }

        .vence-en.por-vencer {
            color: #c0392b;
            font-weight: 600;
        }

        .correo-destino {
            font-weight: 600;
            color: #444;
            word-break: break-all;
        }
        /* Botón principal (verde estilo Guardar cambios) */
        .btn-principal {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            transition: background-color 0.2s ease-in-out;
            color: #ffffff;
            background-color: #0d8a72; /* verde */
            border: none;
            text-align: center;
            cursor: pointer;
        }

        .btn-principal:hover {
            background-color: #0a7560; /* verde más oscuro */
        }

        /* Botón secundario (azul estilo Cancelar) */
        .btn-secundario {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 600;
            text-decoration: none;
            transition: background-color 0.2s ease-in-out;
            color: #ffffff;
            background-color: #0d3b66; /* azul oscuro */
            border: none;
            text-align: center;
            cursor: pointer;
        }

        .btn-secundario:hover {
            background-color: #092a4d; /* azul más oscuro */
        }



        @media (prefers-reduced-motion: reduce) {
            * { animation: none !important; transition: none !important; }
        }

        .btn-verde {
            background-color: #0D8A72; /* verde */
            color: #fff;
            font-weight: bold;
            border: none;
        }

        .btn-verde:hover {
            background-color: #218838; /* verde más oscuro */
        }

        .bg-verde {
            background-color: #0D8A72; /*verde */
            color: #fff;
        }

        .bg-verde .modal-title {
            font-weight: bold;
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

        <div class="login-avatar-container">
            <div class="login-avatar-circle">
                <img src="${pageContext.request.contextPath}/assets/img/logologis.png"
                     alt=""
                     style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
            </div>
        </div>

        <span class="paso-indicador">Paso 1 de 3</span>
        <h2 class="titulo-pantalla">Recuperar contraseña</h2>
        <p class="subtitulo-pantalla">
            Escribe tu correo institucional y te enviamos un código para verificar que eres tú.
        </p>

        <div id="alertBox" class="alert text-center p-2 mb-3 d-none" style="font-size: 13px;" role="alert"></div>

        <form id="formRecuperar" novalidate>
            <div class="form-group mb-3">
                <div class="input-icon-wrapper">
                    <i class="bi bi-envelope icon-input"></i>
                    <input type="email" id="correo" name="correo" class="form-control"
                           placeholder="Introduce tu correo institucional"
                           autocomplete="email" autofocus required>
                </div>
            </div>

            <div class="button-container mt-3">
                <button type="submit" id="btnEnviarCodigo" class="btn-principal">
                    <span id="spinnerBtn" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Enviar código
                </button>
            </div>

            <div class="card-links-container" style="text-align: center; margin-top: 15px;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="card-link bold-link">Regresar al login</a>
            </div>
        </form>
    </main>

</div>

<!-- Verificación del código -->
<div class="modal fade" id="modalCodigoRecuperacion" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="tituloModalCodigo" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-verde text-white">
                <h5 class="modal-title" id="tituloModalCodigo">
                    <i class="bi bi-shield-lock me-2"></i>
                    Paso 2 de 3: verificar código
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>


            <div class="modal-body">
                <p class="text-center text-muted small mb-3">
                    Enviamos un código de 6 dígitos a
                    <span class="correo-destino" id="correoDestino"></span>.
                    Revisa también la carpeta de spam.
                </p>

                <div id="modalAlertBox" class="alert text-center p-2 d-none" style="font-size: 13px;" role="alert"></div>

                <label for="inputCodigo" class="form-label fw-bold text-center w-100 small">Código de 6 dígitos</label>
                <input type="text" class="form-control campo-codigo" id="inputCodigo"
                       inputmode="numeric" autocomplete="one-time-code" maxlength="6" placeholder="000000">

                <div class="pie-codigo">
                    <span class="vence-en" id="venceEn">Vence en 10:00</span>
                    <button type="button" class="btn-reenviar" id="btnReenviar" disabled>Reenviar código</button>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" id="btnValidarCodigo" class="btn btn-verde fw-bold">
                    <span id="spinnerModal" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Verificar
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var contextPath = "${pageContext.request.contextPath}";
    var VIGENCIA_SEGUNDOS = 600;   // debe coincidir con VIGENCIA_CODIGO_MS del servlet
    var ESPERA_REENVIO_SEG = 60;   // debe coincidir con COOLDOWN_ENVIO_MS del servlet

    var modalCodigo = new bootstrap.Modal(document.getElementById('modalCodigoRecuperacion'));

    var formRecuperar = document.getElementById('formRecuperar');
    var inputCorreo = document.getElementById('correo');
    var alertBox = document.getElementById('alertBox');
    var btnEnviar = document.getElementById('btnEnviarCodigo');
    var spinnerBtn = document.getElementById('spinnerBtn');

    var modalAlertBox = document.getElementById('modalAlertBox');
    var inputCodigo = document.getElementById('inputCodigo');
    var btnValidar = document.getElementById('btnValidarCodigo');
    var spinnerModal = document.getElementById('spinnerModal');
    var btnReenviar = document.getElementById('btnReenviar');
    var venceEn = document.getElementById('venceEn');
    var correoDestino = document.getElementById('correoDestino');

    var temporizadorVigencia = null;
    var temporizadorReenvio = null;

    function mostrarAviso(caja, mensaje, tipo) {
        caja.textContent = mensaje;
        caja.classList.remove('d-none', 'alert-danger', 'alert-success');
        caja.classList.add(tipo === 'ok' ? 'alert-success' : 'alert-danger');
    }

    function ocultarAviso(caja) {
        caja.classList.add('d-none');
    }

    function cargando(boton, spinner, activo) {
        boton.disabled = activo;
        spinner.classList.toggle('d-none', !activo);
    }

    function formatearTiempo(segundos) {
        var m = Math.floor(segundos / 60);
        var s = segundos % 60;
        return m + ':' + (s < 10 ? '0' + s : s);
    }

    /** Envía la petición al servlet y devuelve el JSON ya parseado. */
    function pedirAlServidor(params) {
        return fetch(contextPath + '/recuperarPassServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: params.toString()
        }).then(function (res) {
            return res.json();
        });
    }

    function iniciarCuentaRegresiva() {
        clearInterval(temporizadorVigencia);
        var restante = VIGENCIA_SEGUNDOS;

        function pintar() {
            venceEn.textContent = restante > 0
                ? 'Vence en ' + formatearTiempo(restante)
                : 'El código venció';
            venceEn.classList.toggle('por-vencer', restante <= 60);
        }

        pintar();
        temporizadorVigencia = setInterval(function () {
            restante--;
            pintar();
            if (restante <= 0) clearInterval(temporizadorVigencia);
        }, 1000);
    }

    function iniciarEsperaReenvio() {
        clearInterval(temporizadorReenvio);
        var restante = ESPERA_REENVIO_SEG;

        btnReenviar.disabled = true;
        btnReenviar.textContent = 'Reenviar en ' + restante + 's';

        temporizadorReenvio = setInterval(function () {
            restante--;
            if (restante <= 0) {
                clearInterval(temporizadorReenvio);
                btnReenviar.disabled = false;
                btnReenviar.textContent = 'Reenviar código';
            } else {
                btnReenviar.textContent = 'Reenviar en ' + restante + 's';
            }
        }, 1000);
    }

    // ---------- Paso 1: solicitar el código ----------
    function solicitarCodigo(esReenvio) {
        var correo = inputCorreo.value.trim();

        if (!correo) {
            mostrarAviso(alertBox, 'Escribe tu correo electrónico.', 'error');
            inputCorreo.focus();
            return;
        }

        var caja = esReenvio ? modalAlertBox : alertBox;
        var boton = esReenvio ? btnReenviar : btnEnviar;

        ocultarAviso(caja);
        if (esReenvio) {
            boton.disabled = true;
        } else {
            cargando(btnEnviar, spinnerBtn, true);
        }

        var params = new URLSearchParams();
        params.append('accion', 'enviarCodigo');
        params.append('correo', correo);

        pedirAlServidor(params)
            .then(function (data) {
                if (!esReenvio) cargando(btnEnviar, spinnerBtn, false);

                if (data.status === 'ok') {
                    correoDestino.textContent = correo;
                    inputCodigo.value = '';
                    ocultarAviso(modalAlertBox);
                    iniciarCuentaRegresiva();
                    iniciarEsperaReenvio();

                    if (esReenvio) {
                        mostrarAviso(modalAlertBox, 'Te enviamos un código nuevo.', 'ok');
                    } else {
                        modalCodigo.show();
                    }
                    setTimeout(function () { inputCodigo.focus(); }, 300);
                } else {
                    mostrarAviso(caja, data.message, 'error');
                    if (esReenvio) boton.disabled = false;
                }
            })
            .catch(function () {
                if (!esReenvio) cargando(btnEnviar, spinnerBtn, false);
                if (esReenvio) boton.disabled = false;
                mostrarAviso(caja, 'No pudimos conectar con el servidor. Revisa tu conexión.', 'error');
            });
    }

    formRecuperar.addEventListener('submit', function (e) {
        e.preventDefault();
        solicitarCodigo(false);
    });

    btnReenviar.addEventListener('click', function () {
        solicitarCodigo(true);
    });

    // ---------- Paso 2: verificar el código ----------
    // Solo dígitos, sin importar si el usuario escribe o pega.
    inputCodigo.addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '').slice(0, 6);
        if (this.value.length === 6) ocultarAviso(modalAlertBox);
    });

    inputCodigo.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            btnValidar.click();
        }
    });

    btnValidar.addEventListener('click', function () {
        var codigo = inputCodigo.value.trim();

        if (codigo.length !== 6) {
            mostrarAviso(modalAlertBox, 'El código tiene 6 dígitos.', 'error');
            inputCodigo.focus();
            return;
        }

        ocultarAviso(modalAlertBox);
        cargando(btnValidar, spinnerModal, true);

        var params = new URLSearchParams();
        params.append('accion', 'validarCodigo');
        params.append('txtCodigo', codigo);

        pedirAlServidor(params)
            .then(function (data) {
                if (data.status === 'ok') {
                    clearInterval(temporizadorVigencia);
                    clearInterval(temporizadorReenvio);
                    mostrarAviso(modalAlertBox, 'Código verificado. Un momento...', 'ok');
                    window.location.href = contextPath + '/views/cambiar_password.jsp';
                    return;
                }
                cargando(btnValidar, spinnerModal, false);
                mostrarAviso(modalAlertBox, data.message, 'error');
                inputCodigo.value = '';
                inputCodigo.focus();
            })
            .catch(function () {
                cargando(btnValidar, spinnerModal, false);
                mostrarAviso(modalAlertBox, 'No pudimos conectar con el servidor. Revisa tu conexión.', 'error');
            });
    });

    // Al cerrar el modal se detienen los contadores para no dejarlos corriendo.
    document.getElementById('modalCodigoRecuperacion').addEventListener('hidden.bs.modal', function () {
        clearInterval(temporizadorVigencia);
        clearInterval(temporizadorReenvio);
    });
</script>
</body>
</html>
