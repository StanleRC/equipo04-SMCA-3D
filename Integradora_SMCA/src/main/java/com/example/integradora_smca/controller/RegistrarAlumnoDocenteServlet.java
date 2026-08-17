package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/RegistrarAlumnoDocenteServlet")
public class RegistrarAlumnoDocenteServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    // Patrón de matrícula: 5 dígitos + 2 letras + 3 dígitos
    private static final String REGEX_MATRICULA = "^\\d{5}[a-z]{2}\\d{3}$";
    // Patrón para alumnos: 5 dígitos + 2 letras + 3 dígitos + @utez.edu.mx
    private static final String REGEX_ALUMNO = "^\\d{5}[a-z]{2}\\d{3}@utez\\.edu\\.mx$";

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    // Validaciones
    private boolean validarCorreoAlumno(String correo) {
        return correo != null && correo.matches(REGEX_ALUMNO);
    }

    private boolean validarMatricula(String matricula) {
        return matricula != null && matricula.matches(REGEX_MATRICULA);
    }

    private boolean validarPassword(String password) {
        return password != null && password.length() >= 8 && password.length() <= 16;
    }

    private boolean matriculaCoincideConCorreo(String matricula, String correo) {
        if (correo == null) return false;
        String parteLocal = correo.split("@")[0]; // lo que va antes de @
        return parteLocal.equalsIgnoreCase(matricula);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        PrintWriter out = response.getWriter();

        // PASO 1: VALIDAR DATOS (sin envío de email)
        if ("validarDatos".equals(accion)) {
            String nombre = request.getParameter("txtNombre");
            String apellidoPaterno = request.getParameter("txtApellidoPaterno");
            String apellidoMaterno = request.getParameter("txtApellidoMaterno");
            String matricula = request.getParameter("txtMatricula");
            String password = request.getParameter("txtPassword");
            String confirmPassword = request.getParameter("txtConfirmPassword");
            String correo = request.getParameter("txtCorreo");
            String grupoId = request.getParameter("grupo");

            // Normalizar matrícula y correo a minúsculas
            if (matricula != null) matricula = matricula.trim().toLowerCase();
            if (correo != null) correo = correo.trim().toLowerCase();

            // ===== VALIDACIONES REQUERIDAS =====

            // 1. Validar que campos no estén vacíos
            if (nombre == null || nombre.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"El nombre es requerido.\"}");
                return;
            }

            if (apellidoPaterno == null || apellidoPaterno.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"El apellido paterno es requerido.\"}");
                return;
            }

            if (apellidoMaterno == null || apellidoMaterno.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"El apellido materno es requerido.\"}");
                return;
            }

            // 2. Validación de matrícula
            if (!validarMatricula(matricula)) {
                out.print("{\"status\":\"error\", \"message\":\"La matrícula no cumple con el formato válido.\"}");
                return;
            }

            // 3. Validación de correo alumno
            if (!validarCorreoAlumno(correo)) {
                out.print("{\"status\":\"error\", \"message\":\"El correo no corresponde a un alumno válido.\"}");
                return;
            }

            // 4. Validación de coincidencia entre matrícula y correo
            if (!matriculaCoincideConCorreo(matricula, correo)) {
                out.print("{\"status\":\"error\", \"message\":\"La matrícula no coincide con el correo institucional.\"}");
                return;
            }

            // 5. Validación de que no existe un registro previo
            if (alumnoDao.existeAlumno(matricula, correo)) {
                out.print("{\"status\":\"error\", \"message\":\"La matrícula o el correo ya están registrados.\"}");
                return;
            }

            // 6. Validación de contraseña (longitud)
            if (!validarPassword(password)) {
                out.print("{\"status\":\"error\", \"message\":\"La contraseña debe tener entre 8 y 16 caracteres.\"}");
                return;
            }

            // 7. Validación de que contraseñas coincidan
            if (password == null || !password.equals(confirmPassword)) {
                out.print("{\"status\":\"error\", \"message\":\"Las contraseñas no coinciden.\"}");
                return;
            }

            // 8. Validación de grupo
            if (grupoId == null || grupoId.trim().isEmpty()) {
                out.print("{\"status\":\"error\", \"message\":\"Debes seleccionar un grupo.\"}");
                return;
            }

            // Si todas las validaciones pasaron, guardar en sesión temporal
            Alumno nuevoAlumno = new Alumno();
            nuevoAlumno.setMatricula(matricula);
            nuevoAlumno.setNombre(nombre != null ? nombre.trim() : "");
            nuevoAlumno.setApellidoPaterno(apellidoPaterno != null ? apellidoPaterno.trim() : "");
            nuevoAlumno.setApellidoMaterno(apellidoMaterno != null ? apellidoMaterno.trim() : "");
            nuevoAlumno.setCorreo(correo);
            nuevoAlumno.setHashPassword(password);
            nuevoAlumno.setGrupoIdGrupo(grupoId);
            nuevoAlumno.setRolIdRol(3); // Rol por defecto (Alumno)
            nuevoAlumno.setFotoPerfil(null);

            HttpSession session = request.getSession();
            session.setAttribute("alumnoTemporal", nuevoAlumno);

            out.print("{\"status\":\"ok\", \"message\":\"Datos validados correctamente.\"}");
            return;
        }

        // PASO 2: REGISTRAR EN BD (sin verificación de email)
        if ("registrar".equals(accion)) {
            HttpSession session = request.getSession();
            Alumno alumnoTemp = (Alumno) session.getAttribute("alumnoTemporal");

            if (alumnoTemp == null) {
                out.print("{\"status\":\"error\", \"message\":\"La sesión expiró. Completa el formulario de nuevo.\"}");
                return;
            }

            try {
                boolean esGuardado = alumnoDao.create(alumnoTemp);

                if (esGuardado) {
                    session.removeAttribute("alumnoTemporal");
                    out.print("{\"status\":\"ok\", \"message\":\"Alumno registrado exitosamente.\"}");
                    System.out.println("[REGISTRO DOCENTE] Alumno registrado: " + alumnoTemp.getMatricula() + " por " +
                            session.getAttribute("usuarioLogueado"));
                } else {
                    out.print("{\"status\":\"error\", \"message\":\"Error al registrar. Matrícula o correo ya en uso.\"}");
                }
            } catch (Exception e) {
                System.err.println("[ERROR REGISTRO] " + e.getMessage());
                out.print("{\"status\":\"error\", \"message\":\"Error al procesar el registro.\"}");
            }
            return;
        }

        out.print("{\"status\":\"error\", \"message\":\"Acción no válida.\"}");
    }
}