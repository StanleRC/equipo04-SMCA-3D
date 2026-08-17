document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('aboutModal');
    const openBtn = document.getElementById('openModalBtn');
    const closeBtn = document.getElementById('closeModalBtn');

    if (modal && openBtn && closeBtn) {
        // Abrir ventana emergente sobre toda la pantalla
        openBtn.addEventListener('click', function(e) {
            e.preventDefault();
            modal.style.display = 'flex';
        });

        // Cerrar con botón
        closeBtn.addEventListener('click', function() {
            modal.style.display = 'none';
        });

        // Cerrar haciendo clic en cualquier parte oscura del fondo
        window.addEventListener('click', function(event) {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    }
});