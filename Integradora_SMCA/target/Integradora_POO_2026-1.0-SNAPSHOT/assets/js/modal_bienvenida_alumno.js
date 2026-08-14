document.addEventListener('DOMContentLoaded', () => {
    // 1. Obtener los datos inyectados desde JSP
    const nombreUsuario = window.APP_CONFIG?.usuarioNombre;
    const contextPath = window.APP_CONFIG?.contextPath || '';

    // Validar si el usuario ha iniciado sesión (Si no hay sesión, no muestra el widget)
    if (!nombreUsuario || nombreUsuario === "" || nombreUsuario === "null" || nombreUsuario === "undefined") {
        return;
    }

    // 2. Estilos CSS dinámicos (Incluyendo estilos de arrastre)
    const styles = `
        .widget-bienvenida-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 320px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            z-index: 9999;
            overflow: hidden;
            font-family: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
            animation: slideInWidget 0.4s ease-out;
            user-select: none;
        }

        @keyframes slideInWidget {
            from { transform: translateY(50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .widget-header-utez {
            background-color: #00875a;
            color: white;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: grab; /* Indica que se puede arrastrar */
        }

        .widget-header-utez:active {
            cursor: grabbing; /* Cambia el icono del cursor mientras se sostiene */
        }

        .widget-body-utez {
            padding: 20px;
            text-align: center;
        }

        .widget-time-box {
            background-color: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 8px 12px;
            color: #00875a;
            font-weight: 600;
            font-size: 0.88rem;
            margin: 12px 0 18px 0;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .btn-incidencia-utez {
            background-color: #dc2626;
            color: white !important;
            border: none;
            border-radius: 10px;
            padding: 10px 16px;
            font-weight: 600;
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
            transition: background-color 0.2s;
        }

        .btn-incidencia-utez:hover {
            background-color: #b91c1c;
        }

        .btn-close-widget {
            background: transparent;
            border: none;
            color: white;
            font-size: 1.2rem;
            cursor: pointer;
            line-height: 1;
            opacity: 0.8;
            padding: 0 4px;
        }

        .btn-close-widget:hover {
            opacity: 1;
        }
    `;

    // Insertar estilos en la cabecera
    const styleSheet = document.createElement("style");
    styleSheet.innerText = styles;
    document.head.appendChild(styleSheet);

    // 3. Crear el elemento HTML del Widget
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

    // 4. Inyectarlo en el DOM
    document.body.appendChild(widget);

    // Evento de Cierre
    document.getElementById('btnCerrarWidgetFlotante').addEventListener('click', (e) => {
        e.stopPropagation(); // Evitar disparar el arrastre al hacer clic en cerrar
        widget.remove();
    });

    // 5. Iniciar Reloj Dinámico
    iniciarRelojWidget();

    // 6. HACER EL WIDGET ARRASTRABLE (DRAGGABLE)
    hacerMovible(widget, document.getElementById('widgetHeaderDrag'));
});

// Función para permitir mover el recuadro con el mouse o pantalla táctil
function hacerMovible(elementoWidget, elementoBarra) {
    let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

    elementoBarra.onmousedown = arrastrarInicio;
    elementoBarra.ontouchstart = arrastrarInicioTouch;

    function arrastrarInicio(e) {
        if (e.target.classList.contains('btn-close-widget')) return;
        e.preventDefault();

        // Eliminar bottom/right para cambiar la posición a top/left dinámica
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

        // Limitar dentro de la ventana visible
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

    // Soporte para dispositivos móviles / táctiles
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

        let nuevoTop = elementoWidget.offsetTop - pos2;
        let nuevoLeft = elementoWidget.offsetLeft - pos1;

        elementoWidget.style.top = nuevoTop + "px";
        elementoWidget.style.left = nuevoLeft + "px";
    }

    function detenerArrastreTouch() {
        document.ontouchend = null;
        document.ontouchmove = null;
    }
}

// Reloj continuo en tiempo real
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