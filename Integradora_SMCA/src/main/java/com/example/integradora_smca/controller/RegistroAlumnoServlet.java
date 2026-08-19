package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;
import com.example.integradora_smca.model.dao.GrupoDao;
import com.example.integradora_smca.utils.EmailSender;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.SecureRandom;

@WebServlet("/RegistroAlumnoServlet")
public class RegistroAlumnoServlet extends HttpServlet {

    private AlumnoDao alumnoDao;
    private GrupoDao grupoDao;

    /** SecureRandom en lugar de Random: el código no debe ser predecible. */
    private static final SecureRandom RANDOM = new SecureRandom();

    /** Vigencia del código de verificación. */
    private static final long VIGENCIA_CODIGO_MS = 10 * 60 * 1000L;

    /** Intentos permitidos antes de invalidar el código. */
    private static final int MAX_INTENTOS = 5;

    // Patrón de matrícula: 5 dígitos + 2 letras + 3 dígitos
    private static final String REGEX_MATRICULA = "^\\d{5}[a-z]{2}\\d{3}$";
    // Patrón para alumnos: la matrícula + @utez.edu.mx
    private static final String REGEX_ALUMNO = "^\\d{5}[a-z]{2}\\d{3}@utez\\.edu\\.mx$";

    private static final String S_ALUMNO = "alumnoTemporal";
    private static final String S_CODIGO = "codigoVerificacion";
    private static final String S_EXPIRA = "codigoRegistroExpira";
    private static final String S_INTENTOS = "intentosCodigoRegistro";

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
        grupoDao = new GrupoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        String accion = request.getParameter("accion");
        PrintWriter out = response.getWriter();

        if ("enviarCodigo".equals(accion)) {
            enviarCodigo(request, out);
        } else if ("validarCodigo".equals(accion)) {
            validarCodigo(request, out);
        } else {
            out.print(json("error", "Acción no válida."));
        }
    }

    // ------------------------------------------------------------------
    // PASO 1: validar los datos y mandar el código
    // ------------------------------------------------------------------
    private void enviarCodigo(HttpServletRequest request, PrintWriter out) {

        String nombre = limpiar(request.getParameter("txtNombre"));
        String apellidoPaterno = limpiar(request.getParameter("txtApellidoPaterno"));
        String apellidoMaterno = limpiar(request.getParameter("txtApellidoMaterno"));
        String matricula = minusculas(request.getParameter("txtMatricula"));
        String password = request.getParameter("txtPassword");
        String confirmPassword = request.getParameter("txtConfirmPassword");
        String correo = minusculas(request.getParameter("txtCorreo"));
        String grupoId = limpiar(request.getParameter("grupo"));

        if (vacio(nombre) || vacio(apellidoPaterno) || vacio(apellidoMaterno)) {
            out.print(json("error", "Completa tu nombre y apellidos."));
            return;
        }

        if (!validarMatricula(matricula)) {
            out.print(json("error", "La matrícula no cumple con el formato válido."));
            return;
        }

        if (!validarCorreoAlumno(correo)) {
            out.print(json("error", "El correo no corresponde a un alumno válido."));
            return;
        }

        if (!matriculaCoincideConCorreo(matricula, correo)) {
            out.print(json("error", "La matrícula no coincide con el correo institucional."));
            return;
        }

        /*
         * El grupo se valida AQUÍ, antes de mandar el código.
         *
         * Antes solo se leía el parámetro y se guardaba tal cual. Si venía vacío
         * o con un grupo inexistente, el INSERT fallaba por la llave foránea
         * hasta el paso 2, cuando el alumno ya había recibido su correo, y el
         * mensaje decía "Matrícula o correo ya en uso", que ni siquiera era
         * la causa real.
         */
        if (vacio(grupoId)) {
            out.print(json("error", "Selecciona tu grupo."));
            return;
        }

        if (!grupoDao.existeGrupo(grupoId)) {
            out.print(json("error", "El grupo seleccionado ya no existe. Vuelve a elegirlo."));
            return;
        }

        if (alumnoDao.existeAlumno(matricula, correo)) {
            out.print(json("error", "La matrícula o el correo ya están registrados."));
            return;
        }

        String errorPassword = validarPassword(password, confirmPassword);
        if (errorPassword != null) {
            out.print(json("error", errorPassword));
            return;
        }

        Alumno nuevoAlumno = new Alumno();
        nuevoAlumno.setMatricula(matricula);
        nuevoAlumno.setNombre(nombre);
        nuevoAlumno.setApellidoPaterno(apellidoPaterno);
        nuevoAlumno.setApellidoMaterno(apellidoMaterno);
        nuevoAlumno.setCorreo(correo);

        // Contraseña en texto plano: AlumnoDao.create() la encripta una sola vez.
        nuevoAlumno.setHashPassword(password);

        nuevoAlumno.setGrupoIdGrupo(grupoId);
        nuevoAlumno.setRolIdRol(3); // Rol Alumno

        // 'default.png' y no null: así el <img> del perfil siempre tiene a qué apuntar.
        nuevoAlumno.setFotoPerfil("default.png");

        // nextInt(1_000_000) cubre el rango completo 000000-999999.
        // Con nextInt(999999) el código 999999 nunca podía salir.
        String codigoGenerado = String.format("%06d", RANDOM.nextInt(1_000_000));

        boolean correoEnviado;
        try {
            correoEnviado = EmailSender.enviarCodigoVerificacion(correo, codigoGenerado);
        } catch (Exception e) {
            // Si el SMTP falla, el alumno debe ver un mensaje claro, no un error 500.
            log("Fallo al enviar el código de registro", e);
            correoEnviado = false;
        }

        if (!correoEnviado) {
            out.print(json("error", "No se pudo enviar el correo de verificación."));
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute(S_ALUMNO, nuevoAlumno);
        session.setAttribute(S_CODIGO, codigoGenerado);
        session.setAttribute(S_EXPIRA, System.currentTimeMillis() + VIGENCIA_CODIGO_MS);
        session.setAttribute(S_INTENTOS, 0);

        out.print(json("ok", "Código enviado a tu correo. Vence en 10 minutos."));
    }

    // ------------------------------------------------------------------
    // PASO 2: validar el código y guardar
    // ------------------------------------------------------------------
    private void validarCodigo(HttpServletRequest request, PrintWriter out) {

        HttpSession session = request.getSession();

        String codigoIngresado = limpiar(request.getParameter("txtCodigo"));
        Alumno alumnoTemp = (Alumno) session.getAttribute(S_ALUMNO);
        String codigoGuardado = (String) session.getAttribute(S_CODIGO);
        Long expiraEn = (Long) session.getAttribute(S_EXPIRA);

        if (alumnoTemp == null || codigoGuardado == null) {
            out.print(json("error", "La sesión expiró. Completa el formulario de nuevo."));
            return;
        }

        // Caducidad: sin esto el código servía indefinidamente.
        if (expiraEn != null && System.currentTimeMillis() > expiraEn) {
            limpiarRegistro(session);
            out.print(json("error", "El código venció. Completa el formulario de nuevo."));
            return;
        }

        // Límite de intentos: evita adivinar los 6 dígitos por fuerza bruta.
        int intentos = session.getAttribute(S_INTENTOS) instanceof Integer
                ? (Integer) session.getAttribute(S_INTENTOS) : 0;

        if (intentos >= MAX_INTENTOS) {
            limpiarRegistro(session);
            out.print(json("error", "Demasiados intentos fallidos. Completa el formulario de nuevo."));
            return;
        }

        if (!codigoGuardado.equals(codigoIngresado == null ? "" : codigoIngresado)) {
            int restantes = MAX_INTENTOS - (intentos + 1);
            session.setAttribute(S_INTENTOS, intentos + 1);

            if (restantes <= 0) {
                limpiarRegistro(session);
                out.print(json("error", "Demasiados intentos fallidos. Completa el formulario de nuevo."));
            } else {
                out.print(json("error", "El código ingresado es incorrecto. Te quedan "
                        + restantes + (restantes == 1 ? " intento." : " intentos.")));
            }
            return;
        }

        /*
         * Se vuelve a comprobar el grupo: pudieron pasar hasta 10 minutos entre
         * el formulario y este momento, y un administrador pudo eliminarlo.
         */
        if (!grupoDao.existeGrupo(alumnoTemp.getGrupoIdGrupo())) {
            limpiarRegistro(session);
            out.print(json("error", "El grupo seleccionado ya no existe. Completa el formulario de nuevo."));
            return;
        }

        boolean guardado = alumnoDao.create(alumnoTemp);

        if (guardado) {
            limpiarRegistro(session);
            out.print(json("ok", "Registro completado con éxito."));
        } else {
            // El create ya imprime la causa real en consola.
            out.print(json("error", "No se pudo completar el registro. Revisa tus datos e inténtalo de nuevo."));
        }
    }

    // ------------------------------------------------------------------
    // Validaciones
    // ------------------------------------------------------------------

    private boolean validarCorreoAlumno(String correo) {
        return correo != null && correo.matches(REGEX_ALUMNO);
    }

    private boolean validarMatricula(String matricula) {
        return matricula != null && matricula.matches(REGEX_MATRICULA);
    }

    private boolean matriculaCoincideConCorreo(String matricula, String correo) {
        if (correo == null || matricula == null) return false;
        String parteLocal = correo.split("@")[0];
        return parteLocal.equalsIgnoreCase(matricula);
    }

    /**
     * Devuelve null si la contraseña es válida, o el mensaje de error.
     *
     * Antes solo se comprobaba la longitud, pero el formulario ya exige letra y
     * número. El servidor no debe confiar en el navegador ni pedir menos que él.
     */
    private String validarPassword(String password, String confirmacion) {
        if (password == null || password.isEmpty()) {
            return "Escribe una contraseña.";
        }
        if (password.length() < 8 || password.length() > 16) {
            return "La contraseña debe tener entre 8 y 16 caracteres.";
        }
        if (!password.matches(".*[a-zA-Z].*")) {
            return "La contraseña debe incluir al menos una letra.";
        }
        if (!password.matches(".*[0-9].*")) {
            return "La contraseña debe incluir al menos un número.";
        }
        if (!password.equals(confirmacion)) {
            return "Las contraseñas no coinciden.";
        }
        return null;
    }

    // ------------------------------------------------------------------
    // Apoyo
    // ------------------------------------------------------------------

    /** Borra todo rastro del registro a medias. */
    private void limpiarRegistro(HttpSession session) {
        session.removeAttribute(S_ALUMNO);
        session.removeAttribute(S_CODIGO);
        session.removeAttribute(S_EXPIRA);
        session.removeAttribute(S_INTENTOS);
    }

    private String limpiar(String valor) {
        return valor == null ? null : valor.trim();
    }

    private String minusculas(String valor) {
        return valor == null ? null : valor.trim().toLowerCase();
    }

    private boolean vacio(String valor) {
        return valor == null || valor.isEmpty();
    }

    /** Construye el JSON escapando lo que rompería el formato. */
    private String json(String status, String message) {
        String limpio = message == null ? "" : message
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", " ");
        return "{\"status\":\"" + status + "\",\"message\":\"" + limpio + "\"}";
    }
}