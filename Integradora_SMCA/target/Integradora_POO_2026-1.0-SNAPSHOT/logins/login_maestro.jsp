<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bitácora Digital - UTEZ</title>

  <style>
    /* Estilos Base Autónomos (No requieren internet) */
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Arial', sans-serif;
    }

    body {
      background-color: #ffffff;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 70vh;
      padding: 20px;
    }

    .login-container {
      width: 100%;
      max-width: 480px;
      text-align: center;
    }

    /* Cabecera y Avatar */
    .header-section {
      margin-bottom: -45px;
      position: relative;
      z-index: 2;
    }

    .logo-utez {
      width: 280px;
      height: auto;
      margin-bottom: 15px;
    }

    .title-system {
      color: #444444;
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 4px;
    }

    .subtitle-system {
      color: #666666;
      font-size: 15px;
      font-weight: bold;
      margin-bottom: 25px;
    }

    /* El círculo gris del usuario con CSS puro */
    .avatar-circle {
      width: 90px;
      height: 90px;
      background-color: #666666;
      border-radius: 50%;
      display: inline-flex;
      justify-content: center;
      align-items: center;
      position: relative;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* Silueta del usuario dibujada con CSS (Por si no carga FontAwesome) */
    .avatar-circle::before {
      content: "";
      position: absolute;
      width: 32px;
      height: 32px;
      background-color: #ffffff;
      border-radius: 50%;
      top: 22px;
    }

    .avatar-circle::after {
      content: "";
      position: absolute;
      width: 54px;
      height: 24px;
      background-color: #ffffff;
      border-radius: 27px 27px 0 0;
      bottom: 12px;
    }

    /* Contenedor Gris Principal */
    .card-form {
      background-color: #f2f2f2;
      border: 1px solid #dcdcdc;
      border-radius: 12px;
      padding: 75px 35px 30px 35px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
      position: relative;
      z-index: 1;
    }

    /* Inputs */
    .form-group {
      margin-bottom: 20px;
      position: relative;
    }

    .form-control {
      width: 100%;
      padding: 12px 20px;
      border: 1px solid #cccccc;
      border-radius: 15px;
      font-size: 14px;
      background-color: #ffffff;
      outline: none;
      text-align: center; /* Centrado para simular el placeholder original */
    }

    .form-control:focus {
      border-color: #008767;
    }

    /* Botón Verde UTEZ */
    .btn-submit {
      background-color: #008767;
      color: #ffffff;
      border: none;
      border-radius: 25px;
      padding: 10px 40px;
      font-size: 14px;
      font-weight: bold;
      cursor: pointer;
      margin-top: 5px;
      margin-bottom: 25px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .btn-submit:hover {
      background-color: #006e53;
    }

    /* Enlaces */
    a {
      color: #666666;
      text-decoration: underline;
      font-size: 13px;
    }

    a:hover {
      color: #000000;
    }

    .forgot-password {
      display: block;
      margin-bottom: 30px;
    }

    .footer-links {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-top: 1px solid #dbdbdb;
      padding-top: 15px;
    }
  </style>
</head>
<body>

<div class="login-container">

  <div class="header-section">
    <img src="https://www.utez.edu.mx/wp-content/uploads/2026/01/Logotipo-UTEZ-scaled.png" alt="Logo UTEZ" class="logo-utez">

    <div class="title-system">Bitácora digital</div>
    <div class="subtitle-system">(Acceso como administrador)</div>

    <div class="avatar-circle"></div>
  </div>

  <div class="card-form">
    <form action="LoginServlet" method="POST">

      <div class="form-group">
        <input type="email" name="correo" class="form-control" placeholder="Introduce un correo verificado" required>
      </div>

      <div class="form-group">
        <input type="password" name="contrasenia" class="form-control" placeholder="Introduce una contraseña" minlength="8" required>
      </div>

      <button type="submit" class="btn-submit">Iniciar sesión</button>

      <a href="#!" class="forgot-password">¿Olvidaste tu contraseña?</a>

      <div class="footer-links">
        <a href="#!">Sobre Nosotros</a>
        <a href="#!">¿Eres un estudiante?</a>
      </div>

    </form>
  </div>

</div>

</body>
</html>