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

@WebServlet("/LoginServlet")
    public class LoginServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        // Inicializamos el DAO al arrancar el Servlet
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirige al formulario JSP en caso de acceder por URL directa
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Configurar codificación de caracteres para acentos/caracteres especiales
        request.setCharacterEncoding("UTF-8");

        // 1. Obtener los parámetros enviados por el formulario HTML
        String matricula = request.getParameter("matricula");
        String password = request.getParameter("password");

        // 2. Validar que no lleguen campos vacíos o nulos
        if (matricula == null || matricula.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Por favor, completa todos los campos.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // 3. Consultar la base de datos con el DAO
        Alumno alumno = alumnoDao.login(matricula.trim(), password);

        // 4. Verificar credenciales
        if (alumno != null) {
            // Credenciales correctas: Crear/Obtener sesión de usuario
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", alumno);
            session.setAttribute("rol", "Alumno");

            // Redirigir a la vista principal del alumno
            response.sendRedirect(request.getContextPath() + "/views/alumno/crear_incidencia_alumno.jsp");
        } else {
            // Credenciales incorrectas: Enviar mensaje de error
            request.setAttribute("errorMessage", "Matrícula o contraseña incorrectas.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}