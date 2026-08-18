package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Administrador;
import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.model.UsuarioPersonal;
import com.example.integradora_smca.model.dao.AdministradorDao;
import com.example.integradora_smca.model.dao.DocenteDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Login del personal: docentes y administradores.
 *
 * Los dos viven en tablas distintas, así que se intenta primero en DOCENTE y,
 * si no hay coincidencia, en ADMINISTRADOR. Lo que se guarda en sesión es el
 * objeto concreto, pero todo lo demás del sistema lo lee a través de
 * UsuarioPersonal, así que no le importa de cuál tabla salió.
 */
@WebServlet("/loginDocenteServlet")
public class LoginDocenteServlet extends HttpServlet {

    private DocenteDao docenteDao;
    private AdministradorDao administradorDao;

    private static final String VISTA_LOGIN = "/admin-docente_login.jsp";

    @Override
    public void init() throws ServletException {
        docenteDao = new DocenteDao();
        administradorDao = new AdministradorDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher(VISTA_LOGIN).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String usuarioOrCorreo = primerValor(request, "correo", "txtCorreo", "usuario");
        String password = primerValor(request, "password", "txtPassword");

        if (usuarioOrCorreo == null || password == null) {
            regresarConError(request, response, "Por favor, completa todos los campos.");
            return;
        }

        UsuarioPersonal usuario = autenticar(usuarioOrCorreo, password);

        if (usuario == null) {
            // Mismo mensaje siempre: no revela si el correo existe ni en qué tabla está.
            regresarConError(request, response, "Correo o contraseña incorrectos.");
            return;
        }

        // Sesión nueva tras autenticar: evita la fijación de sesión.
        HttpSession vieja = request.getSession(false);
        if (vieja != null) {
            vieja.invalidate();
        }
        HttpSession session = request.getSession(true);

        guardarEnSesion(session, usuario);

        response.sendRedirect(request.getContextPath()
                + "/views/admin/perfil_admin-docente.jsp");
    }

    /** Primero docente, luego administrador. Devuelve null si ninguno coincide. */
    private UsuarioPersonal autenticar(String usuarioOrCorreo, String password) {

        Docente docente = docenteDao.loginByCorreo(usuarioOrCorreo, password);
        if (docente == null) {
            docente = docenteDao.login(usuarioOrCorreo, password);
        }
        if (docente != null) {
            return docente;
        }

        return administradorDao.loginByCorreo(usuarioOrCorreo, password);
    }

    private void guardarEnSesion(HttpSession session, UsuarioPersonal usuario) {

        /*
         * Atributos que ya usaban tus JSP. Se conservan para no romper nada,
         * y todos apuntan al mismo objeto.
         */
        session.setAttribute("usuarioLogueado", usuario);
        session.setAttribute("usuario", usuario);
        session.setAttribute("nombreUsuario", usuario.getNombreCompleto());
        session.setAttribute("usuarioFoto", usuario.getFotoPerfil());

        /*
         * Estos dos son los que deben usar el sidebar y FiltroSoloAdmin.
         * Preguntar por el número de rol o por instanceof en cada pantalla es
         * justo lo que provocaba las inconsistencias.
         */
        session.setAttribute("esAdmin", usuario.isAdministrador());
        session.setAttribute("rolTexto", usuario.getRolTexto());

        // Atributos históricos, por si alguna vista vieja todavía los consulta.
        if (usuario instanceof Docente) {
            session.setAttribute("docente", usuario);
            session.setAttribute("docenteLogueado", usuario);
        } else if (usuario instanceof Administrador) {
            session.setAttribute("administrador", usuario);
            // El sidebar histórico lee sessionScope.docente; se apunta al mismo objeto
            // para que un administrador vea su nombre y su foto sin cambiar la vista.
            session.setAttribute("docente", usuario);
        }

        session.setAttribute("rol", usuario.isAdministrador() ? "Admin" : "Docente");
    }

    /** Devuelve el primer parámetro con contenido, o null si ninguno lo tiene. */
    private String primerValor(HttpServletRequest request, String... nombres) {
        for (String nombre : nombres) {
            String valor = request.getParameter(nombre);
            if (valor != null && !valor.trim().isEmpty()) {
                return valor.trim();
            }
        }
        return null;
    }

    private void regresarConError(HttpServletRequest request, HttpServletResponse response,
                                  String mensaje) throws ServletException, IOException {
        request.setAttribute("errorMessage", mensaje);
        request.getRequestDispatcher(VISTA_LOGIN).forward(request, response);
    }
}