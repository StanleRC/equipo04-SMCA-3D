/*
 * Script: Modal "About"
 * Objetivo: Controlar la apertura y cierre de un modal informativo
 * Detalles:
 *   - Se ejecuta al cargar el DOM.
 *   - Permite abrir el modal con un botón, cerrarlo con otro,
 *     o cerrarlo haciendo clic en el fondo oscuro.
 */
document.addEventListener('DOMContentLoaded', function() {
    // Referencias a los elementos del DOM
    const modal = document.getElementById('aboutModal');
    const openBtn = document.getElementById('openModalBtn');
    const closeBtn = document.getElementById('closeModalBtn');

    /*
     * Validar existencia de los elementos:
     * Solo se activa si el modal y los botones están presentes en el DOM.
     */
    if (modal && openBtn && closeBtn) {
        /*
         * Evento: abrir modal
         * Objetivo: mostrar la ventana emergente sobre toda la pantalla
         */
        openBtn.addEventListener('click', function(e) {
            e.preventDefault();
            modal.style.display = 'flex';
        });

        /*
         * Evento: cerrar modal con botón
         */
        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        /*
         * Evento: cerrar modal al hacer clic en el fondo oscuro
         */
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
});
