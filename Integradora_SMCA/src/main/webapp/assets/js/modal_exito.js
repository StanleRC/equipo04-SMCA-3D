/*
 * Script: Modal de Login Exitoso
 * Objetivo: Mostrar un modal de confirmación cuando el usuario inicia sesión correctamente.
 * Detalles:
 *   - Se ejecuta al cargar el DOM.
 *   - Solo se activa si el modal existe en el documento (controlado por la sesión).
 */
document.addEventListener("DOMContentLoaded", function () {
    // Referencias a elementos del DOM
    const modalElement = document.getElementById('modalLoginExitoso');
    const btnAceptar = document.getElementById('btnAceptarModal');

    /*
     * Validar existencia del modal:
     * Si existe, se instancia y se muestra automáticamente.
     */
    if (modalElement) {
        const modalInstance = new bootstrap.Modal(modalElement);
        modalInstance.show();

        /*
         * Evento: botón "Aceptar"
         * Objetivo: cerrar el modal cuando el usuario confirme.
         */
        if (btnAceptar) {
            btnAceptar.addEventListener('click', function () {
                modalInstance.hide();
            });
        }
    }
});
