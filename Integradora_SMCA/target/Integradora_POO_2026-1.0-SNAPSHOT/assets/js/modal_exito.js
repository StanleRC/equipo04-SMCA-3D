document.addEventListener("DOMContentLoaded", function () {
    const modalElement = document.getElementById('modalLoginExitoso');
    const btnAceptar = document.getElementById('btnAceptarModal');

    // Solo se ejecuta SI el modal existe en el DOM (cuando la variable de sesión existía)
    if (modalElement) {
        const modalInstance = new bootstrap.Modal(modalElement);
        modalInstance.show();

        if (btnAceptar) {
            btnAceptar.addEventListener('click', function () {
                modalInstance.hide();
            });
        }
    }
});