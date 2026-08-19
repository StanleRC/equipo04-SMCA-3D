package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.BitacoraDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Cierra la sesión del usuario.
 *
 * Si quien sale es un alumno, primero se graba su hora de salida en la bitácora.
 * Esa es la hora real en que dejó el equipo, a diferencia de la que antes elegía
 * a mano al entrar.
 */
@WebServlet("/logoutServlet")
public class LogoutServlet extends HttpServlet {

    private BitacoraDao bitacoraDao;

    @Override
    public void init() throws ServletException {
        bitacoraDao = new BitacoraDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cerrarSesion(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cerrarSesion(request, response);
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {

            // El orden importa: primero se lee la sesión, luego se invalida.
            String matricula = matriculaDeSesion(session);

            if (matricula != null) {
                boolean cerrada = bitacoraDao.cerrarSesionBitacora(matricula);

                if (cerrada) {
                    log("[Logout] Bitácora cerrada para la matrícula " + matricula);
                } else {
                    // No es error: puede que no tuviera ninguna sesión abierta.
                    log("[Logout] Sin bitácora abierta para la matrícula " + matricula);
                }
            }

            session.invalidate();
        }

        // El navegador no debe conservar en caché las pantallas privadas.
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        response.sendRedirect(request.getContextPath() + "/index.jsp?sesion=cerrada");
    }

    /** Devuelve la matrícula solo si quien sale es un alumno; null en otro caso. */
    private String matriculaDeSesion(HttpSession session) {

        Object usuario = session.getAttribute("usuarioLogueado");
        if (!(usuario instanceof Alumno)) {
            usuario = session.getAttribute("alumno");
        }

        if (usuario instanceof Alumno) {
            return ((Alumno) usuario).getMatricula();
        }

        // Respaldo: el login del alumno también guarda la matrícula suelta.
        Object suelta = session.getAttribute("alumno_matricula");
        return (suelta != null) ? suelta.toString() : null;
    }
}