package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.IncidenciaDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RegistrarIncidenciaServlet", value = "/RegistrarIncidenciaServlet")
public class RegistrarIncidenciaServlet extends HttpServlet {

    private final IncidenciaDao incidenciaDao = new IncidenciaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/alumno/crear_incidencia_alumno.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Captura de datos usando los nombres exactos del formulario HTML/JSP
        String numeroPc = request.getParameter("numeroPc");
        String idLaboratorio = request.getParameter("laboratorio");
        String prioridad = request.getParameter("prioridad");
        String descripcionFalla = request.getParameter("descripcion_falla"); // Corregido a descripcion_falla
        String horaFin = request.getParameter("horaFin");

        // Normalizar cadenas vacías a null para Oracle
        if (numeroPc != null && numeroPc.trim().isEmpty()) numeroPc = null;
        if (horaFin != null && horaFin.trim().isEmpty()) horaFin = null;

        // Obtener sesión activa
        HttpSession session = request.getSession(false);
        String matriculaAlumno = (session != null) ? (String) session.getAttribute("matricula") : null;

        // Validación de sesión activa
        if (matriculaAlumno == null || matriculaAlumno.trim().isEmpty()) {
            System.err.println("=== ERROR EN SERVLET: No hay matricula en la sesion ===");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Guarda Bitácora (obligatorio) y Reporte de Falla (opcional si descripcionFalla viene con texto)
        boolean guardado = incidenciaDao.guardarIncidenciaAlumno(
                descripcionFalla, prioridad, numeroPc, idLaboratorio, matriculaAlumno, horaFin
        );

        if (guardado) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/confirmacion.jsp");
        } else {
            System.err.println("ERROR EN SERVLET: El DAO devolvio false");
            request.setAttribute("error", "No se pudo registrar en la base de datos.");
            request.getRequestDispatcher("/views/alumno/crear_incidencia_alumno.jsp").forward(request, response);
        }
    }
}