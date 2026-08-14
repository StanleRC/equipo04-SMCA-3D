package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
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
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        PrintWriter out = response.getWriter();

        // PASO 1: ENVIAR CÓDIGO DE VERIFICACIÓN
        if ("enviarCodigo".equals(accion)) {
            String nombre = request.getParameter("txtNombre");
            String apellidoPaterno = request.getParameter("txtApellidoPaterno");
            String apellidoMaterno = request.getParameter("txtApellidoMaterno");
            String matricula = request.getParameter("txtMatricula");
            String password = request.getParameter("txtPassword");
            String confirmPassword = request.getParameter("txtConfirmPassword");
            String correo = request.getParameter("txtCorreo");
            String grupoId = request.getParameter("grupo");

            if (password == null || !password.equals(confirmPassword)) {
                out.print("{\"status\":\"error\", \"message\":\"Las contraseñas no coinciden.\"}");
                return;
            }

            String apellidosCompletos = (apellidoPaterno != null ? apellidoPaterno.trim() : "") + " " +
                    (apellidoMaterno != null ? apellidoMaterno.trim() : "");

            Alumno nuevoAlumno = new Alumno();
            nuevoAlumno.setMatricula(matricula != null ? matricula.trim() : "");
            nuevoAlumno.setNombre(nombre != null ? nombre.trim() : "");
            nuevoAlumno.setApellidos(apellidosCompletos.trim());
            nuevoAlumno.setCorreo(correo != null ? correo.trim() : "");
            nuevoAlumno.setHashPassword(password);
            nuevoAlumno.setGrupoIdGrupo(grupoId);
            nuevoAlumno.setRolIdRol(3); // Rol por defecto (Alumno)
            nuevoAlumno.setFotoPerfil(null);

            // Generar código de 6 dígitos
            String codigoGenerado = String.format("%06d", new Random().nextInt(999999));

            // Enviar correo mediante EmailSender
            boolean correoEnviado = EmailSender.enviarCodigoVerificacion(correo.trim(), codigoGenerado);

            if (correoEnviado) {
                HttpSession session = request.getSession();
                session.setAttribute("alumnoTemporal", nuevoAlumno);
                session.setAttribute("codigoVerificacion", codigoGenerado);

                out.print("{\"status\":\"ok\", \"message\":\"Código enviado a tu correo.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"No se pudo enviar el correo de verificación.\"}");
            }
            return;
        }

        // PASO 2: VALIDAR CÓDIGO Y REGISTRAR EN BD
        if ("validarCodigo".equals(accion)) {
            String codigoIngresado = request.getParameter("txtCodigo");
            HttpSession session = request.getSession();

            Alumno alumnoTemp = (Alumno) session.getAttribute("alumnoTemporal");
            String codigoGuardado = (String) session.getAttribute("codigoVerificacion");

            if (alumnoTemp == null || codigoGuardado == null) {
                out.print("{\"status\":\"error\", \"message\":\"La sesión expiró. Completa el formulario de nuevo.\"}");
                return;
            }

            if (codigoGuardado.equals(codigoIngresado != null ? codigoIngresado.trim() : "")) {
                boolean esGuardado = alumnoDao.create(alumnoTemp);

                if (esGuardado) {
                    session.removeAttribute("alumnoTemporal");
                    session.removeAttribute("codigoVerificacion");
                    out.print("{\"status\":\"ok\", \"message\":\"Registro completado con éxito.\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Error al registrar. Matrícula o correo ya en uso.\"}");
                }
            } else {
                out.print("{\"status\":\"error\", \"message\":\"El código ingresado es incorrecto.\"}");
            }
            return;
        }

        out.print("{\"status\":\"error\", \"message\":\"Acción no válida.\"}");
    }
}