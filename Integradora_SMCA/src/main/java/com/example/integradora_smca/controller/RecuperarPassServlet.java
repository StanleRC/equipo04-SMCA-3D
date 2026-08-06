package com.example.integradora_smca.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;
import com.example.integradora_smca.utils.EmailSender;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "RecuperarPassServlet", value = "/recuperarPassServlet")
public class RecuperarPassServlet extends HttpServlet {

    private final AlumnoDao alumnoDao = new AlumnoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String correo = request.getParameter("correo");

        // 1. Buscar si el alumno existe por correo o matricula (según tu DAO)
        // Puedes implementar un método de búsqueda en tu AlumnoDao
        Alumno alumno = alumnoDao.getById(correo); // O adaptar según tu búsqueda por correo

        if (correo != null && !correo.trim().isEmpty()) {

            // Generar un token temporal o contraseña provisoria
            String nuevaPassword = UUID.randomUUID().toString().substring(0, 8);

            // Construcción del mensaje HTML
            String asunto = "Recuperación de Contraseña - Bitácora Digital UTEZ";
            String cuerpoHtml = "<h2>Solicitud de Restablecimiento de Contraseña</h2>"
                    + "<p>Hola, has solicitado restablecer tu contraseña en la Bitácora Digital UTEZ.</p>"
                    + "<p>Tu nueva contraseña temporal es: <strong>" + nuevaPassword + "</strong></p>"
                    + "<p>Por favor, inicia sesión y cámbiala lo antes posible desde tu perfil.</p>";

            try {
                // 2. Enviar el correo usando tu utility
                EmailSender.sendMail(correo, asunto, cuerpoHtml);
                request.setAttribute("mensajeExito", "Se han enviado las instrucciones a tu correo electrónico.");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("mensajeError", "Error al enviar el correo. Intenta de nuevo más tarde.");
            }
        } else {
            request.setAttribute("mensajeError", "Ingresa un correo electrónico válido.");
        }

        // Redireccionar de vuelta con el mensaje
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}