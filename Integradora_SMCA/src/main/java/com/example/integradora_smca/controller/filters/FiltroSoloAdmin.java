package com.example.integradora_smca.controller.filters;

import com.example.integradora_smca.model.UsuarioPersonal;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Deja pasar SOLO a los administradores.
 *
 * Es un filtro aparte, mapeado únicamente a las pantallas de registro, para no
 * chocar con FiltroAutenticacion: ese resuelve "¿hay sesión?" y este "¿esa sesión
 * es de un admin?".
 *
 * Esconder los enlaces en el sidebar NO basta: cualquiera puede escribir la URL.
 * Este filtro es el candado; el sidebar solo es comodidad visual.
 *
 * Ahora pregunta por UsuarioPersonal, no por instanceof Docente. Así funciona
 * igual para un admin de la tabla ADMINISTRADOR que para uno de DOCENTE.
 */
@WebFilter(urlPatterns = {
        "/views/admin/crear_registro.jsp",
        "/views/admin/registrar_alumno.jsp",
        "/views/admin/registrar_maestro.jsp",
        "/views/admin/registro_directo_maestro.jsp",
        "/views/admin/registro_grupo.jsp",
        "/views/admin/agregar_salon.jsp",
        "/RegistrarAlumnoDocenteServlet",
        "/registrarMaestroServlet",
        "/RegistrarGrupoServlet"
})
public class FiltroSoloAdmin extends HttpFilter {

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        if (!esAdministrador(session)) {
            // No se manda al login: la persona sí inició sesión, solo que no le toca.
            response.sendRedirect(request.getContextPath()
                    + "/views/admin/bitacora.jsp?acceso=denegado");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean esAdministrador(HttpSession session) {

        // Camino normal: el login guarda esAdmin al autenticar.
        Object marca = session.getAttribute("esAdmin");
        if (marca instanceof Boolean) {
            return (Boolean) marca;
        }

        // Respaldo, por si la sesión viene de un login antiguo sin ese atributo.
        Object usuario = session.getAttribute("usuarioLogueado");
        if (usuario == null) usuario = session.getAttribute("docente");
        if (usuario == null) usuario = session.getAttribute("administrador");

        // Un alumno nunca implementa UsuarioPersonal, así que queda fuera solo.
        return (usuario instanceof UsuarioPersonal)
                && ((UsuarioPersonal) usuario).isAdministrador();
    }
}