package com.example.integradora_smca.controller.filters;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class FiltroAutenticacion extends HttpFilter {

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        String requestURI = request.getRequestURI();
        HttpSession session = request.getSession(false);

        // EVALUACIÓN DE SESIÓN FLEXIBLE (Docente, Alumno o Usuario genérico)
        boolean loggedIn = session != null && (
                session.getAttribute("usuarioLogueado") != null ||
                        session.getAttribute("docenteLogueado") != null ||
                        session.getAttribute("usuario") != null
        );

        // RUTAS PÚBLICAS Y PERMISOS DE ENTRADA
        boolean publicPage = requestURI.endsWith("/index.jsp")
                || requestURI.endsWith("/admin-docente_login.jsp")
                || requestURI.endsWith("/recuperar_pass.jsp")
                || requestURI.contains("/loginServlet")
                || requestURI.contains("/loginDocenteServlet")
                || requestURI.contains("/RegistroAlumnoServlet")
                || requestURI.contains("/RegistroDocenteServlet")
                || requestURI.contains("/RecuperarPassServlet")
                || requestURI.endsWith("/views/alumno/registro_directo_alumno.jsp")
                || requestURI.endsWith("/views/admin/registro_directo_maestro.jsp")
                || requestURI.contains("/registrarMaestroServlet");

        // RECURSOS ESTÁTICOS (CSS, JS, Imágenes)
        boolean resourceRequest = requestURI.contains("/assets/")
                || requestURI.endsWith(".css")
                || requestURI.endsWith(".js")
                || requestURI.endsWith(".png")
                || requestURI.endsWith(".jpg")
                || requestURI.endsWith(".jpeg")
                || requestURI.endsWith(".svg")
                || requestURI.endsWith(".woff")
                || requestURI.endsWith(".woff2")
                || requestURI.endsWith(".ttf")
                || requestURI.endsWith(".ico");

        if (loggedIn || publicPage || resourceRequest) {
            chain.doFilter(request, response);
        } else {
            // Si intenta entrar a una vista privada sin sesión, redirige al login
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}