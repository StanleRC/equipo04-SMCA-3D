package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Alimenta /views/admin/buscador.jsp.
 *
 * Antes esa vista se abría directo como .jsp, así que el atributo "listaAlumnos"
 * nunca existía y la tabla siempre caía en el c:otherwise que pintaba 6 filas
 * vacías. Por eso parecía que el buscador "no traía nada".
 *
 * IMPORTANTE: en el sidebar, el enlace de "Buscar" debe apuntar a
 *   ${pageContext.request.contextPath}/BuscarAlumnosServlet
 * y NO a /views/admin/buscador.jsp.
 */
@WebServlet("/BuscarAlumnosServlet")
public class BuscarAlumnosServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Sin esto, los acentos y las ñ del cuadro de búsqueda llegan rotos.
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String termino = request.getParameter("q");
        termino = (termino == null) ? "" : termino.trim();

        List<Map<String, Object>> listaAlumnos = alumnoDao.buscarAlumnos(termino);

        request.setAttribute("listaAlumnos", listaAlumnos);
        request.setAttribute("terminoBusqueda", termino);

        request.getRequestDispatcher("/views/admin/buscador.jsp")
                .forward(request, response);
    }
}