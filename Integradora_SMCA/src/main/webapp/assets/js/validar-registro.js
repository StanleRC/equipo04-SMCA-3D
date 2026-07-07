document.getElementById('formRegistrarMaestro').addEventListener('submit', function(event) {

    event.preventDefault(); // Detiene el envío automático para validar primero

    const nombre = document.getElementById('nombre');
    const apellidoPaterno = document.getElementById('apellidoPaterno');
    const apellidoMaterno = document.getElementById('apellidoMaterno');
    const correo = document.getElementById('correo');
    const contrasena = document.getElementById('contrasena');
    const confirmarContrasena = document.getElementById('confirmarContrasena');
    const telefono = document.getElementById('telefono');

    // EXPRESIONES REGULARES
    const regexSoloLetras = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/;
    const regexCorreo = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const regexSoloNumeros = /^[0-9]+$/;

    // 1. VALIDACIÓN: No dejar espacios vacíos
    const campos = [nombre, apellidoPaterno, apellidoMaterno, correo, contrasena, confirmarContrasena, telefono];
    for (let campo of campos) {
        if (!campo || campo.value.trim() === "") {
            // CORREGIDO: Se cambiaron las comillas a backticks para que funcione la interpolación
            alert(`Por favor, complete el campo: ${campo.placeholder || "requerido"}`);
            campo.focus();
            return;
        }
    }

    // 2. VALIDACIÓN: Comprobación de nombre y apellidos
    const camposTexto = [
        { elemento: nombre, nombreCampo: "Nombre(s)" },
        { elemento: apellidoPaterno, nombreCampo: "Apellido paterno" },
        { elemento: apellidoMaterno, nombreCampo: "Apellido materno" }
    ];

    for (let campo of camposTexto) {
        if (!regexSoloLetras.test(campo.elemento.value)) {
            // CORREGIDO: Comillas invertidas aplicadas aquí también
            alert(`El campo '${campo.nombreCampo}' no puede contener números, símbolos ni caracteres especiales.`);
            campo.elemento.focus();
            return;
        }
        if (campo.elemento.value.length > 30) {
            alert(`El campo '${campo.nombreCampo}' no puede superar los 30 caracteres.`);
            campo.elemento.focus();
            return;
        }
    }

    // 3. VALIDACIÓN: Comprobación de correo
    if (!regexCorreo.test(correo.value)) {
        alert("Por favor, ingrese un correo electrónico válido (ejemplo: usuario@gmail.com).");
        correo.focus();
        return;
    }
    if (correo.value.length > 30) {
        alert("El correo electrónico no puede exceder los 30 caracteres.");
        correo.focus();
        return;
    }

    // 4. VALIDACIÓN: Comprobación de teléfono
    if (!regexSoloNumeros.test(telefono.value)) {
        alert("El teléfono solo puede contener números enteros (sin letras, espacios ni símbolos).");
        telefono.focus();
        return;
    }
    if (telefono.value.length !== 10) {
        alert("El teléfono debe tener una longitud exacta de 10 caracteres numéricos.");
        telefono.focus();
        return;
    }

    // 5. VALIDACIÓN: Verificar contraseñas iguales
    if (contrasena.value !== confirmarContrasena.value) {
        alert("Las contraseñas ingresadas no coinciden.");
        confirmarContrasena.focus();
        return;
    }

    // TODO CORRECTO: Se procede al envío al backend/Servlet
    alert("¡Validación exitosa! Procediendo al registro del maestro.");

    // Ejecución segura del envío del formulario
    HTMLFormElement.prototype.submit.call(this);
});