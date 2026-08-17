<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña - UTEZ</title>

    <!-- Bootstrap 5 CSS e Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.5">
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
                     alt="Logo"
                     style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
            </div>
        </div>

        <h2 style="text-align: center; color: #555555; font-size: 18px; margin-bottom: 20px; font-weight: 600;">
            Recuperar contraseña
        </h2>

        <!-- Alerta de Error -->
        <div id="alertBox" class="alert alert-danger text-center p-2 mb-3 d-none" style="font-size: 13px;"></div>

        <!-- Formulario Paso 1 -->
        <form id="formRecuperar">
            <div class="form-group mb-3">
                <div class="input-icon-wrapper">
                    <i class="bi bi-envelope icon-input"></i>
                    <input type="email" id="correo" name="correo" class="form-control" placeholder="Introduce tu correo institucional" required>
                </div>
            </div>

            <div class="button-container mt-3">
                <button type="submit" id="btnEnviarCodigo" class="btn btn-primary w-100">
                    <span id="spinnerBtn" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Continuar
                </button>
            </div>

            <div class="card-links-container" style="text-align: center; margin-top: 15px;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="card-link bold-link">Regresar al login</a>
            </div>
        </form>
    </main>

</div>

<!-- Modal para Validar Código de 6 dígitos -->
<div class="modal fade" id="modalCodigoRecuperacion" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="bi bi-shield-lock me-2"></i>Código de Verificación
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body">
                <p class="text-center text-muted small">
                    Hemos enviado un código de 6 dígitos a tu correo electrónico. Ingrésalo para continuar:
                </p>

                <div id="modalAlertBox" class="alert alert-danger text-center p-2 d-none" style="font-size: 13px;"></div>

                <div class="mb-3">
                    <label for="inputCodigo" class="form-label fw-bold text-center w-100">Código de 6 dígitos</label>
                    <input type="text" class="form-control text-center fw-bold fs-4" id="inputCodigo" maxlength="6" placeholder="000000" style="letter-spacing: 5px;">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" id="btnValidarCodigo" class="btn btn-primary fw-bold">
                    <span id="spinnerModal" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Validar Código
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const contextPath = "${pageContext.request.contextPath}";
    const modalCodigoBs = new bootstrap.Modal(document.getElementById('modalCodigoRecuperacion'));

    // 1. Enviar Solicitud de Código
    document.getElementById('formRecuperar').addEventListener('submit', function (e) {
        e.preventDefault();

        const alertBox = document.getElementById('alertBox');
        const btnEnviar = document.getElementById('btnEnviarCodigo');
        const spinnerBtn = document.getElementById('spinnerBtn');
        const correo = document.getElementById('correo').value;

        alertBox.classList.add('d-none');
        btnEnviar.disabled = true;
        spinnerBtn.classList.remove('d-none');

        const params = new URLSearchParams();
        params.append('accion', 'enviarCodigo');
        params.append('correo', correo);

        fetch(contextPath + '/recuperarPassServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
            .then(res => res.json())
            .then(data => {
                btnEnviar.disabled = false;
                spinnerBtn.classList.add('d-none');

                if (data.status === 'ok') {
                    document.getElementById('inputCodigo').value = '';
                    document.getElementById('modalAlertBox').classList.add('d-none');
                    modalCodigoBs.show();
                } else {
                    alertBox.textContent = data.message;
                    alertBox.classList.remove('d-none');
                }
            })
            .catch(() => {
                btnEnviar.disabled = false;
                spinnerBtn.classList.add('d-none');
                alertBox.textContent = 'Error al procesar la solicitud.';
                alertBox.classList.remove('d-none');
            });
    });

    // 2. Validar Código Ingresado
    document.getElementById('btnValidarCodigo').addEventListener('click', function () {
        const codigo = document.getElementById('inputCodigo').value.trim();
        const modalAlertBox = document.getElementById('modalAlertBox');
        const btnValidar = document.getElementById('btnValidarCodigo');
        const spinnerModal = document.getElementById('spinnerModal');

        if (codigo.length !== 6) {
            modalAlertBox.textContent = 'Ingresa un código válido de 6 dígitos.';
            modalAlertBox.classList.remove('d-none');
            return;
        }

        modalAlertBox.classList.add('d-none');
        btnValidar.disabled = true;
        spinnerModal.classList.remove('d-none');

        const params = new URLSearchParams();
        params.append('accion', 'validarCodigo');
        params.append('txtCodigo', codigo);

        fetch(contextPath + '/recuperarPassServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
            .then(res => res.json())
            .then(data => {
                btnValidar.disabled = false;
                spinnerModal.classList.add('d-none');

                if (data.status === 'ok') {
                    // Redirigir a la vista de reestablecer contraseña
                    window.location.href = contextPath + '/views/cambiar_password.jsp';
                } else {
                    modalAlertBox.textContent = data.message;
                    modalAlertBox.classList.remove('d-none');
                }
            })
            .catch(() => {
                btnValidar.disabled = false;
                spinnerModal.classList.add('d-none');
                modalAlertBox.textContent = 'Error al verificar el código.';
                modalAlertBox.classList.remove('d-none');
            });
    });
</script>
</body>
</html>