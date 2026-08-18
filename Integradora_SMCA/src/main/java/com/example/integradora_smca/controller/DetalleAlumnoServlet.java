package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.HistorialAlumnoDto;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Detalle de un alumno visto desde el buscador (botón "Ver historial").
 *
 * El buscador original enlazaba a /views/admin/perfil_alumno.jsp?id=..., pero
 * ese archivo no existe en views/admin y la tabla alumno tampoco tiene columna
 * "id": su llave primaria es la matrícula. Por eso el botón no llevaba a ningún lado.
 */
@WebServlet("/DetalleAlumnoServlet")
public class DetalleAlumnoServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String matricula = request.getParameter("matricula");

        if (matricula == null || matricula.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BuscarAlumnosServlet");
            return;
        }

        matricula = matricula.trim();

        Alumno alumno = alumnoDao.getPerfilCompletoByMatricula(matricula);

        if (alumno == null) {
            // Matrícula manipulada en la URL o alumno dado de baja.
            response.sendRedirect(request.getContextPath()
                    + "/BuscarAlumnosServlet?aviso=noexiste");
            return;
        }

        List<HistorialAlumnoDto> historial = alumnoDao.getHistorialByMatricula(matricula);

        request.setAttribute("alumnoDetalle", alumno);
        request.setAttribute("listaHistorial", historial);

        request.getRequestDispatcher("/views/admin/detalle_alumno.jsp")
                .forward(request, response);
    }
}