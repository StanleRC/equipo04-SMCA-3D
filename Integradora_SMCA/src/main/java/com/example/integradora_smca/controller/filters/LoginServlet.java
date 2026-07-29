package com.example.integradora_smca.controller.filters;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.example.integradora_smca.model.dao.UsuarioDao;
import com.example.integradora_smca.model.dao.Alumno;
import com.example.integradora_smca.model.dao.Docente;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UsuarioDao usuarioDao = new UsuarioDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recupereamos el texto del input único (sirve como matrícula o correo)
        String inputUsuario = request.getParameter("matricula");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        // 1. Intentamos loguear como Alumno (buscando por matrícula)
        Alumno alumno = usuarioDao.loginAlumno(inputUsuario, password);

        if (alumno != null) {
            session.setAttribute("usuarioLogueado", alumno);
            session.setAttribute("usuarioNombre", alumno.getNombre() + " " + alumno.getApellidoPaterno());
            session.setAttribute("usuarioFoto", alumno.getFotoPerfil());
            session.setAttribute("rol", alumno.getIdRol());

            response.sendRedirect(request.getContextPath() + "/buscador.jsp");
            return;
        }

        // 2. Si no fue alumno, asumimos que ingresó un correo e intentamos como Docente
        Docente docente = usuarioDao.loginDocente(inputUsuario, password);

        if (docente != null) {
            session.setAttribute("usuarioLogueado", docente);
            session.setAttribute("usuarioNombre", docente.getNombre() + " " + docente.getApellidoPaterno());
            session.setAttribute("usuarioFoto", docente.getFotoPerfil());
            session.setAttribute("rol", docente.getIdRol());

            response.sendRedirect(request.getContextPath() + "/buscador.jsp");
            return;
        }

        // 3. Si no es ninguno, credenciales incorrectas
        request.setAttribute("errorMessage", "Matrícula/Correo o contraseña incorrectos.");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}