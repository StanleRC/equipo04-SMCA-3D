package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.IncidenciaDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet("/ValidarIncidenciasServlet")
public class ValidarIncidenciasServlet extends HttpServlet {

    private final IncidenciaDao incidenciaDao = new IncidenciaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String laboratorio = request.getParameter("lab");

        if (laboratorio == null || laboratorio.trim().isEmpty() || "Todos".equalsIgnoreCase(laboratorio.trim())) {
            request.setAttribute("laboratorioSeleccionado", "Todos");
            request.setAttribute("edificioSeleccionado", "Todos");
            request.setAttribute("aulaSeleccionada", "");
            request.setAttribute("incidencias", incidenciaDao.listarIncidencias(null));
        } else {
            String lab = laboratorio.trim().toUpperCase(Locale.ROOT);
            request.setAttribute("laboratorioSeleccionado", lab);
            request.setAttribute("edificioSeleccionado", obtenerEdificio(lab));
            request.setAttribute("aulaSeleccionada", formatearAula(lab));
            request.setAttribute("incidencias", incidenciaDao.listarIncidencias(lab));
        }

        RequestDispatcher rd = request.getRequestDispatcher("/views/admin/tabla_incidencias_validar.jsp");
        rd.forward(request, response);
    }

    private String obtenerEdificio(String laboratorio) {
        if (laboratorio == null || laboratorio.isBlank()) {
            return "Todos";
        }

        if (laboratorio.startsWith("CC")) {
            if ("CC1".equalsIgnoreCase(laboratorio) || "CC2".equalsIgnoreCase(laboratorio)) {
                return "CEDIM";
            }
            return "CECADEC";
        }

        if (laboratorio.startsWith("CA")) {
            return "Docencia 4";
        }

        if (laboratorio.startsWith("LAB")) {
            return "Laboratorio";
        }

        return "Laboratorio";
    }

    private String formatearAula(String laboratorio) {
        if (laboratorio == null || laboratorio.isBlank()) {
            return "";
        }

        String prefijo = laboratorio.replaceAll("[0-9]", "");
        String numero = laboratorio.replaceAll("[^0-9]", "");

        if (numero.isEmpty()) {
            return laboratorio;
        }

        return prefijo + " " + numero;
    }
}