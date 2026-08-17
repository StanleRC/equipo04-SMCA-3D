<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Verificar si el usuario validó el código previamente
    Boolean autorizado = (Boolean) session.getAttribute("autorizadoCambioPass");
    if (autorizado == null || !autorizado) {
        response.sendRedirect(request.getContextPath() + "/recuperarPassServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Contraseña - UTEZ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css?v=1.5">
</head>
<body class="login-body">

<div class="login-page-container">

    <header class="login-header">
        <img src="${pageContext.request.contextPath}/assets/img/logoutez.png" alt="Logo UTEZ" class="utez-logo">
        <h1 class="system-title">Bitácora digital</h1>
    </header>

    <main class="login-card">

        <h2 style="text-align: center; color: #555555; font-size: 18px; margin-bottom: 20px; font-weight: 600;">
            Establecer Nueva Contraseña
        </h2>

        <div id="alertBox" class="alert alert-danger text-center p-2 mb-3 d-none" style="font-size: 13px;"></div>

        <form id="formCambiarPass">
            <div class="mb-3">
                <label for="newPassword" class="form-label">Nueva Contraseña</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" minlength="8" maxlength="16" required>
            </div>

            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirmar Contraseña</label>
                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
            </div>

            <div class="button-container mt-3">
                <button type="submit" id="btnCambiar" class="btn btn-success w-100">
                    <span id="spinnerBtn" class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                    Guardar Contraseña
                </button>
            </div>
        </form>
    </main>

</div>

<script>
    const contextPath = "${pageContext.request.contextPath}";

    document.getElementById('formCambiarPass').addEventListener('submit', function (e) {
        e.preventDefault();

        const pass = document.getElementById('newPassword').value;
        const confirmPass = document.getElementById('confirmPassword').value;
        const alertBox = document.getElementById('alertBox');
        const btnCambiar = document.getElementById('btnCambiar');
        const spinnerBtn = document.getElementById('spinnerBtn');

        if (pass !== confirmPass) {
            alertBox.textContent = 'Las contraseñas no coinciden.';
            alertBox.classList.remove('d-none');
            return;
        }

        alertBox.classList.add('d-none');
        btnCambiar.disabled = true;
        spinnerBtn.classList.remove('d-none');

        const params = new URLSearchParams();
        params.append('accion', 'actualizarPassword');
        params.append('newPassword', pass);

        fetch(contextPath + '/recuperarPassServlet', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
            .then(res => res.json())
            .then(data => {
                btnCambiar.disabled = false;
                spinnerBtn.classList.add('d-none');

                if (data.status === 'ok') {
                    alert('Contraseña actualizada con éxito.');
                    window.location.href = contextPath + '/index.jsp?cambioPass=exito';
                } else {
                    alertBox.textContent = data.message;
                    alertBox.classList.remove('d-none');
                }
            })
            .catch(() => {
                btnCambiar.disabled = false;
                spinnerBtn.classList.add('d-none');
                alertBox.textContent = 'Error al actualizar la contraseña.';
                alertBox.classList.remove('d-none');
            });
    });
</script>
</body>
</html>