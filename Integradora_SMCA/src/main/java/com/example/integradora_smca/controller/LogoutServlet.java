package com.example.integradora_smca.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener la sesión actual (si existe)
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Limpiar explícitamente todas las variables de sesión antes de invalidar
            session.removeAttribute("usuarioLogueado");
            session.removeAttribute("docenteLogueado");
            session.removeAttribute("usuario");
            session.removeAttribute("alumno");
            session.removeAttribute("docente");
            session.removeAttribute("alumnoTemporal");
            session.removeAttribute("docenteTemporal");

            // Invalidar la sesión completamente
            session.invalidate();

            // Registrar logout en consola para auditoría
            System.out.println("[LOGOUT] Sesión invalidada exitosamente");
        }

        // Establecer headers para evitar caché de navegador en páginas protegidas
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        // Redirigir al index.jsp (página de login)
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
