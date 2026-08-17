package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.IncidenciaDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ValidarIncidenciasServlet", value = "/ValidarIncidenciasServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2 MB
        maxFileSize = 1024 * 1024 * 10,       // 10 MB
        maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class ValidarIncidenciasServlet extends HttpServlet {

    private final IncidenciaDao incidenciaDao = new IncidenciaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String labParam = request.getParameter("lab");

        if (labParam == null || labParam.trim().isEmpty()) {
            labParam = "CC2";
        } else {
            labParam = labParam.trim();
        }

        List<Map<String, Object>> listaIncidencias;

        if (!"Todos".equalsIgnoreCase(labParam)) {
            listaIncidencias = incidenciaDao.listarIncidenciasPorLaboratorio(labParam);
        } else {
            listaIncidencias = incidenciaDao.listarIncidencias();
        }

        request.setAttribute("listaIncidencias", listaIncidencias);
        request.setAttribute("labActual", labParam);

        request.getRequestDispatcher("/views/admin/validar_incidencia.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String labParam = request.getParameter("lab");
        String redirectLab = (labParam != null && !labParam.trim().isEmpty()) ? "&lab=" + labParam.trim() : "";

        String idReporteStr = request.getParameter("idReporte");
        if (idReporteStr == null || idReporteStr.trim().isEmpty()) {
            idReporteStr = request.getParameter("idIncidencia");
        }

        String accion = request.getParameter("accion");

        if (idReporteStr == null || idReporteStr.trim().isEmpty() || accion == null) {
            response.sendRedirect(request.getContextPath() + "/ValidarIncidenciasServlet?msj=error" + redirectLab);
            return;
        }

        try {
            int idReporte = Integer.parseInt(idReporteStr.trim());
            boolean exito = incidenciaDao.procesarRevisionAdmin(idReporte, accion);

            if (exito) {
                response.sendRedirect(request.getContextPath() + "/ValidarIncidenciasServlet?msj=ok" + redirectLab);
            } else {
                response.sendRedirect(request.getContextPath() + "/ValidarIncidenciasServlet?msj=error" + redirectLab);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ValidarIncidenciasServlet?msj=error" + redirectLab);
        }
    }
}