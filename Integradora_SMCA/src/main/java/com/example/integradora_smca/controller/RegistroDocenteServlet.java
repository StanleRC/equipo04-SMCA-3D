package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.model.dao.DocenteDao;
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
        // Redirige al JSP si alguien abre el Servlet directo por URL
        request.getRequestDispatcher("/views/admin/registro_maestro.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        PrintWriter out = response.getWriter();

        if (accion == null || accion.trim().isEmpty()) {
            accion = "enviarCodigo";
        }

        // 1. ENVIAR CÓDIGO DE VERIFICACIÓN
        if ("enviarCodigo".equals(accion)) {
            String nombre = request.getParameter("txtNombre");
            String apellidoPaterno = request.getParameter("txtApellidoPaterno");
            String apellidoMaterno = request.getParameter("txtApellidoMaterno");
            String password = request.getParameter("txtPassword");
            String confirmPassword = request.getParameter("txtConfirmPassword");
            String correo = request.getParameter("txtCorreo");

            if (correo == null || correo.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"El correo es obligatorio.\"}");
                return;
            }

            if (password == null || !password.equals(confirmPassword)) {
                out.print("{\"status\":\"error\", \"message\":\"Las contraseñas no coinciden.\"}");
                return;
            }

            Docente nuevoDocente = new Docente();
            nuevoDocente.setNombre(nombre != null ? nombre.trim() : "");
            nuevoDocente.setApellidoPaterno(apellidoPaterno != null ? apellidoPaterno.trim() : "");
            nuevoDocente.setApellidoMaterno(apellidoMaterno != null ? apellidoMaterno.trim() : "");
            nuevoDocente.setCorreo(correo.trim());
            nuevoDocente.setHashPassword(password);
            nuevoDocente.setRolIdRol(2); // Rol docente por defecto
            nuevoDocente.setFotoPerfil("default.png");

            String codigoGenerado = String.format("%06d", new Random().nextInt(999999));

            boolean correoEnviado = EmailSender.enviarCodigoVerificacion(correo.trim(), codigoGenerado);

            if (correoEnviado) {
                HttpSession session = request.getSession();
                session.setAttribute("docenteTemporal", nuevoDocente);
                session.setAttribute("codigoVerificacionDocente", codigoGenerado);

                out.print("{\"status\":\"ok\", \"message\":\"Código enviado exitosamente a tu correo.\"}");
            } else {
                out.print("{\"status\":\"error\", \"message\":\"No se pudo enviar el correo de verificación.\"}");
            }
            return;
        }

        // 2. VALIDAR CÓDIGO Y GUARDAR EN BD
        if ("validarCodigo".equals(accion)) {
            String codigoIngresado = request.getParameter("txtCodigo");
            HttpSession session = request.getSession();

            Docente docenteTemp = (Docente) session.getAttribute("docenteTemporal");
            String codigoGuardado = (String) session.getAttribute("codigoVerificacionDocente");

            if (docenteTemp == null || codigoGuardado == null) {
                out.print("{\"status\":\"error\", \"message\":\"La sesión expiró. Por favor intenta de nuevo.\"}");
                return;
            }

            if (codigoGuardado.equals(codigoIngresado != null ? codigoIngresado.trim() : "")) {
                boolean esGuardado = docenteDao.create(docenteTemp);

                if (esGuardado) {
                    session.removeAttribute("docenteTemporal");
                    session.removeAttribute("codigoVerificacionDocente");
                    out.print("{\"status\":\"ok\", \"message\":\"Registro completado con éxito.\"}");
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Error al guardar en la Base de Datos.\"}");
                }
            } else {
                out.print("{\"status\":\"error\", \"message\":\"El código ingresado es incorrecto.\"}");
            }
            return;
        }

        out.print("{\"status\":\"error\", \"message\":\"Acción no válida.\"}");
    }
}