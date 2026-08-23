package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.UsuarioPersonal;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Acciones del administrador sobre un alumno: deshabilitar, reactivar y eliminar.
 *
 * Responde siempre JSON porque la tabla del buscador se actualiza sin recargar.
 *
 * La comprobación de rol está aquí, no solo en el JSP. Esconder los botones es
 * comodidad visual; un docente podría llamar a esta URL directamente.
 */
@WebServlet("/AlumnoAccionesServlet")
public class AlumnoAccionesServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().print(json("error", "Tu sesión expiró. Vuelve a iniciar sesión."));
            return;
        }

        if (!esAdministrador(session)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().print(json("error", "Solo el administrador puede hacer esto."));
            log("[AlumnoAcciones] Intento de acción sin permisos de administrador.");
            return;
        }

        String matricula = request.getParameter("matricula");
        String accion = request.getParameter("accion");

        if (matricula == null || matricula.trim().isEmpty() || accion == null) {
            response.getWriter().print(json("error", "Faltan datos para procesar la acción."));
            return;
        }

        matricula = matricula.trim();

        switch (accion.trim().toLowerCase()) {

            case "deshabilitar":
                responder(response,
                        alumnoDao.cambiarEstadoAlumno(matricula, false),
                        "El alumno quedó deshabilitado.",
                        "No se pudo deshabilitar al alumno.");
                break;

            case "reactivar":
                responder(response,
                        alumnoDao.cambiarEstadoAlumno(matricula, true),
                        "El alumno volvió a quedar activo.",
                        "No se pudo reactivar al alumno.");
                break;

            case "eliminar":
                /*
                 * Las llaves foráneas de BITACORA y REPORTE_FALLA son
                 * ON DELETE CASCADE: esto borra también todo el historial de
                 * accesos del alumno y sus reportes de falla. Por eso el JSP
                 * pide una confirmación escrita antes de llegar aquí.
                 */
                responder(response,
                        alumnoDao.delete(matricula),
                        "El alumno y su historial fueron eliminados.",
                        "No se pudo eliminar al alumno.");
                break;

            default:
                response.getWriter().print(json("error", "Acción no reconocida."));
        }
    }

    private void responder(HttpServletResponse response, boolean exito,
                           String mensajeOk, String mensajeError) throws IOException {
        response.getWriter().print(exito
                ? json("ok", mensajeOk)
                : json("error", mensajeError));
    }

    /** Mismo criterio que el sidebar: un solo lugar decide qué es ser admin. */
    private boolean esAdministrador(HttpSession session) {

        Object marca = session.getAttribute("esAdmin");
        if (marca instanceof Boolean) {
            return (Boolean) marca;
        }

        Object usuario = session.getAttribute("usuarioLogueado");
        if (usuario == null) usuario = session.getAttribute("docente");
        if (usuario == null) usuario = session.getAttribute("administrador");

        return (usuario instanceof UsuarioPersonal)
                && ((UsuarioPersonal) usuario).isAdministrador();
    }

    private String json(String estado, String mensaje) {
        String limpio = mensaje == null ? "" : mensaje
                .replace("\\", "\\\\")
                .replace("\"", "\\\"");
        return "{\"status\":\"" + estado + "\",\"message\":\"" + limpio + "\"}";
    }
}