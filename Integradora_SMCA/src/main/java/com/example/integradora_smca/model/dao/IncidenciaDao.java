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

    public Integer buscarBitacoraActiva(String alumnoMatricula) {
        String sql = "SELECT id_bitacora FROM bitacora WHERE alumno_matricula = ? AND hora_final IS NULL ORDER BY fecha DESC FETCH FIRST 1 ROW ONLY";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, alumnoMatricula.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id_bitacora");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean guardarIncidencia(String descripcion, String prioridad, String numeroPc, String laboratorio,
                                     String horaSalida, String alumnoMatricula, Integer idBitacora) {
        String sql = "INSERT INTO reporte_falla (descripcion_falla, prioridad, numero_pc, id_laboratorio, " +
                "hora_salida, alumno_matricula, id_bitacora) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, descripcion.trim());
            ps.setString(2, prioridad);
            ps.setString(3, numeroPc.trim());
            ps.setString(4, laboratorio.trim());
            ps.setString(5, horaSalida);
            ps.setString(6, alumnoMatricula.trim());
            ps.setObject(7, idBitacora);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> listarIncidencias(String laboratorio) {
        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT rf.id_reporte, rf.descripcion_falla, rf.prioridad, rf.fecha_reporte, " +
                "rf.hora_salida, rf.numero_pc, rf.alumno_matricula, rf.id_bitacora, " +
                "rf.id_laboratorio, l.nombre_lab, a.nombre, a.apellido_paterno, a.apellido_materno " +
                "FROM reporte_falla rf " +
                "INNER JOIN laboratorio l ON rf.id_laboratorio = l.id_laboratorio " +
                "INNER JOIN alumno a ON rf.alumno_matricula = a.matricula ";

        boolean filtrarPorLaboratorio = laboratorio != null
                && !laboratorio.trim().isEmpty()
                && !"Todos".equalsIgnoreCase(laboratorio.trim());

        if (filtrarPorLaboratorio) {
            sql += "WHERE rf.id_laboratorio = ? ";
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
                    fila.put("hora_salida", rs.getString("hora_salida"));
                    fila.put("numero_pc", rs.getString("numero_pc"));
                    fila.put("alumno_matricula", rs.getString("alumno_matricula"));
                    fila.put("nombre_alumno", rs.getString("nombre"));
                    fila.put("apellido_paterno", rs.getString("apellido_paterno"));
                    fila.put("apellido_materno", rs.getString("apellido_materno"));
                    fila.put("id_bitacora", rs.getObject("id_bitacora"));
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