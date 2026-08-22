package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.UsuarioPersonal;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Alimenta /views/admin/buscador.jsp.
 *
 * Responde de dos formas según el parámetro "formato":
 *   sin formato   -> forward normal al JSP (primera carga de la página)
 *   formato=json  -> devuelve la lista en JSON, para la búsqueda en vivo
 *
 * Así el cuadro de búsqueda filtra mientras se escribe, sin recargar la página
 * y sin duplicar la consulta en otro servlet.
 *
 * IMPORTANTE: en el sidebar, el enlace de "Buscar" debe apuntar a
 *   ${pageContext.request.contextPath}/BuscarAlumnosServlet
 * y NO a /views/admin/buscador.jsp.
 */
@WebServlet("/BuscarAlumnosServlet")
public class BuscarAlumnosServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Sin esto, los acentos y las ñ del cuadro de búsqueda llegan rotos.
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            responderSinSesion(request, response);
            return;
        }

        String termino = request.getParameter("q");
        termino = (termino == null) ? "" : termino.trim();

        List<Map<String, Object>> listaAlumnos = alumnoDao.buscarAlumnos(termino);

        if ("json".equalsIgnoreCase(request.getParameter("formato"))) {
            responderJson(response, listaAlumnos);
            return;
        }

        request.setAttribute("listaAlumnos", listaAlumnos);
        request.setAttribute("terminoBusqueda", termino);
        request.setAttribute("esAdmin", esAdministrador(session));

        request.getRequestDispatcher("/views/admin/buscador.jsp")
                .forward(request, response);
    }

    /**
     * Un fetch espera JSON. Si le devolvemos una redirección a index.jsp,
     * res.json() lanza excepción y el usuario no entiende qué pasó.
     */
    private void responderSinSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if ("json".equalsIgnoreCase(request.getParameter("formato"))) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().print("{\"error\":\"sesion\"}");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    private void responderJson(HttpServletResponse response, List<Map<String, Object>> lista)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < lista.size(); i++) {
            Map<String, Object> a = lista.get(i);

            if (i > 0) json.append(',');

            json.append('{')
                    .append(campo("matricula", a.get("matricula"))).append(',')
                    .append(campo("nombreCompleto", a.get("nombreCompleto"))).append(',')
                    .append(campo("grado", a.get("grado"))).append(',')
                    .append(campo("grupo", a.get("grupo"))).append(',')
                    .append(campo("carrera", a.get("carrera"))).append(',')
                    .append(campo("correo", a.get("correo"))).append(',')
                    .append(campo("activo", a.get("activo")))
                    .append('}');
        }

        json.append(']');

        try (PrintWriter out = response.getWriter()) {
            out.print(json);
        }
    }

    private String campo(String clave, Object valor) {
        return "\"" + clave + "\":\"" + escapar(valor == null ? "" : String.valueOf(valor)) + "\"";
    }

    /** Escapa lo que rompería el JSON. Los nombres y correos son datos de usuario. */
    private String escapar(String texto) {
        StringBuilder sb = new StringBuilder(texto.length() + 16);

        for (int i = 0; i < texto.length(); i++) {
            char c = texto.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }

    /** Mismo criterio que el sidebar: un solo lugar decide qué es ser admin. */
    private boolean esAdministrador(HttpSession session) {

        Object marca = session.getAttribute("esAdmin");
        if (marca instanceof Boolean) {
            return (Boolean) marca;
        }

        Object usuario = session.getAttribute("usuarioLogueado");
        if (usuario == null) usuario = session.getAttribute("docente");
        if (usuario == null) usuario = session.getAttribute("administrador");

        return (usuario instanceof UsuarioPersonal)
                && ((UsuarioPersonal) usuario).isAdministrador();
    }
}