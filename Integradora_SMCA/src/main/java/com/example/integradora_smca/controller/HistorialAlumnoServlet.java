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

@WebServlet(name = "HistorialAlumnoServlet", value = "/HistorialAlumnoServlet")
public class HistorialAlumnoServlet extends HttpServlet {

    private final AlumnoDao alumnoDao = new AlumnoDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Obtener el objeto Alumno almacenado en sesión
        Alumno usuarioLogueado = (session != null) ? (Alumno) session.getAttribute("usuarioLogueado") : null;

        // Si la sesión expiró o no se ha logueado, redirigir
        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // 2. Extraer la matrícula del alumno e invocar a tu AlumnoDao
        List<HistorialAlumnoDto> historial = alumnoDao.getHistorialByMatricula(usuarioLogueado.getMatricula());

        // 3. Pasar el atributo con la clave EXACTA que espera tu JSP ("listaHistorial")
        request.setAttribute("listaHistorial", historial);

        // 4. Redirigir la petición al JSP
        request.getRequestDispatcher("/views/alumno/historial_alumno.jsp").forward(request, response);
    }
}