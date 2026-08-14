package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IncidenciaDao {

    public Integer buscarIdComputadoraPorNumero(String numeroPc) {
        String sql = "SELECT id_computadora FROM computadora WHERE numero_pc = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, numeroPc.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_computadora");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer buscarIdComputadoraPorNumeroYLaboratorio(String numeroPc, String laboratorio) {
        if (laboratorio == null || laboratorio.trim().isEmpty()) {
            return buscarIdComputadoraPorNumero(numeroPc);
        }

        String sql = "SELECT c.id_computadora " +
                "FROM computadora c " +
                "INNER JOIN laboratorio l ON c.laboratorio_id_laboratorio = l.id_laboratorio " +
                "WHERE c.numero_pc = ? AND l.id_laboratorio = ?";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, numeroPc.trim());
            ps.setString(2, laboratorio.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_computadora");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean guardarIncidencia(String descripcion, String prioridad, int computadoraId) {
        String sql = "INSERT INTO reporte_falla (descripcion_falla, prioridad, computadora_id_computadora) VALUES (?, ?, ?)";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, descripcion.trim());
            ps.setString(2, prioridad);
            ps.setInt(3, computadoraId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> listarIncidencias(String laboratorio) {
        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT rf.id_reporte, rf.descripcion_falla, rf.prioridad, rf.fecha_reporte, " +
                "c.numero_pc, l.id_laboratorio, l.nombre_lab " +
                "FROM reporte_falla rf " +
                "INNER JOIN computadora c ON rf.computadora_id_computadora = c.id_computadora " +
                "INNER JOIN laboratorio l ON c.laboratorio_id_laboratorio = l.id_laboratorio ";

        boolean filtrarPorLaboratorio = laboratorio != null
                && !laboratorio.trim().isEmpty()
                && !"Todos".equalsIgnoreCase(laboratorio.trim());

        if (filtrarPorLaboratorio) {
            sql += "WHERE l.id_laboratorio = ? ";
        }

        sql += "ORDER BY rf.fecha_reporte DESC";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (filtrarPorLaboratorio) {
                ps.setString(1, laboratorio.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new HashMap<>();
                    fila.put("id_reporte", rs.getInt("id_reporte"));
                    fila.put("descripcion_falla", rs.getString("descripcion_falla"));
                    fila.put("prioridad", rs.getString("prioridad"));
                    fila.put("fecha_reporte", rs.getTimestamp("fecha_reporte"));
                    fila.put("numero_pc", rs.getString("numero_pc"));
                    fila.put("id_laboratorio", rs.getString("id_laboratorio"));
                    fila.put("nombre_lab", rs.getString("nombre_lab"));
                    lista.add(fila);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return lista;
    }
}