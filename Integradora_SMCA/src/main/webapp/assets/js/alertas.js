// 1. Alerta para Cerrar Sesión
function confirmarCierreSesion(event, urlRedireccion) {
    if (event) event.preventDefault();

    Swal.fire({
        title: 'Cierre de sesión',
        text: '¿Estás seguro de que quieres cerrar sesión?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Aceptar',
        cancelButtonText: 'Cancelar',
        reverseButtons: false,
        customClass: {
            popup: 'figma-modal',
            title: 'figma-title',
            htmlContainer: 'figma-text',
            confirmButton: 'figma-btn-confirm',
            cancelButton: 'figma-btn-cancel',
            icon: 'figma-icon-warning'
        }
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = urlRedireccion || 'index.jsp';
        }
    });
}

// 2. Alerta para Validar Incidencia
function confirmarValidacionIncidencia(event, formElement) {
    if (event) event.preventDefault();

    Swal.fire({
        title: '¿La incidencia es verídica?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Si, validar',
        cancelButtonText: 'No',
        reverseButtons: false,
        customClass: {
            popup: 'figma-modal',
            title: 'figma-title',
            confirmButton: 'figma-btn-confirm',
            cancelButton: 'figma-btn-cancel'
        }
    }).then((result) => {
        if (result.isConfirmed) {
            if (formElement) {
                formElement.submit();
            }
        }
    });
}
// Resgistro exitoso
function confirmarRegistroMaestro(event, formElement) {
    if (event) event.preventDefault();

    // Validar que los campos HTML5 (required) estén llenos
    if (formElement && !formElement.checkValidity()) {
        formElement.reportValidity();
        return;
    }

    Swal.fire({
        title: '¡Registro realizado de manera exitosa!',
        icon: 'success',
        confirmButtonText: 'Aceptar',
        customClass: {
            popup: 'figma-modal',
            title: 'figma-title',
            confirmButton: 'figma-btn-confirm'
        }
    }).then((result) => {
        if (result.isConfirmed) {
            if (formElement) {
                formElement.submit();
            }
        }
    });
}

// 1. Alerta de ÉXITO
function mostrarAlertaExito(mensaje, callback) {
    Swal.fire({
        title: mensaje || '¡Cambios realizados de manera exitosa!',
        icon: 'success',
        iconColor: '#28a745',          // Verde del check
        confirmButtonText: 'Aceptar',
        confirmButtonColor: '#0b8a72',  // Verde UTEZ
        customClass: {
            popup: 'modal-alerta-custom',
            confirmButton: 'btn-confirmar-custom'
        },
        buttonsStyling: true,
        allowOutsideClick: false
    }).then((result) => {
        if (result.isConfirmed && typeof callback === 'function') {
            callback();
        }
    });
}

// 2. Alerta de ERROR (Por si algo falla)
function mostrarAlertaError(mensaje) {
    Swal.fire({
        title: '¡Ocurrió un error!',
        text: mensaje || 'No se pudieron guardar los cambios. Inténtalo de nuevo.',
        icon: 'error',
        iconColor: '#dc3545',          // Rojo de error
        confirmButtonText: 'Aceptar',
        confirmButtonColor: '#0b8a72',  // Mantener el botón institucional
        customClass: {
            popup: 'modal-alerta-custom',
            confirmButton: 'btn-confirmar-custom'
        },
        buttonsStyling: true
    });
}