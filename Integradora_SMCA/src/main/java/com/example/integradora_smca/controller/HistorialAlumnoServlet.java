package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;
import com.example.integradora_smca.model.HistorialAlumnoDto;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/HistorialAlumnoServlet")
public class HistorialAlumnoServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Alumno usuarioLogueado = (session != null) ? (Alumno) session.getAttribute("usuarioLogueado") : null;

        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Consultar el historial filtrado por la matrícula de la sesión activa
        List<HistorialAlumnoDto> historial = alumnoDao.getHistorialByMatricula(usuarioLogueado.getMatricula());

        request.setAttribute("listaHistorial", historial);
        request.getRequestDispatcher("/views/alumno/historial_alumno.jsp").forward(request, response);
    }
}
