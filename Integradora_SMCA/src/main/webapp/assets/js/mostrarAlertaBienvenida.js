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