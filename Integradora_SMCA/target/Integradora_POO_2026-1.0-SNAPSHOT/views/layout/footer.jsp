<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Estilos del Footer con alineación milimétrica -->
<style>
    .app-footer {
        background-color: #ffffff;
        border-top: 1px solid #e2e8f0;
        padding-top: 16px;
        padding-bottom: 16px;

        /* Ocupa el área blanca restante después del sidebar de 240px */
        margin-left: 240px;
        width: calc(100% - 240px);

        text-align: center; /* Centra el texto exactamente al medio de la zona blanca */
        box-sizing: border-box;
    }

    .app-footer small {
        color: #64748b;
        font-size: 13.5px;
        font-weight: 500;
        display: block;
    }
</style>

<footer class="app-footer">
    <small>&copy; 2026 Integradora SMCA - Universidad Tecnológica del Estado de Morelos</small>
</footer>

<!-- Cierre único del contenedor principal -->
</div> <!-- Cierre de <div class="main-wrapper"> -->

<!-- Bootstrap 5.3 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>