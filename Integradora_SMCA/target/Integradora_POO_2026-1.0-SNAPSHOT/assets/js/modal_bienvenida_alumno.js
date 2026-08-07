document.addEventListener("DOMContentLoaded", function () {

    // 1. Reloj en tiempo real (Formato de fecha y hora en vivo)
    function actualizarReloj() {
        const ahora = new Date();
        const opcionesFecha = { weekday: 'short', month: 'short', day: 'numeric' };
        const fecha = ahora.toLocaleDateString('es-ES', opcionesFecha);
        const hora = ahora.toLocaleTimeString('es-ES');

        const fechaCapitalizada = fecha.charAt(0).toUpperCase() + fecha.slice(1);

        const spanReloj = document.getElementById('relojServidor');
        if (spanReloj) {
            spanReloj.innerText = `${fechaCapitalizada} | ${hora}`;
        }
    }

    actualizarReloj();
    setInterval(actualizarReloj, 1000);

    // 2. Garantiza que la tarjeta sea visible
    const widget = document.getElementById('widgetBienvenida');
    if (widget) {
        widget.style.display = 'block';
    }
});

// Función para cerrar la tarjeta flotante al hacer clic en la "X"
function cerrarWidget() {
    const widget = document.getElementById('widgetBienvenida');
    if (widget) {
        widget.style.display = 'none';
    }
}