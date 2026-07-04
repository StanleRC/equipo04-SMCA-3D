package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginAlumnoServlet")
public class LoginAlumnoServlet extends HttpServlet {
    private AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener parámetros basados en los 'name' de tu formulario base
        String matricula = request.getParameter("matricula");
        String contrasena = request.getParameter("contrasena");

        // 2. Intentar autenticar al Alumno
        Alumno alumnoLogueado = alumnoDAO.autenticarAlumno(matricula, contrasena);

        // 3. Evaluar el resultado
        if (alumnoLogueado != null) {
            // Éxito: Crear sesión y guardar el objeto del alumno
            HttpSession session = request.getSession();
            session.setAttribute("alumnoSesion", alumnoLogueado);

            // Redirigir a la vista principal en la raíz de webapp (index.jsp)
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } else {
            // Fallo: Mandar mensaje de error de vuelta a la vista
            request.setAttribute("mensajeError", "La matrícula o la contraseña son incorrectas.");

            // Como tu servlet corre en la raíz y la vista está en la subcarpeta /login
            request.getRequestDispatcher("login/login_alumno.jsp").forward(request, response);
        }
    }
}