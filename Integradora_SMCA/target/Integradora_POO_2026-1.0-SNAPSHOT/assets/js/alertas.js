/*
 * Función: confirmarCierreSesion
 * Objetivo: Mostrar alerta de confirmación antes de cerrar sesión
 * Parámetros:
 *   - event: evento del botón/enlace
 *   - urlRedireccion: URL opcional para redirigir al cerrar sesión
 */
function confirmarCierreSesion(event, urlRedireccion) {
    if (event) event.preventDefault();

    Swal.fire({
        title: 'Cierre de sesión',
        text: '¿Estás seguro de que quieres cerrar sesión?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Aceptar',
        cancelButtonText: 'Cancelar',
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

/*
 * Función: confirmarValidacionIncidencia
 * Objetivo: Validar si una incidencia es verídica antes de enviarla
 * Parámetros:
 *   - event: evento del botón
 *   - formElement: formulario que se enviará si se confirma
 */
function confirmarValidacionIncidencia(event, formElement) {
    if (event) event.preventDefault();

    Swal.fire({
        title: '¿La incidencia es verídica?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Si, validar',
        cancelButtonText: 'No',
        customClass: {
            popup: 'figma-modal',
            title: 'figma-title',
            confirmButton: 'figma-btn-confirm',
            cancelButton: 'figma-btn-cancel'
        }
    }).then((result) => {
        if (result.isConfirmed && formElement) {
            formElement.submit();
        }
    });
}

/*
 * Función: confirmarRegistroMaestro
 * Objetivo: Mostrar alerta de éxito al registrar un maestro
 * Parámetros:
 *   - event: evento del botón
 *   - formElement: formulario que se enviará si es válido
 */
function confirmarRegistroMaestro(event, formElement) {
    if (event) event.preventDefault();

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
        if (result.isConfirmed && formElement) {
            formElement.submit();
        }
    });
}

/*
 * Función: mostrarAlertaExito
 * Objetivo: Mostrar alerta de confirmación exitosa
 * Parámetros:
 *   - mensaje: texto personalizado
 *   - callback: función opcional a ejecutar tras confirmar
 */
function mostrarAlertaExito(mensaje, callback) {
    Swal.fire({
        title: mensaje || '¡Cambios realizados de manera exitosa!',
        icon: 'success',
        iconColor: '#28a745',
        confirmButtonText: 'Aceptar',
        confirmButtonColor: '#0b8a72',
        customClass: {
            popup: 'modal-alerta-custom',
            confirmButton: 'btn-confirmar-custom'
        },
        allowOutsideClick: false
    }).then((result) => {
        if (result.isConfirmed && typeof callback === 'function') {
            callback();
        }
    });
}

/*
 * Función: mostrarAlertaError
 * Objetivo: Mostrar alerta de error en caso de fallo
 * Parámetros:
 *   - mensaje: texto personalizado del error
 */
function mostrarAlertaError(mensaje) {
    Swal.fire({
        title: '¡Ocurrió un error!',
        text: mensaje || 'No se pudieron guardar los cambios. Inténtalo de nuevo.',
        icon: 'error',
        iconColor: '#dc3545',
        confirmButtonText: 'Aceptar',
        confirmButtonColor: '#0b8a72',
        customClass: {
            popup: 'modal-alerta-custom',
            confirmButton: 'btn-confirmar-custom'
        }
    });
}

/*
 * Función: mostrarAlertaBienvenida
 * Objetivo: Mostrar alerta de bienvenida con reloj en tiempo real
 * Parámetros:
 *   - nombreUsuario: nombre del usuario autenticado
 *   - contextPath: ruta base de la aplicación
 */
function mostrarAlertaBienvenida(nombreUsuario, contextPath) {
    Swal.fire({
        title: '<i class="bi bi-clock-history me-1"></i> Bienvenida UTEZ',
        html: `
            <div class="text-start">
                <h6 class="fw-bold text-dark mb-1">¡Hola, ${nombreUsuario}!</h6>
                <p class="text-muted small mb-2" style="font-size: 12px;">Acceso rápido a tus opciones principales:</p>
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

/*
 * Función auxiliar: iniciarReloj
 * Objetivo: Actualizar cada segundo la hora y fecha en la alerta de bienvenida
 */
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
