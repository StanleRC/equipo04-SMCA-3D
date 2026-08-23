package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.IncidenciaDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Pantalla de selección de laboratorio para revisar incidencias.
 *
 * Antes incidencias.jsp traía los botones escritos a mano, incluidos CA 5, CA 6
 * y CA 11, que nunca se insertaron en la tabla LABORATORIO. Esos tres siempre
 * mostraban una tabla vacía sin explicar por qué.
 *
 * Ahora la lista sale de la base: si agregas un aula, aparece sola.
 */
@WebServlet("/IncidenciasServlet")
public class IncidenciasServlet extends HttpServlet {

    private IncidenciaDao incidenciaDao;

    @Override
    public void init() throws ServletException {
        incidenciaDao = new IncidenciaDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> laboratorios = incidenciaDao.listarLaboratorios();

        /*
         * LinkedHashMap y no HashMap: conserva el orden en que vienen de la
         * consulta (ORDER BY edificio, aula), así los grupos salen siempre igual
         * y no bailan de posición entre una recarga y otra.
         */
        Map<String, List<Map<String, Object>>> porEdificio = new LinkedHashMap<>();

        for (Map<String, Object> lab : laboratorios) {
            String edificio = lab.get("edificio") == null
                    ? "Sin edificio"
                    : String.valueOf(lab.get("edificio"));

            porEdificio.computeIfAbsent(edificio, k -> new java.util.ArrayList<>()).add(lab);
        }

        request.setAttribute("laboratoriosPorEdificio", porEdificio);
        request.setAttribute("totalLaboratorios", laboratorios.size());

        request.getRequestDispatcher("/views/admin/incidencias.jsp")
                .forward(request, response);
    }
}