package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.AlumnoDao;

import com.example.integradora_smca.utils.EmailSender;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

@WebServlet("/recuperarPassServlet")
public class RecuperarPassServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/cambiar_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        // PASO 1: VALIDAR CORREO Y ENVIAR CÓDIGO
        if ("enviarCodigo".equals(accion)) {
            String correo = request.getParameter("correo");

            if (correo != null) correo = correo.trim().toLowerCase();

            // Verificar si el correo existe en la base de datos (puedes consultar Alumno o Docente según tu esquema)
            boolean existeUsuario = alumnoDao.existeCorreo(correo);

            if (!existeUsuario) {
                out.print("{\"status\":\"error\", \"message\":\"El correo no se encuentra registrado en el sistema.\"}");
                return;
            }

            // Generar código de 6 dígitos
            String codigoGenerado = String.format("%06d", new Random().nextInt(999999));

            boolean correoEnviado = EmailSender.enviarCodigoVerificacion(correo, codigoGenerado);

            if (correoEnviado) {
                session.setAttribute("correoRecuperacion", correo);
                session.setAttribute("codigoVerificacionPass", codigoGenerado);
                out.print("{\"status\":\"ok\", \"message\":\"Código enviado exitosamente.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"No se pudo enviar el correo de verificación.\"}");
            }
            return;
        }

        // PASO 2: VALIDAR CÓDIGO DE 6 DÍGITOS
        if ("validarCodigo".equals(accion)) {
            String codigoIngresado = request.getParameter("txtCodigo");
            String codigoGuardado = (String) session.getAttribute("codigoVerificacionPass");

            if (codigoGuardado == null) {
                out.print("{\"status\":\"error\", \"message\":\"La sesión ha expirado. Inténtalo de nuevo.\"}");
                return;
            }

            if (codigoGuardado.equals(codigoIngresado != null ? codigoIngresado.trim() : "")) {
                session.setAttribute("autorizadoCambioPass", true);
                out.print("{\"status\":\"ok\", \"message\":\"Código correcto.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"El código ingresado es incorrecto.\"}");
            }
            return;
        }

        // PASO 3: ACTUALIZAR CONTRASEÑA
        if ("actualizarPassword".equals(accion)) {
            Boolean autorizado = (Boolean) session.getAttribute("autorizadoCambioPass");
            String correo = (String) session.getAttribute("correoRecuperacion");
            String nuevaPassword = request.getParameter("newPassword");

            if (autorizado == null || !autorizado || correo == null) {
                out.print("{\"status\":\"error\", \"message\":\"Operación no autorizada o sesión expirada.\"}");
                return;
            }

            if (nuevaPassword == null || nuevaPassword.length() < 8 || nuevaPassword.length() > 16) {
                out.print("{\"status\":\"error\", \"message\":\"La contraseña debe tener entre 8 y 16 caracteres.\"}");
                return;
            }

            // Llamar al DAO para actualizar la contraseña (asegúrate de aplicar encriptación en el DAO si corresponde)
            boolean actualizada = alumnoDao.actualizarPasswordPorCorreo(correo, nuevaPassword);

            if (actualizada) {
                // Limpiar atributos de sesión utilizados
                session.removeAttribute("correoRecuperacion");
                session.removeAttribute("codigoVerificacionPass");
                session.removeAttribute("autorizadoCambioPass");

                out.print("{\"status\":\"ok\", \"message\":\"Contraseña restablecida correctamente.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"No se pudo actualizar la contraseña.\"}");
            }
            return;
        }

        out.print("{\"status\":\"error\", \"message\":\"Acción no válida.\"}");
    }
}