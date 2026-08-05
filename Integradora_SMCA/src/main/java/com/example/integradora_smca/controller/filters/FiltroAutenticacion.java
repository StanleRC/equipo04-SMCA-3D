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

        boolean loggedIn = session != null && session.getAttribute("usuarioLogueado") != null;

        boolean publicPage = requestURI.endsWith("/index.jsp")
                || requestURI.endsWith("/admin-docente_login.jsp")
                || requestURI.endsWith("/recuperar_pass.jsp")
                || requestURI.endsWith("/LoginServlet")
                || requestURI.endsWith("/RegistroAlumnoServlet")
                || requestURI.endsWith("/RecuperarPassServlet")
                || requestURI.endsWith("/views/alumno/registro_directo_alumno.jsp")
                || requestURI.endsWith("/views/admin/registro_directo_maestro.jsp")
                || requestURI.endsWith("/registrarMaestroServlet");

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

        if (loggedIn) {
            if (publicPage) {
                response.sendRedirect(request.getContextPath() + "/views/alumno/crear_incidencia_alumno.jsp");
            } else {
                chain.doFilter(request, response);
            }
        } else {
            if (publicPage || resourceRequest) {
                chain.doFilter(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        }
    }
}
