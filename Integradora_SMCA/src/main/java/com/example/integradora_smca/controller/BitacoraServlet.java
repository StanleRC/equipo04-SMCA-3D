package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.BitacoraDao;

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
 * Muestra la bitácora de accesos de un aula.
 *
 * El parámetro ?lab= corresponde a laboratorio.aula ("CC10", "CA1"), no a un id.
 */
@WebServlet("/BitacoraServlet")
public class BitacoraServlet extends HttpServlet {

    private BitacoraDao bitacoraDao;

    @Override
    public void init() throws ServletException {
        bitacoraDao = new BitacoraDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Sin sesión no hay nada que mostrar: son datos de alumnos.
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String aulaSeleccionada = request.getParameter("lab");

        /*
         * El tipo era List<?>, que obliga al JSP a trabajar a ciegas.
         * Con List<Map<String,Object>> queda claro qué llaves trae cada fila
         * y coincide con lo que devuelve el DAO.
         */
        List<Map<String, Object>> listaBitacora =
                bitacoraDao.obtenerBitacoraPorAula(aulaSeleccionada);

        request.setAttribute("listaBitacora", listaBitacora);
        request.setAttribute("labActual",
                (aulaSeleccionada == null || aulaSeleccionada.trim().isEmpty())
                        ? "Todos"
                        : aulaSeleccionada.trim());

        request.getRequestDispatcher("/views/admin/tabla_de_bitacora.jsp")
                .forward(request, response);
    }
}