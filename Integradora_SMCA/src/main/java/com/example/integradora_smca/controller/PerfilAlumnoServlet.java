package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/PerfilAlumnoServlet")
public class PerfilAlumnoServlet extends HttpServlet {

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

        // Validar que exista una sesión activa
        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Refrescar los datos del alumno desde la base de datos
        Alumno alumnoActualizado = alumnoDao.getById(usuarioLogueado.getMatricula());

        if (alumnoActualizado != null) {
            // Actualizamos el objeto en la sesión
            session.setAttribute("usuarioLogueado", alumnoActualizado);

            // Guardamos la ruta de la foto en session Scope con la clave "usuarioFoto"
            session.setAttribute("usuarioFoto", alumnoActualizado.getFotoPerfil());

            request.getRequestDispatcher("/views/alumno/perfil_alumno.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}