document.addEventListener("DOMContentLoaded", function () {
    const modalElement = document.getElementById('modalLoginExitoso');
    const btnAceptar = document.getElementById('btnAceptarModal');

    if (modalElement) {
        // Inicializar el modal con Bootstrap
        const modalInstance = new bootstrap.Modal(modalElement);

        // Abrir el modal automáticamente al cargar
        modalInstance.show();

        // Evento para cerrar la ventana emergente al hacer clic en Aceptar
        if (btnAceptar) {
            btnAceptar.addEventListener('click', function () {
                modalInstance.hide();
            });
        }
    }
});