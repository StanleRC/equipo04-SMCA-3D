package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.IncidenciaDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RegistrarIncidenciaServlet", value = "/RegistrarIncidenciaServlet")
public class RegistrarIncidenciaServlet extends HttpServlet {

    private final IncidenciaDao incidenciaDao = new IncidenciaDao();

    private static final String VISTA_FORMULARIO = "/views/alumno/crear_incidencia_alumno.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VISTA_FORMULARIO).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Datos del formulario. Los nombres deben coincidir con los del JSP.
        String numeroPc = limpiar(request.getParameter("numeroPc"));
        String laboratorio = limpiar(request.getParameter("laboratorio"));
        String prioridad = limpiar(request.getParameter("prioridad"));
        String descripcionFalla = limpiar(request.getParameter("descripcion_falla"));
        String horaFin = limpiar(request.getParameter("horaFin"));

        /*
         * La matrícula NO está en session.getAttribute("matricula").
         *
         * Ese atributo no lo crea nadie en el proyecto: el login guarda el objeto
         * Alumno completo bajo "alumno" y "usuarioLogueado". Al leer "matricula"
         * el resultado siempre era null, así que el servlet rebotaba al index sin
         * decir por qué y ninguna incidencia llegaba a guardarse.
         */
        HttpSession session = request.getSession(false);

        Object usuario = (session != null) ? session.getAttribute("usuarioLogueado") : null;
        if (usuario == null && session != null) {
            usuario = session.getAttribute("alumno");
        }

        String matriculaAlumno = (usuario instanceof Alumno)
                ? ((Alumno) usuario).getMatricula()
                : null;

        if (matriculaAlumno == null || matriculaAlumno.trim().isEmpty()) {
            log("[RegistrarIncidencia] Sesión sin alumno válido.");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Validaciones antes de tocar la base de datos.
        String error = validar(numeroPc, laboratorio, horaFin);
        if (error != null) {
            regresarConError(request, response, error);
            return;
        }

        boolean guardado = incidenciaDao.guardarIncidenciaAlumno(
                descripcionFalla, prioridad, numeroPc, laboratorio, matriculaAlumno, horaFin);

        if (guardado) {
            // Redirect y no forward: así, si el alumno recarga, no se duplica el registro.
            response.sendRedirect(request.getContextPath()
                    + "/views/alumno/confirmacion.jsp?registro=ok");
            return;
        }

        log("[RegistrarIncidencia] El DAO devolvió false para la matrícula " + matriculaAlumno);
        regresarConError(request, response,
                "No se pudo registrar. Verifica que el aula seleccionada exista.");
    }

    /** Devuelve null si todo está bien, o el mensaje que verá el alumno. */
    private String validar(String numeroPc, String laboratorio, String horaFin) {

        if (numeroPc == null || numeroPc.isEmpty()) {
            return "Escribe el número de PC.";
        }

        if (numeroPc.length() > 10) {
            return "El número de PC es demasiado largo.";
        }

        if (laboratorio == null || laboratorio.isEmpty()) {
            return "Selecciona el aula.";
        }

        // El input type="time" manda HH:MM; cualquier otra cosa vendría de un cliente manipulado.
        if (horaFin != null && !horaFin.matches("^([01]\\d|2[0-3]):[0-5]\\d$")) {
            return "La hora de salida no tiene un formato válido.";
        }

        return null;
    }

    private void regresarConError(HttpServletRequest request, HttpServletResponse response,
                                  String mensaje) throws ServletException, IOException {
        request.setAttribute("error", mensaje);
        request.getRequestDispatcher(VISTA_FORMULARIO).forward(request, response);
    }

    /** Recorta y convierte las cadenas vacías en null, que es lo que espera Oracle. */
    private String limpiar(String valor) {
        if (valor == null) return null;
        String limpio = valor.trim();
        return limpio.isEmpty() ? null : limpio;
    }
}