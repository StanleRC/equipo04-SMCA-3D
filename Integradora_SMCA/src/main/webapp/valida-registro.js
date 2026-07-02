document.getElementById('formRegistrarMaestro').addEventListener('submit', function(event) {

    event.preventDefault();
    const nombre = document.getElementById('nombre');
    const apellidoPaterno = document.getElementById('apellidoPaterno');
    const apellidoMaterno = document.getElementById('apellidoMaterno');
    const correo = document.getElementById('correo');
    const contrasena = document.getElementById('contrasena');
    const confirmarContrasena = document.getElementById('confirmarContrasena');
    const telefono = document.getElementById('telefono');
    const regexSoloLetras = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/;
    // Permite letras, números, puntos, guiones y exige formato correcto con @ y .
    const regexCorreo = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    // Solo números exactos del 0 al 9
    const regexSoloNumeros = /^[0-9]+$/;

    // no deja espacios vacios
    const campos = [nombre, apellidoPaterno, apellidoMaterno, correo, contrasena, confirmarContrasena, telefono];
    for (let campo of campos) {
        if (campo.value.trim() === "") {
            alert(`Por favor, complete el campo: ${campo.placeholder}`);
            campo.focus();
            return;
        }
    }

    // comprobacion de nombre y apellidos
    const camposTexto = [
        { elemento: nombre, nombreCampo: "Nombre(s)" },
        { elemento: apellidoPaterno, nombreCampo: "Apellido paterno" },
        { elemento: apellidoMaterno, nombreCampo: "Apellido materno" }
    ];

    for (let campo of camposTexto) {
        if (!regexSoloLetras.test(campo.elemento.value)) {
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

    // comprobacion de correo
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

    // comprobacion de telefono
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

    //verificar contraseñas iguales
    if (contrasena.value !== confirmarContrasena.value) {
        alert("Las contraseñas ingresadas no coinciden.");
        confirmarContrasena.focus();
        return;
    }

    //validaciones exitosamente
    alert("¡Validación exitosa! Procediendo al registro del maestro.");
    this.submit(); // Envía el formulario al backend/Servlet

});