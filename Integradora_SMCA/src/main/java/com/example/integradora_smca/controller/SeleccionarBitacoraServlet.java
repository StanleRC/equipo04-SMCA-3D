package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.BitacoraDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Pantalla de selección de laboratorio para la bitácora.
 *
 * Es el gemelo de IncidenciasServlet: mismo patrón, distinto destino.
 * El enlace "Bitácora" del sidebar debe apuntar aquí, no al .jsp directo.
 */
@WebServlet("/SeleccionarBitacoraServlet")
public class SeleccionarBitacoraServlet extends HttpServlet {

    private BitacoraDao bitacoraDao;

    @Override
    public void init() throws ServletException {
        bitacoraDao = new BitacoraDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        List<Map<String, Object>> laboratorios = bitacoraDao.listarLaboratorios();

        /*
         * LinkedHashMap y no HashMap: conserva el orden del ORDER BY edificio, aula,
         * así los grupos no bailan de posición entre una recarga y otra.
         */
        Map<String, List<Map<String, Object>>> porEdificio = new LinkedHashMap<>();

        for (Map<String, Object> lab : laboratorios) {
            String edificio = lab.get("edificio") == null
                    ? "Sin edificio"
                    : String.valueOf(lab.get("edificio"));

            porEdificio.computeIfAbsent(edificio, k -> new ArrayList<>()).add(lab);
        }

        request.setAttribute("laboratoriosPorEdificio", porEdificio);
        request.setAttribute("totalLaboratorios", laboratorios.size());

        request.getRequestDispatcher("/views/admin/seleccionar_bitacora.jsp")
                .forward(request, response);
    }
}