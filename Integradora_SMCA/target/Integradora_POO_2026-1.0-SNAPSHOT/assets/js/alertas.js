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
            window.location.href = urlRedireccion || '/logoutServlet';
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

function mostrarAlertaBienvenida(nombreUsuario, contextPath) {
    Swal.fire({
        title: '<i class="bi bi-clock-history me-1"></i> Bienvenida UTEZ',
        html: `
            <div class="text-start">
                <h6 class="fw-bold text-dark mb-1">¡Hola, ${nombreUsuario}!</h6>
                <p class="text-muted small mb-2" style="font-size: 12px;">Acceso rápido a tus opciones principales:</p>

                <!-- Reloj y Fecha -->
                <div class="alert alert-light border py-2 px-2 my-2 text-success fw-semibold shadow-sm text-center" style="font-size: 13px;">
                    <i class="bi bi-clock me-1"></i>
                    <span id="relojServidor">Cargando hora...</span>
                </div>
            </div>
        `,
        showConfirmButton: true,
        confirmButtonText: '<i class="bi bi-exclamation-triangle-fill me-1"></i> Registrar incidencia',
        confirmButtonColor: '#dc2626',
        showCloseButton: true,
        focusConfirm: false,
        customClass: {
            popup: 'rounded-4 shadow-lg',
            title: 'fs-6 text-white bg-dark p-3 m-0 rounded-top-4 text-start',
            confirmButton: 'btn btn-danger w-100 py-2 fw-semibold mt-2'
        },
        didOpen: () => {
            iniciarReloj();
        }
    }).then((result) => {
        if (result.isConfirmed) {
            window.location.href = contextPath + "/views/alumno/crear_incidencia_alumno.jsp";
        }
    });
}

// Función auxiliar para el reloj en tiempo real
function iniciarReloj() {
    function actualizarHora() {
        const spanReloj = document.getElementById('relojServidor');
        if (spanReloj) {
            const ahora = new Date();
            const opcionesFecha = { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' };
            const fechaFormateada = ahora.toLocaleDateString('es-ES', opcionesFecha);
            const horaFormateada = ahora.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit', second: '2-digit' });

            spanReloj.textContent = `${fechaFormateada} - ${horaFormateada}`;
        }
    }
    actualizarHora();
    setInterval(actualizarHora, 1000);
}



