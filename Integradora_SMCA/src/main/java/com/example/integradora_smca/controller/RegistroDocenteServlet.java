package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.model.dao.DocenteDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RegistroDocenteServlet")
public class RegistroDocenteServlet extends HttpServlet {

    private DocenteDao docenteDao;
    private static final String VISTA_REGISTRO = "/views/admin/registro_directo_maestro.jsp";

    @Override
    public void init() throws ServletException {
        docenteDao = new DocenteDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VISTA_REGISTRO).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("txtNombre");
        String apellidoPaterno = request.getParameter("txtApellidoPaterno");
        String apellidoMaterno = request.getParameter("txtApellidoMaterno");
        String password = request.getParameter("txtPassword");
        String confirmPassword = request.getParameter("txtConfirmPassword");
        String correo = request.getParameter("txtCorreo");
        String idDocenteStr = request.getParameter("txtIdDocente");

        if (correo == null || correo.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Por favor completa todos los campos requeridos.");
            request.getRequestDispatcher(VISTA_REGISTRO).forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Las contraseñas no coinciden.");
            request.getRequestDispatcher(VISTA_REGISTRO).forward(request, response);
            return;
        }

        int idParsed = 0;
        if (idDocenteStr != null && !idDocenteStr.trim().isEmpty()) {
            try {
                idParsed = Integer.parseInt(idDocenteStr.trim());
            } catch (NumberFormatException e) {
                idParsed = (int) (System.currentTimeMillis() % 1000000);
            }
        } else {
            idParsed = (int) (System.currentTimeMillis() % 1000000);
        }

        Docente nuevoDocente = new Docente();
        nuevoDocente.setIdDocente(idParsed);
        nuevoDocente.setNombre(nombre != null ? nombre.trim() : "");
        nuevoDocente.setApellidoPaterno(apellidoPaterno != null ? apellidoPaterno.trim() : "");
        nuevoDocente.setApellidoMaterno(apellidoMaterno != null ? apellidoMaterno.trim() : "");
        nuevoDocente.setCorreo(correo.trim());
        // Se envía en texto plano; el DAO aplica el hash SHA-256 una sola vez
        nuevoDocente.setHashPassword(password.trim());
        nuevoDocente.setRolIdRol(2);
        nuevoDocente.setFotoPerfil("default.png");

        boolean esGuardado = docenteDao.create(nuevoDocente);

        if (esGuardado) {
            request.setAttribute("mensajeExito", "¡Registro exitoso! Ya puedes iniciar sesión.");
            request.getRequestDispatcher("/admin-docente_login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Error al registrar en la base de datos.");
            request.getRequestDispatcher(VISTA_REGISTRO).forward(request, response);
        }
    }
}