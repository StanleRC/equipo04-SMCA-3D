package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.AlumnoDao;
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
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.regex.Pattern;

@WebServlet("/recuperarPassServlet")
public class RecuperarPassServlet extends HttpServlet {

    private AlumnoDao alumnoDao;
    private DocenteDao docenteDao;

    private static final SecureRandom RANDOM = new SecureRandom();

    /** Vigencia del código de verificación. */
    private static final long VIGENCIA_CODIGO_MS = 10 * 60 * 1000L;

    /** Espera obligatoria entre dos envíos de código. */
    private static final long COOLDOWN_ENVIO_MS = 60 * 1000L;

    /** Intentos permitidos antes de invalidar el código. */
    private static final int MAX_INTENTOS = 5;

    /** Códigos que puede pedir una misma sesión antes de tener que empezar de cero. */
    private static final int MAX_ENVIOS = 5;

    private static final int PASS_MIN = 8;
    private static final int PASS_MAX = 16;

    private static final Pattern PATRON_CORREO =
            Pattern.compile("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$");

    /**
     * Si es true, el sistema avisa cuando un correo no está registrado (más cómodo para el
     * usuario). En producción conviene ponerlo en false: si no, cualquiera puede averiguar
     * qué correos existen en la base probándolos uno por uno.
     */
    private static final boolean REVELAR_CORREO_INEXISTENTE = true;

    private static final String S_CORREO = "correoRecuperacion";
    private static final String S_CODIGO = "codigoVerificacionPass";
    private static final String S_EXPIRA = "codigoRecuperacionExpira";
    private static final String S_INTENTOS = "intentosCodigoRecuperacion";
    private static final String S_AUTORIZADO = "autorizadoCambioPass";
    private static final String S_ULTIMO_ENVIO = "ultimoEnvioCodigo";
    private static final String S_ENVIOS = "enviosCodigo";

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
        docenteDao = new DocenteDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/recuperar_pass.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // El navegador no debe cachear respuestas de este flujo.
        response.setHeader("Cache-Control", "no-store");

        String accion = request.getParameter("accion");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();

        if ("enviarCodigo".equals(accion)) {
            enviarCodigo(request, session, out);
        } else if ("validarCodigo".equals(accion)) {
            validarCodigo(request, session, out);
        } else if ("actualizarPassword".equals(accion)) {
            actualizarPassword(request, session, out);
        } else {
            out.print(json("error", "Acción no válida."));
        }
    }

    // ------------------------------------------------------------------
    // PASO 1: enviar el código al correo
    // ------------------------------------------------------------------
    private void enviarCodigo(HttpServletRequest request, HttpSession session, PrintWriter out) {

        String correo = request.getParameter("correo");
        correo = correo == null ? "" : correo.trim().toLowerCase();

        if (correo.isEmpty()) {
            out.print(json("error", "Escribe tu correo electrónico."));
            return;
        }

        if (!PATRON_CORREO.matcher(correo).matches()) {
            out.print(json("error", "Ese correo no tiene un formato válido."));
            return;
        }

        // Antiabuso: sin esto, alguien puede lanzar cientos de correos con un script.
        Long ultimoEnvio = (Long) session.getAttribute(S_ULTIMO_ENVIO);
        if (ultimoEnvio != null) {
            long restanteMs = COOLDOWN_ENVIO_MS - (System.currentTimeMillis() - ultimoEnvio);
            if (restanteMs > 0) {
                long segundos = (restanteMs / 1000) + 1;
                out.print(json("error", "Espera " + segundos + " segundos para pedir otro código."));
                return;
            }
        }

        int envios = enteroDeSesion(session, S_ENVIOS);
        if (envios >= MAX_ENVIOS) {
            limpiarRecuperacion(session);
            out.print(json("error", "Superaste el límite de códigos. Recarga la página e inténtalo de nuevo."));
            return;
        }

        boolean existeUsuario = alumnoDao.existeCorreo(correo) || docenteDao.existeCorreo(correo);

        if (!existeUsuario) {
            if (REVELAR_CORREO_INEXISTENTE) {
                out.print(json("error", "Ese correo no está registrado en el sistema."));
            } else {
                // Respuesta idéntica al caso exitoso para no filtrar qué correos existen.
                session.setAttribute(S_ULTIMO_ENVIO, System.currentTimeMillis());
                session.setAttribute(S_ENVIOS, envios + 1);
                out.print(json("ok", "Si el correo está registrado, recibirás un código en unos segundos."));
            }
            return;
        }

        // nextInt(1_000_000) cubre el rango 0-999999; el formato %06d completa con ceros.
        String codigoGenerado = String.format("%06d", RANDOM.nextInt(1_000_000));

        boolean correoEnviado;
        try {
            correoEnviado = EmailSender.enviarCodigoVerificacion(correo, codigoGenerado);
        } catch (Exception e) {
            // Si el servidor SMTP falla, el usuario debe ver un mensaje claro, no un error 500.
            log("Fallo al enviar el código de verificación", e);
            correoEnviado = false;
        }

        if (!correoEnviado) {
            out.print(json("error", "No pudimos enviar el correo. Revisa la dirección o inténtalo más tarde."));
            return;
        }

        session.setAttribute(S_CORREO, correo);
        session.setAttribute(S_CODIGO, codigoGenerado);
        session.setAttribute(S_EXPIRA, System.currentTimeMillis() + VIGENCIA_CODIGO_MS);
        session.setAttribute(S_INTENTOS, 0);
        session.setAttribute(S_ULTIMO_ENVIO, System.currentTimeMillis());
        session.setAttribute(S_ENVIOS, envios + 1);
        session.removeAttribute(S_AUTORIZADO);

        out.print(json("ok", "Te enviamos un código de 6 dígitos. Vence en 10 minutos."));
    }

    // ------------------------------------------------------------------
    // PASO 2: validar el código de 6 dígitos
    // ------------------------------------------------------------------
    private void validarCodigo(HttpServletRequest request, HttpSession session, PrintWriter out) {

        String codigoIngresado = request.getParameter("txtCodigo");
        codigoIngresado = codigoIngresado == null ? "" : codigoIngresado.trim();

        String codigoGuardado = (String) session.getAttribute(S_CODIGO);
        Long expiraEn = (Long) session.getAttribute(S_EXPIRA);

        if (codigoGuardado == null || expiraEn == null) {
            out.print(json("error", "La sesión expiró. Solicita un código nuevo."));
            return;
        }

        if (System.currentTimeMillis() > expiraEn) {
            limpiarRecuperacion(session);
            out.print(json("error", "El código venció. Solicita uno nuevo."));
            return;
        }

        int intentos = enteroDeSesion(session, S_INTENTOS);
        if (intentos >= MAX_INTENTOS) {
            limpiarRecuperacion(session);
            out.print(json("error", "Demasiados intentos fallidos. Solicita un código nuevo."));
            return;
        }

        if (!comparacionSegura(codigoGuardado, codigoIngresado)) {
            int restantes = MAX_INTENTOS - (intentos + 1);
            session.setAttribute(S_INTENTOS, intentos + 1);

            if (restantes <= 0) {
                limpiarRecuperacion(session);
                out.print(json("error", "Demasiados intentos fallidos. Solicita un código nuevo."));
            } else {
                out.print(json("error", "Código incorrecto. Te quedan " + restantes
                        + (restantes == 1 ? " intento." : " intentos.")));
            }
            return;
        }

        // Código correcto: se cambia el id de sesión para evitar fijación de sesión.
        // changeSessionId() conserva los atributos, solo renueva la cookie JSESSIONID.
        try {
            request.changeSessionId();
        } catch (IllegalStateException ignored) {
            // La sesión ya no es nueva en algunos contenedores; no es crítico.
        }

        session.setAttribute(S_AUTORIZADO, Boolean.TRUE);
        session.removeAttribute(S_INTENTOS);
        session.removeAttribute(S_CODIGO); // el código ya cumplió su función
        out.print(json("ok", "Código verificado."));
    }

    // ------------------------------------------------------------------
    // PASO 3: guardar la nueva contraseña
    // ------------------------------------------------------------------
    private void actualizarPassword(HttpServletRequest request, HttpSession session, PrintWriter out) {

        Boolean autorizado = (Boolean) session.getAttribute(S_AUTORIZADO);
        String correo = (String) session.getAttribute(S_CORREO);

        if (autorizado == null || !autorizado || correo == null) {
            out.print(json("error", "La sesión expiró. Vuelve a solicitar un código."));
            return;
        }

        String nuevaPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String error = validarPassword(nuevaPassword, confirmPassword);
        if (error != null) {
            out.print(json("error", error));
            return;
        }

        // Un mismo correo podría estar en las dos tablas; se actualiza donde exista.
        boolean actualizada = false;
        if (alumnoDao.existeCorreo(correo)) {
            actualizada = alumnoDao.actualizarPasswordPorCorreo(correo, nuevaPassword);
        }
        if (docenteDao.existeCorreo(correo)) {
            actualizada = docenteDao.actualizarPasswordPorCorreo(correo, nuevaPassword) || actualizada;
        }

        if (!actualizada) {
            out.print(json("error", "No se pudo guardar la contraseña. Inténtalo de nuevo."));
            return;
        }

        limpiarRecuperacion(session);
        out.print(json("ok", "Contraseña actualizada."));
    }

    /** Devuelve null si la contraseña es válida, o el mensaje de error correspondiente. */
    private String validarPassword(String nueva, String confirmacion) {
        if (nueva == null || nueva.isEmpty()) {
            return "Escribe tu nueva contraseña.";
        }
        if (!nueva.equals(nueva.trim())) {
            return "La contraseña no puede empezar ni terminar con espacios.";
        }
        if (nueva.length() < PASS_MIN || nueva.length() > PASS_MAX) {
            return "La contraseña debe tener entre " + PASS_MIN + " y " + PASS_MAX + " caracteres.";
        }
        if (!nueva.matches(".*[a-zA-Z].*")) {
            return "La contraseña debe incluir al menos una letra.";
        }
        if (!nueva.matches(".*[0-9].*")) {
            return "La contraseña debe incluir al menos un número.";
        }
        // El navegador ya lo valida, pero el servidor no debe confiar en el navegador.
        if (confirmacion == null || !nueva.equals(confirmacion)) {
            return "Las contraseñas no coinciden.";
        }
        return null;
    }

    /**
     * Compara sin filtrar información por el tiempo de ejecución.
     * String.equals() corta en el primer carácter distinto, lo que en teoría permite
     * deducir el código midiendo tiempos de respuesta.
     */
    private boolean comparacionSegura(String esperado, String recibido) {
        if (esperado == null || recibido == null) return false;
        return MessageDigest.isEqual(
                esperado.getBytes(StandardCharsets.UTF_8),
                recibido.getBytes(StandardCharsets.UTF_8));
    }

    private int enteroDeSesion(HttpSession session, String clave) {
        Object valor = session.getAttribute(clave);
        return valor instanceof Integer ? (Integer) valor : 0;
    }

    /** Borra todo rastro del proceso de recuperación en la sesión. */
    private void limpiarRecuperacion(HttpSession session) {
        session.removeAttribute(S_CORREO);
        session.removeAttribute(S_CODIGO);
        session.removeAttribute(S_EXPIRA);
        session.removeAttribute(S_INTENTOS);
        session.removeAttribute(S_AUTORIZADO);
        // S_ULTIMO_ENVIO y S_ENVIOS se conservan a propósito: son el freno antiabuso.
    }

    /** Construye el JSON escapando los caracteres que romperían el formato. */
    private String json(String status, String message) {
        return "{\"status\":\"" + escapar(status) + "\",\"message\":\"" + escapar(message) + "\"}";
    }

    private String escapar(String texto) {
        if (texto == null) return "";
        StringBuilder sb = new StringBuilder(texto.length() + 16);
        for (int i = 0; i < texto.length(); i++) {
            char c = texto.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}