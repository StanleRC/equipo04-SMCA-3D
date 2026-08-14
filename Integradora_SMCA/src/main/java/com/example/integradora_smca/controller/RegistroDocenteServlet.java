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

    @Override
    public void init() throws ServletException {
        docenteDao = new DocenteDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/docente/registro_directo_docente.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 1. Obtención de parámetros
        String nombre = request.getParameter("Nombre");
        String apellidoPaterno = request.getParameter("ApellidoPaterno");
        String apellidoMaterno = request.getParameter("ApellidoMaterno");
        String idDocente = request.getParameter("txtIdDocente"); // clave primaria
        String password = request.getParameter("txtPassword");
        String confirmPassword = request.getParameter("txtConfirmPassword");
        String correo = request.getParameter("txtCorreo");
        //String telefono = request.getParameter("txtTelefono"); // opcional en tu formulario

        // 2. Validación de coincidencia de contraseñas
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("/views/docente/registro_directo_docente.jsp").forward(request, response);
            return;
        }

        // 3. Concatenación de apellidos
        String apellidosCompletos = apellidoPaterno.trim() + " " + apellidoMaterno.trim();

        // 4. Instancia del modelo Docente
        Docente nuevoDocente = new Docente();
        nuevoDocente.setIdDocente(idDocente.trim());
        nuevoDocente.setNombre(nombre.trim());
        nuevoDocente.setApellidos(apellidosCompletos);
        nuevoDocente.setCorreo(correo.trim());
        nuevoDocente.setHashPassword(password);
        nuevoDocente.setRolIdRol(2); // Rol Docente según tu script
        nuevoDocente.setFotoPerfil(null); // inicia nulo

        // 5. Inserción mediante DAO
        boolean esGuardado = docenteDao.create(nuevoDocente);

        if (esGuardado) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?registro=exito");
        } else {
            request.setAttribute("errorMessage", "Error al registrar. Verifica el ID o correo duplicado.");
            request.getRequestDispatcher("/views/docente/registro_directo_docente.jsp").forward(request, response);
        }
    }
}
