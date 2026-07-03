package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.MaestroDAO;
import com.example.integradora_smca.model.Maestro;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterMaestroServlet")
public class RegisterMaestroServlet extends HttpServlet {
    private MaestroDAO maestroDAO = new MaestroDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Obtenemos los campos usando los nombres exactos que usas en el JS
        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String telefono = request.getParameter("telefono");

        // Creamos el objeto Maestro con toda la información
        Maestro nuevoMaestro = new Maestro(0, nombre, apellidoPaterno, apellidoMaterno, correo, contrasena, telefono, "docente");

        boolean exito = maestroDAO.registrarMaestro(nuevoMaestro);

        if (exito) {
            request.setAttribute("mensajeExito", "¡Maestro registrado con éxito!");
            request.getRequestDispatcher("login/login_maestro.jsp").forward(request, response);
        } else {
            request.setAttribute("mensajeError", "Error al registrar al maestro. Intente de nuevo.");
            // Cambia esto por la ruta exacta de tu vista de registro de maestros si es diferente
            request.getRequestDispatcher("registro_maestro.jsp").forward(request, response);
        }
    }
}