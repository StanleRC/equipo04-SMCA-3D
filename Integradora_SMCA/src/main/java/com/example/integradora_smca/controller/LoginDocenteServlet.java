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
    private static final String VISTA_LOGIN_DOCENTE = "/admin-docente_login.jsp";

    @Override
    public void init() throws ServletException {
        docenteDao = new DocenteDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VISTA_LOGIN_DOCENTE).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String usuarioOrCorreo = request.getParameter("correo");
        if (usuarioOrCorreo == null || usuarioOrCorreo.trim().isEmpty()) {
            usuarioOrCorreo = request.getParameter("txtCorreo");
        }
        if (usuarioOrCorreo == null || usuarioOrCorreo.trim().isEmpty()) {
            usuarioOrCorreo = request.getParameter("usuario");
        }

        String password = request.getParameter("password");
        if (password == null || password.trim().isEmpty()) {
            password = request.getParameter("txtPassword");
        }

        if (usuarioOrCorreo == null || usuarioOrCorreo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Por favor, completa todos los campos.");
            request.getRequestDispatcher(VISTA_LOGIN_DOCENTE).forward(request, response);
            return;
        }

        Docente docente = docenteDao.loginByCorreo(usuarioOrCorreo.trim(), password);

        if (docente == null) {
            docente = docenteDao.login(usuarioOrCorreo.trim(), password);
        }

        if (docente != null) {
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);

            // Construcción opcional de nombre completo para atributos generales de vista
            String nombreCompleto = docente.getNombre() + " " + docente.getApellidoPaterno() + " " + docente.getApellidoMaterno();

            session.setAttribute("docenteLogueado", docente);
            session.setAttribute("usuarioLogueado", docente);
            session.setAttribute("docente", docente);
            session.setAttribute("usuario", docente);
            session.setAttribute("nombreUsuario", nombreCompleto.trim());
            session.setAttribute("usuarioFoto", docente.getFotoPerfil());
            session.setAttribute("rol", docente.getRolIdRol() == 1 ? "Admin" : "Docente");

            response.sendRedirect(request.getContextPath() + "/views/admin/perfil_admin-docente.jsp");
        } else {
            request.setAttribute("errorMessage", "Correo/Matrícula o contraseña incorrectos.");
            request.getRequestDispatcher(VISTA_LOGIN_DOCENTE).forward(request, response);
        }
    }
}