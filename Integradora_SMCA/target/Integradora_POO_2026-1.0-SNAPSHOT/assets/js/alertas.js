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