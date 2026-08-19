package com.example.integradora_smca.controller.filters;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 * Filtro de autenticación.
 *
 * Tres decisiones que vale la pena recordar:
 *
 *  1. Se normaliza la ruta (se quita el context path y se pasa a minúsculas)
 *     antes de compararla. Así desaparece el problema de "/RecuperarPassServlet"
 *     vs "/recuperarPassServlet" sin tener que listar la ruta dos veces.
 *
 *  2. Se comparan rutas EXACTAS, no con contains(). Con contains(), una URL como
 *     /views/admin/panel.jsp;jsessionid=/index.jsp podía colarse.
 *
 *  3. Si la petición es AJAX, se responde 401 + JSON en lugar de redirigir.
 *     Antes el fetch recibía el HTML de index.jsp y reventaba en res.json().
 */
@WebFilter("/*")
public class FiltroAutenticacion extends HttpFilter {

    /**
     * Rutas accesibles sin sesión.
     *
     * SIEMPRE en minúsculas y sin context path: normalizarRuta() convierte la
     * ruta antes de comparar, así que "/CatalogosServlet" con mayúsculas nunca
     * coincidiría.
     */
    private static final Set<String> RUTAS_PUBLICAS = Set.of(
            "/",
            "/index.jsp",
            "/admin-docente_login.jsp",
            "/recuperar_pass.jsp",
            "/views/cambiar_password.jsp",
            "/views/alumno/registro_directo_alumno.jsp",
            "/views/admin/registro_directo_maestro.jsp",
            "/loginservlet",
            "/logindocenteservlet",
            "/logoutservlet",
            "/registroalumnoservlet",
            "/registrodocenteservlet",
            "/registrarmaestroservlet",
            "/recuperarpassservlet",

            // El registro de alumno es una pantalla pública y necesita la lista
            // de carreras y grupos antes de que exista una sesión.
            "/catalogosservlet"
    );

    /** Extensiones de recursos estáticos que nunca deben bloquearse. */
    private static final Set<String> EXTENSIONES_ESTATICAS = Set.of(
            ".css", ".js", ".map", ".png", ".jpg", ".jpeg", ".gif", ".svg",
            ".webp", ".ico", ".woff", ".woff2", ".ttf", ".eot"
    );

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        String ruta = normalizarRuta(request);
        HttpSession session = request.getSession(false);

        /*
         * Esta variable responde una sola pregunta: ¿hay un usuario dentro?
         * No debe mezclarse con rutas ni con permisos; para eso están
         * rutaPublica y los filtros de rol.
         */
        boolean sesionActiva = session != null && (
                session.getAttribute("usuarioLogueado") != null
                        || session.getAttribute("docenteLogueado") != null
                        || session.getAttribute("usuario") != null
                        || session.getAttribute("alumno") != null
                        || session.getAttribute("docente") != null
                        || session.getAttribute("administrador") != null
        );

        boolean rutaPublica = RUTAS_PUBLICAS.contains(ruta);
        boolean recursoEstatico = esRecursoEstatico(ruta);

        if (sesionActiva || rutaPublica || recursoEstatico) {

            // Las vistas con datos del usuario no deben quedar en caché del
            // navegador: evita que el botón "Atrás" muestre información
            // después de cerrar sesión.
            if (sesionActiva && ruta.startsWith("/views/")) {
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate, private");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);
            }

            chain.doFilter(request, response);
            return;
        }

        // ---------- acceso denegado ----------

        if (esPeticionAjax(request)) {
            // Un fetch espera JSON. Si le devolvemos una redirección a index.jsp,
            // res.json() lanza excepción y el usuario ve un error sin sentido.
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print(
                    "{\"status\":\"error\",\"message\":\"Tu sesión expiró. Vuelve a iniciar sesión.\"}");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    /** Devuelve la ruta sin context path, sin query string y en minúsculas. */
    private String normalizarRuta(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }

        // Tomcat puede añadir ";jsessionid=..." cuando el navegador no acepta cookies.
        int puntoYComa = uri.indexOf(';');
        if (puntoYComa >= 0) {
            uri = uri.substring(0, puntoYComa);
        }

        if (uri.isEmpty()) {
            uri = "/";
        }
        return uri.toLowerCase();
    }

    private boolean esRecursoEstatico(String ruta) {
        if (ruta.startsWith("/assets/")) return true;

        for (String ext : EXTENSIONES_ESTATICAS) {
            if (ruta.endsWith(ext)) return true;
        }
        return false;
    }

    private boolean esPeticionAjax(HttpServletRequest request) {
        String accept = request.getHeader("Accept");
        String requestedWith = request.getHeader("X-Requested-With");

        return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                || (accept != null && accept.contains("application/json"));
    }
}