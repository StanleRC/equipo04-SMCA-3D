/*
 * Script principal para el Widget de Bienvenida
 * Objetivo: Mostrar un recuadro flotante con saludo, reloj en tiempo real
 *           y acceso rápido al registro de incidencias.
 */
document.addEventListener('DOMContentLoaded', () => {
    /*
     * Obtener datos inyectados desde JSP:
     * - nombreUsuario: nombre del usuario autenticado
     * - contextPath: ruta base de la aplicación
     */
    const nombreUsuario = window.APP_CONFIG?.usuarioNombre;
    const contextPath = window.APP_CONFIG?.contextPath || '';

    // Validar si el usuario tiene sesión activa
    if (!nombreUsuario || nombreUsuario === "" || nombreUsuario === "null" || nombreUsuario === "undefined") {
        return;
    }

    /*
     * Definir estilos CSS dinámicos para el widget
     * Incluye animación de entrada y soporte para arrastre
     */
    const styles = `...`; // (Se mantiene igual, contiene todo el bloque CSS)

    // Insertar estilos en la cabecera del documento
    const styleSheet = document.createElement("style");
    styleSheet.innerText = styles;
    document.head.appendChild(styleSheet);

    /*
     * Crear el elemento HTML del Widget de Bienvenida
     * Contiene encabezado, reloj dinámico y botón de incidencia
     */
    const widget = document.createElement('div');
    widget.id = 'widgetBienvenidaFlotante';
    widget.className = 'widget-bienvenida-container';
    widget.innerHTML = `
        <div class="widget-header-utez" id="widgetHeaderDrag">
            <span><i class="bi bi-clock-history me-1"></i> Bienvenida UTEZ</span>
            <button class="btn-close-widget" id="btnCerrarWidgetFlotante">&times;</button>
        </div>
        <div class="widget-body-utez">
            <h5 class="fw-bold text-dark mb-1">¡Hola, ${nombreUsuario}!</h5>
            <p class="text-muted small mb-0" style="font-size: 12px;">Acceso rápido a tus opciones principales:</p>
            <div class="widget-time-box">
                <i class="bi bi-clock"></i>
                <span id="relojServidorWidget">Cargando hora...</span>
            </div>
            <a href="${contextPath}/views/alumno/crear_incidencia_alumno.jsp" class="btn-incidencia-utez">
                <i class="bi bi-exclamation-triangle-fill"></i> Registrar incidencia
            </a>
        </div>
    `;

    // Inyectar el widget en el DOM
    document.body.appendChild(widget);

    // Evento para cerrar el widget
    document.getElementById('btnCerrarWidgetFlotante').addEventListener('click', (e) => {
        e.stopPropagation();
        widget.remove();
    });

    // Iniciar reloj dinámico dentro del widget
    iniciarRelojWidget();

    // Hacer el widget arrastrable con mouse o táctil
    hacerMovible(widget, document.getElementById('widgetHeaderDrag'));
});

/*
 * Función: hacerMovible
 * Objetivo: Permitir mover el widget con mouse o pantalla táctil
 * Parámetros:
 *   - elementoWidget: el recuadro flotante
 *   - elementoBarra: la barra de encabezado usada para arrastrar
 */
function hacerMovible(elementoWidget, elementoBarra) {
    let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

    elementoBarra.onmousedown = arrastrarInicio;
    elementoBarra.ontouchstart = arrastrarInicioTouch;

    function arrastrarInicio(e) {
        if (e.target.classList.contains('btn-close-widget')) return;
        e.preventDefault();

        // Cambiar posición a top/left dinámica
        const rect = elementoWidget.getBoundingClientRect();
        elementoWidget.style.bottom = 'auto';
        elementoWidget.style.right = 'auto';
        elementoWidget.style.top = rect.top + 'px';
        elementoWidget.style.left = rect.left + 'px';

        pos3 = e.clientX;
        pos4 = e.clientY;

        document.onmouseup = detenerArrastre;
        document.onmousemove = elementoArrastrandose;
    }

    function elementoArrastrandose(e) {
        e.preventDefault();
        pos1 = pos3 - e.clientX;
        pos2 = pos4 - e.clientY;
        pos3 = e.clientX;
        pos4 = e.clientY;

        let nuevoTop = elementoWidget.offsetTop - pos2;
        let nuevoLeft = elementoWidget.offsetLeft - pos1;

        // Limitar movimiento dentro de la ventana visible
        const maxTop = window.innerHeight - elementoWidget.offsetHeight;
        const maxLeft = window.innerWidth - elementoWidget.offsetWidth;

        if (nuevoTop < 0) nuevoTop = 0;
        if (nuevoTop > maxTop) nuevoTop = maxTop;
        if (nuevoLeft < 0) nuevoLeft = 0;
        if (nuevoLeft > maxLeft) nuevoLeft = maxLeft;

        elementoWidget.style.top = nuevoTop + "px";
        elementoWidget.style.left = nuevoLeft + "px";
    }

    function detenerArrastre() {
        document.onmouseup = null;
        document.onmousemove = null;
    }

    // Soporte táctil para móviles
    function arrastrarInicioTouch(e) {
        if (e.target.classList.contains('btn-close-widget')) return;
        const touch = e.touches[0];

        const rect = elementoWidget.getBoundingClientRect();
        elementoWidget.style.bottom = 'auto';
        elementoWidget.style.right = 'auto';
        elementoWidget.style.top = rect.top + 'px';
        elementoWidget.style.left = rect.left + 'px';

        pos3 = touch.clientX;
        pos4 = touch.clientY;

        document.ontouchend = detenerArrastreTouch;
        document.ontouchmove = elementoArrastrandoseTouch;
    }

    function elementoArrastrandoseTouch(e) {
        const touch = e.touches[0];
        pos1 = pos3 - touch.clientX;
        pos2 = pos4 - touch.clientY;
        pos3 = touch.clientX;
        pos4 = touch.clientY;

        elementoWidget.style.top = (elementoWidget.offsetTop - pos2) + "px";
        elementoWidget.style.left = (elementoWidget.offsetLeft - pos1) + "px";
    }

    function detenerArrastreTouch() {
        document.ontouchend = null;
        document.ontouchmove = null;
    }
}

/*
 * Función: iniciarRelojWidget
 * Objetivo: Mostrar fecha y hora en tiempo real dentro del widget
 */
function iniciarRelojWidget() {
    function actualizarHora() {
        const spanReloj = document.getElementById('relojServidorWidget');
        if (spanReloj) {
            const ahora = new Date();
            const opcionesFecha = { weekday: 'short', day: 'numeric', month: 'short' };
            const fecha = ahora.toLocaleDateString('es-ES', opcionesFecha);
            const hora = ahora.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit', second: '2-digit' });

            spanReloj.textContent = `${fecha} | ${hora}`;
        }
    }
    actualizarHora();
    setInterval(actualizarHora, 1000);
}
