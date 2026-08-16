package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.IncidenciaDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/RegistrarIncidenciaServlet")
public class RegistrarIncidenciaServlet extends HttpServlet {

    private final IncidenciaDao incidenciaDao = new IncidenciaDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String alumnoMatricula = (String) session.getAttribute("alumno_matricula");

        if (alumnoMatricula == null || alumnoMatricula.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/crear_incidencia_alumno.jsp?error=sesion");
            return;
        }

        String numeroPc = request.getParameter("numeroPc");
        String laboratorio = request.getParameter("laboratorio");
        String descripcion = request.getParameter("incidencia");
        String prioridad = request.getParameter("prioridad");
        String horaSalida = request.getParameter("horaSalida");

        if (numeroPc == null || numeroPc.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/crear_incidencia_alumno.jsp?error=pc");
            return;
        }

        if (laboratorio == null || laboratorio.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/crear_incidencia_alumno.jsp?error=laboratorio");
            return;
        }

        if (horaSalida == null || horaSalida.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/crear_incidencia_alumno.jsp?error=hora");
            return;
        }

        if (descripcion == null || descripcion.trim().isEmpty()) {
            descripcion = "Sin descripción";
        }

        if (prioridad == null || prioridad.trim().isEmpty()) {
            prioridad = "Media";
        }

        Integer idBitacora = incidenciaDao.buscarBitacoraActiva(alumnoMatricula);

        boolean ok = incidenciaDao.guardarIncidencia(descripcion, prioridad, numeroPc, laboratorio,
                horaSalida, alumnoMatricula, idBitacora);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/views/alumno/index.jsp?success=incidencia_guardada");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/alumno/crear_incidencia_alumno.jsp?error=guardar");
        }
    }
}