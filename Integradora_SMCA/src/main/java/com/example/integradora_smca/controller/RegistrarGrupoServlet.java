package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.UsuarioPersonal;
import com.example.integradora_smca.model.dao.GrupoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Da de alta un grupo. Este servlet no existía: registro_grupo.jsp apuntaba a
 * "RegistrarGrupoServlet" y el formulario terminaba en un 404.
 *
 * Solo el administrador puede crear grupos. FiltroSoloAdmin ya cubre esta ruta,
 * pero la comprobación se repite aquí: si mañana alguien cambia el filtro, el
 * candado no debería depender de eso.
 */
@WebServlet("/RegistrarGrupoServlet")
public class RegistrarGrupoServlet extends HttpServlet {

    private GrupoDao grupoDao;

    private static final String VISTA = "/views/admin/registro_grupo.jsp";

    @Override
    public void init() throws ServletException {
        grupoDao = new GrupoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VISTA).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        if (!esAdministrador(session)) {
            redirigir(request, response, "error", "Solo el administrador puede crear grupos.");
            return;
        }

        String carrera = limpiar(request.getParameter("txtCarrera"));
        String grado = limpiar(request.getParameter("txtCuatrimestre"));
        String letra = limpiar(request.getParameter("txtGrupo"));

        if (carrera == null || grado == null || letra == null) {
            redirigir(request, response, "error", "Completa todos los campos.");
            return;
        }

        // El grado es el cuatrimestre: un número del 1 al 11 en la UTEZ.
        int gradoNumero;
        try {
            gradoNumero = Integer.parseInt(grado);
        } catch (NumberFormatException e) {
            redirigir(request, response, "error", "El cuatrimestre debe ser un número.");
            return;
        }

        if (gradoNumero < 1 || gradoNumero > 11) {
            redirigir(request, response, "error", "El cuatrimestre debe estar entre 1 y 11.");
            return;
        }

        // La letra identifica al grupo dentro del cuatrimestre: A, B, C...
        if (!letra.matches("[A-Za-zÑñ]")) {
            redirigir(request, response, "error", "El grupo debe ser una sola letra.");
            return;
        }

        String idGenerado = grupoDao.crearGrupo(carrera, String.valueOf(gradoNumero), letra);

        if (idGenerado == null) {
            redirigir(request, response, "error",
                    "No se pudo crear el grupo. Puede que ya exista.");
            return;
        }

        redirigir(request, response, "exito", "Grupo " + idGenerado + " creado correctamente.");
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

    private String limpiar(String valor) {
        if (valor == null) return null;
        String limpio = valor.trim();
        return limpio.isEmpty() ? null : limpio;
    }

    /** Redirect y no forward: si el usuario recarga, no se duplica el grupo. */
    private void redirigir(HttpServletRequest request, HttpServletResponse response,
                           String tipo, String mensaje) throws IOException {
        response.sendRedirect(request.getContextPath() + VISTA
                + "?" + tipo + "=" + codificar(mensaje));
    }

    private String codificar(String texto) {
        try {
            return URLEncoder.encode(texto, StandardCharsets.UTF_8.name());
        } catch (UnsupportedEncodingException e) {
            return "";
        }
    }
}