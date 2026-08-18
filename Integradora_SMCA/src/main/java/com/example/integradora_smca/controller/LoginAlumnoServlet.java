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
        String horaEntrada = request.getParameter("horaEntrada"); // Obtenido del campo hidden
        String horaSalida = request.getParameter("hora");         // El campo de hora que ven en pantalla

        if (matricula == null || matricula.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || numeroPc == null || numeroPc.trim().isEmpty()
                || aula == null || aula.trim().isEmpty()
                || horaSalida == null || horaSalida.trim().isEmpty()
                || horaEntrada == null || horaEntrada.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Por favor, completa todos los campos del formulario.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        Alumno alumno = alumnoDao.login(matricula.trim(), password);

        if (alumno != null) {
            // Mandamos tanto hora_inicio (horaEntrada) como hora_final (horaSalida)
            boolean entradaGuardada = bitacoraDao.registrarEntrada(
                    alumno.getMatricula(),
                    numeroPc.trim(),
                    aula.trim(),
                    horaEntrada.trim(),
                    horaSalida.trim()
            );

            if (!entradaGuardada) {
                request.setAttribute("errorMessage", "Error: No se pudo registrar tu acceso. Verifica el aula seleccionada.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogueado", alumno);
            session.setAttribute("usuario", alumno);
            session.setAttribute("rol", "Alumno");

            session.setAttribute("alumno_matricula", alumno.getMatricula());
            session.setAttribute("numeroPc", numeroPc.trim());
            session.setAttribute("aula", aula.trim());
            session.setAttribute("horaInicio", horaEntrada.trim());
            session.setAttribute("horaFinal", horaSalida.trim()); // Se guarda en sesión si lo ocupas después

            response.sendRedirect(request.getContextPath() + "/PerfilAlumnoServlet");
        } else {
            request.setAttribute("errorMessage", "Matrícula o contraseña incorrectas.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}