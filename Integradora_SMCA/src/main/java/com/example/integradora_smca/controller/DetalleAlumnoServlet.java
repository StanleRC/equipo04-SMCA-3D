package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.HistorialAlumnoDto;
import com.example.integradora_smca.model.UsuarioPersonal;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Detalle de un alumno visto desde el buscador.
 *
 * El buscador original enlazaba a /views/admin/perfil_alumno.jsp?id=..., pero
 * ese archivo no existe y la tabla alumno tampoco tiene columna "id": su llave
 * primaria es la matrícula.
 */
@WebServlet("/DetalleAlumnoServlet")
public class DetalleAlumnoServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String matricula = request.getParameter("matricula");

        if (matricula == null || matricula.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/BuscarAlumnosServlet");
            return;
        }

        matricula = matricula.trim();

        Alumno alumno = alumnoDao.getPerfilCompletoByMatricula(matricula);

        if (alumno == null) {
            /*
             * Ojo al depurar: este null también aparece cuando la consulta
             * falla por SQL, no solo cuando el alumno no existe. Si ves este
             * aviso con una matrícula que sí está en la base, revisa la consola
             * de Tomcat buscando un ORA- en getPerfilCompletoByMatricula.
             */
            response.sendRedirect(request.getContextPath()
                    + "/BuscarAlumnosServlet?aviso=noexiste");
            return;
        }

        List<HistorialAlumnoDto> historial = alumnoDao.getHistorialByMatricula(matricula);

        request.setAttribute("alumnoDetalle", alumno);
        request.setAttribute("listaHistorial", historial);

        // La vista los necesita para decidir qué botones dibuja.
        request.setAttribute("esAdmin", esAdministrador(session));
        request.setAttribute("alumnoActivo", alumnoDao.estaActivo(matricula));

        request.getRequestDispatcher("/views/admin/detalle_alumno.jsp")
                .forward(request, response);
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
}