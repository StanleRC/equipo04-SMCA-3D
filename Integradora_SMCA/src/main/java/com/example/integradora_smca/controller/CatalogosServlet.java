package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.GrupoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 * Entrega carreras y grupos en JSON para llenar los <select> de los formularios.
 *
 * Antes esas opciones estaban escritas a mano en el HTML, con un solo grupo
 * ('DSM3D'). Al dar de alta un grupo nuevo no aparecía en ningún formulario y
 * había que editar cada JSP.
 *
 * NO exige sesión a propósito: el registro directo de alumno es una pantalla
 * pública y necesita esta lista antes de que exista un usuario. Los nombres de
 * carreras y grupos no son información sensible.
 */
@WebServlet("/CatalogosServlet")
public class CatalogosServlet extends HttpServlet {

    private GrupoDao grupoDao;

    @Override
    public void init() throws ServletException {
        grupoDao = new GrupoDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");

        // ?carrera=DSM devuelve solo los grupos de esa carrera.
        String carrera = request.getParameter("carrera");

        List<Map<String, Object>> carreras = grupoDao.listarCarreras();
        List<Map<String, Object>> grupos = (carrera == null || carrera.trim().isEmpty())
                ? grupoDao.listarGrupos()
                : grupoDao.listarGruposPorCarrera(carrera);

        StringBuilder json = new StringBuilder("{\"carreras\":[");

        for (int i = 0; i < carreras.size(); i++) {
            Map<String, Object> c = carreras.get(i);
            if (i > 0) json.append(',');
            json.append('{')
                    .append(campo("idCarrera", c.get("idCarrera"))).append(',')
                    .append(campo("nombreCarrera", c.get("nombreCarrera")))
                    .append('}');
        }

        json.append("],\"grupos\":[");

        for (int i = 0; i < grupos.size(); i++) {
            Map<String, Object> g = grupos.get(i);
            if (i > 0) json.append(',');
            json.append('{')
                    .append(campo("idGrupo", g.get("idGrupo"))).append(',')
                    .append(campo("etiqueta", g.get("etiqueta"))).append(',')
                    .append(campo("grado", g.get("grado"))).append(',')
                    .append(campo("letra", g.get("letra"))).append(',')
                    .append(campo("idCarrera", g.get("idCarrera"))).append(',')
                    .append(campo("nombreCarrera", g.get("nombreCarrera")))
                    .append('}');
        }

        json.append("]}");

        try (PrintWriter out = response.getWriter()) {
            out.print(json);
        }
    }

    private String campo(String clave, Object valor) {
        return "\"" + clave + "\":\"" + escapar(valor == null ? "" : String.valueOf(valor)) + "\"";
    }

    /** Escapa lo que rompería el JSON: los nombres de carrera llevan acentos y comas. */
    private String escapar(String texto) {
        StringBuilder sb = new StringBuilder(texto.length() + 16);

        for (int i = 0; i < texto.length(); i++) {
            char c = texto.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int) c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        return sb.toString();
    }
}