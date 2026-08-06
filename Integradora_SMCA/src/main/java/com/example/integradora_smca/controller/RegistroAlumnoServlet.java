package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RegistroAlumnoServlet")
public class RegistroAlumnoServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Obtención de parámetros
        String nombre = request.getParameter("txtNombre");
        String apellidoPaterno = request.getParameter("txtApellidoPaterno");
        String apellidoMaterno = request.getParameter("txtApellidoMaterno");
        String matricula = request.getParameter("txtMatricula");
        String password = request.getParameter("txtPassword");
        String confirmPassword = request.getParameter("txtConfirmPassword");
        String correo = request.getParameter("txtCorreo");
        String grupoId = request.getParameter("grupo");

        // 2. Validación de coincidencia de contraseñas
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp").forward(request, response);
            return;
        }

        // 3. Concatenación de apellidos
        String apellidosCompletos = apellidoPaterno.trim() + " " + apellidoMaterno.trim();

        // 4. Instancia del modelo Alumno
        Alumno nuevoAlumno = new Alumno();
        nuevoAlumno.setMatricula(matricula.trim());
        nuevoAlumno.setNombre(nombre.trim());
        nuevoAlumno.setApellidos(apellidosCompletos);
        nuevoAlumno.setCorreo(correo.trim());
        nuevoAlumno.setHashPassword(password);
        nuevoAlumno.setGrupoIdGrupo(grupoId);
        nuevoAlumno.setRolIdRol(3);
        nuevoAlumno.setFotoPerfil(null); // Inicia nulo; se actualizará en la edición de perfil

        // 5. Inserción mediante DAO
        boolean esGuardado = alumnoDao.create(nuevoAlumno);

        if (esGuardado) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?registro=exito");
        } else {
            request.setAttribute("errorMessage", "Error al registrar. Verifica la matrícula o correo duplicado.");
            request.getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp").forward(request, response);
        }
    }
}