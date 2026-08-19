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

        // Solo se captura la descripción de la falla y prioridad desde el formulario
        String descripcionFalla = request.getParameter("descripcion_falla");
        String prioridad = request.getParameter("prioridad");

        // Obtener sesión activa y los datos que ya se guardaron en el login
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.err.println("=== ERROR EN SERVLET: No hay sesión activa ===");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String matriculaAlumno = (String) session.getAttribute("alumno_matricula");
        String numeroPc = (String) session.getAttribute("numeroPc");
        String aula = (String) session.getAttribute("aula");
        String horaInicio = (String) session.getAttribute("horaInicio");
        String horaFinal = (String) session.getAttribute("horaFinal");

        // Validación de sesión activa y matrícula
        if (matriculaAlumno == null || matriculaAlumno.trim().isEmpty()) {
            System.err.println("=== ERROR EN SERVLET: No hay matrícula en la sesión ===");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Guarda Bitácora (obligatorio) y Reporte de Falla (opcional si descripcionFalla viene con texto)
        boolean guardado = incidenciaDao.guardarIncidenciaAlumno(
                descripcionFalla, prioridad, numeroPc, aula, matriculaAlumno, horaFinal
        );

        if (guardado) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/confirmacion.jsp");
        } else {
            System.err.println("ERROR EN SERVLET: El DAO devolvió false");
            request.setAttribute("error", "No se pudo registrar en la base de datos.");
            request.getRequestDispatcher("/views/alumno/crear_incidencia_alumno.jsp").forward(request, response);
        }
    }
}
