package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.model.dao.DocenteDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/loginDocenteServlet")
public class LoginDocenteServlet extends HttpServlet {

    private DocenteDao docenteDao;

    @Override
    public void init() throws ServletException {
        docenteDao = new DocenteDao();
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

        // 1. Obtener parámetros del formulario
        String correo = request.getParameter("correo");
        String password = request.getParameter("password");

        // 2. Validar campos vacíos
        if (correo == null || correo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Por favor, completa todos los campos.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // 3. Validar que el correo sea institucional
        if (!correo.endsWith("@utez.edu.mx")) {
            request.setAttribute("errorMessage", "El correo debe ser institucional (@utez.edu.mx).");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // 4. Consultar la base de datos con el DAO
        Docente docente = docenteDao.loginByCorreo(correo.trim(), password);

        // 5. Verificar credenciales
        if (docente != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", docente);
            session.setAttribute("rol", "Docente");

            // Redirigir a la vista principal del docente
            response.sendRedirect(request.getContextPath() + "/views/docente/panel_docente.jsp");
        } else {
            request.setAttribute("errorMessage", "Correo o contraseña incorrectos.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
