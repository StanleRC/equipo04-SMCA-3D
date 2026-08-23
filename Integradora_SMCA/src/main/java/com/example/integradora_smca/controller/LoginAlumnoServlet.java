package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;
import com.example.integradora_smca.model.dao.BitacoraDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/loginServlet")
public class LoginAlumnoServlet extends HttpServlet {

    private AlumnoDao alumnoDao;
    private BitacoraDao bitacoraDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
        bitacoraDao = new BitacoraDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String matricula = request.getParameter("matricula");
        String password = request.getParameter("password");
        String numeroPc = request.getParameter("numeroPc");
        String aula = request.getParameter("aula");

        /*
         * Ya NO se lee la hora de salida del formulario.
         *
         * El alumno la elegía al ENTRAR, antes de usar el equipo, y por eso la
         * base quedó con registros como 22:15 -> 13:15 o 22:18 -> 00:18: sesiones
         * que terminan antes de empezar. La hora real de salida es cuando cierra
         * sesión, así que hora_final se llena en LogoutServlet.
         *
         * Puedes borrar el campo de hora y el hidden "horaEntrada" de index.jsp.
         */

        if (vacio(matricula) || vacio(password) || vacio(numeroPc) || vacio(aula)) {
            request.setAttribute("errorMessage", "Por favor, completa todos los campos del formulario.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        Alumno alumno = alumnoDao.login(matricula.trim(), password);

        if (alumno == null) {
            request.setAttribute("errorMessage", "Matrícula o contraseña incorrectas.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // Se abre la sesión de uso: hora_inicio = ahora, hora_final queda en NULL.
        boolean entradaGuardada = bitacoraDao.registrarEntrada(
                alumno.getMatricula(), numeroPc.trim(), aula.trim());

        if (!entradaGuardada) {
            request.setAttribute("errorMessage",
                    "No se pudo registrar tu acceso. Verifica el aula seleccionada.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // Sesión nueva tras autenticar: evita la fijación de sesión.
        HttpSession vieja = request.getSession(false);
        if (vieja != null) {
            vieja.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("usuarioLogueado", alumno);
        session.setAttribute("alumno", alumno);
        session.setAttribute("usuario", alumno);
        session.setAttribute("rol", "Alumno");

        session.setAttribute("alumno_matricula", alumno.getMatricula());
        session.setAttribute("numeroPc", numeroPc.trim());
        session.setAttribute("aula", aula.trim());

        response.sendRedirect(request.getContextPath() + "/views/alumno/historial_alumno.jsp");
    }

    private boolean vacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}