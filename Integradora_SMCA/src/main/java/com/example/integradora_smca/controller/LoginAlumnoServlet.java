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

@WebServlet("/loginServlet")
public class LoginAlumnoServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String matricula = request.getParameter("matricula");
        String password = request.getParameter("password");

        if (matricula == null || matricula.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Por favor, completa todos los campos.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        Alumno alumno = alumnoDao.login(matricula.trim(), password);

        if (alumno != null) {
            // Invalida sesión anterior por seguridad si existía
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Crea sesión limpia con las claves necesarias
            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogueado", alumno);
            session.setAttribute("usuario", alumno);
            session.setAttribute("rol", "Alumno");


            response.sendRedirect(request.getContextPath() + "/PerfilAlumnoServlet");
        } else {
            request.setAttribute("errorMessage", "Matrícula o contraseña incorrectas.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}