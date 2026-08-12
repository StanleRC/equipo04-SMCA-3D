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
            // Si urlRedireccion viene vacía, manda por defecto al inicio
            window.location.href = urlRedireccion || 'index.jsp';
        }
    });
}