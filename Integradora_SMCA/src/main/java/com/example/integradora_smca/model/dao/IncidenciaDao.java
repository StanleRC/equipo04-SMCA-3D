package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IncidenciaDao {

    private String seguro(String valor) {
        return (valor != null && !valor.trim().isEmpty()) ? valor.trim() : null;
    }

    /**
     * 1. ALUMNO: Registra la Bitácora y opcionalmente el REPORTE_FALLA.
     */
    public boolean guardarIncidenciaAlumno(String descripcionFalla, String prioridad, String numeroPc,
                                           String idLaboratorio, String matriculaAlumno, String horaFin) {

        String sqlBitacora = "INSERT INTO bitacora (numero_pc, id_laboratorio, fecha, hora_inicio, hora_final, alumno_matricula) "
                + "VALUES (?, ?, SYSDATE, TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'America/Mexico_City', 'HH24:MI'), ?, ?)";

        String sqlReporte = "INSERT INTO reporte_falla (id_bitacora, descripcion_falla, fecha_reporte, prioridad, estado) "
                + "VALUES (?, ?, CURRENT_TIMESTAMP, ?, 'Pendiente')";

        Connection con = null;
        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            long idBitacoraGenerado = -1;
            int idLabNum = Integer.parseInt(idLaboratorio.trim());

            // 1. Insertar en BITACORA
            try (PreparedStatement psBitacora = con.prepareStatement(sqlBitacora, new String[]{"ID_BITACORA"})) {
                psBitacora.setString(1, seguro(numeroPc));
                psBitacora.setInt(2, idLabNum);
                psBitacora.setString(3, seguro(horaFin));
                psBitacora.setString(4, seguro(matriculaAlumno));

                psBitacora.executeUpdate();

                try (ResultSet rs = psBitacora.getGeneratedKeys()) {
                    if (rs.next()) {
                        idBitacoraGenerado = rs.getLong(1);
                    }
                }
            }

            if (idBitacoraGenerado == -1) {
                throw new SQLException("No se pudo obtener el ID_BITACORA.");
            }

            // 2. Insertar en REPORTE_FALLA si existe descripción
            String fallaLimpia = seguro(descripcionFalla);
            if (fallaLimpia != null) {
                try (PreparedStatement psReporte = con.prepareStatement(sqlReporte)) {
                    psReporte.setLong(1, idBitacoraGenerado);
                    psReporte.setString(2, fallaLimpia);
                    psReporte.setString(3, seguro(prioridad) != null ? seguro(prioridad) : "Media");

                    psReporte.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            System.err.println("=== ERROR EN REGISTRO DE BITACORA / REPORTE ===");
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    /**
     * 2. ADMIN: Cambia el estado en REPORTE_FALLA
     */
    public boolean procesarRevisionAdmin(int idReporte, String accionAdmin) {
        String sqlUpdate = "UPDATE reporte_falla SET estado = ? WHERE id_reporte = ?";
        String nuevoEstado = "validar".equalsIgnoreCase(accionAdmin) ? "VALIDA" : "DESCARTADA";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlUpdate)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idReporte);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("=== ERROR EN PROCESAR REVISION ADMIN ===");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 3. ADMIN: Obtiene TODOS los reportes
     */
    public List<Map<String, Object>> listarIncidencias() {
        return listarIncidenciasPorLaboratorio(null);
    }

    /**
     * 4. ADMIN: Obtiene reportes FILTRADOS cruzando BITACORA, ALUMNO, GRUPO y LABORATORIO
     * BLINDADO CONTRA ORA-01722 CON TO_CHAR EN JOINS Y FILTROS.
     */
    public List<Map<String, Object>> listarIncidenciasPorLaboratorio(String aulaOId) {
        List<Map<String, Object>> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT rf.id_reporte, rf.descripcion_falla, rf.prioridad, ")
                .append("TO_CHAR(rf.fecha_reporte, 'DD/MM/YYYY HH24:MI') AS fecha_reporte, ")
                .append("rf.estado AS estado, ")
                .append("b.numero_pc, ")
                .append("a.matricula AS matricula, l.nombre_lab, l.aula, ")
                .append("a.nombre AS nombre_alumno, a.apellido_paterno, a.apellido_materno, ")
                .append("g.grado, g.numero_grupo AS grupo ")
                .append("FROM reporte_falla rf ")
                .append("INNER JOIN bitacora b ON rf.id_bitacora = b.id_bitacora ")
                .append("INNER JOIN alumno a ON b.alumno_matricula = a.matricula ")
                .append("INNER JOIN grupo g ON TO_CHAR(a.grupo_id_grupo) = TO_CHAR(g.id_grupo) ")
                .append("INNER JOIN laboratorio l ON TO_CHAR(b.id_laboratorio) = TO_CHAR(l.id_laboratorio) ");

        String valorLimpio = seguro(aulaOId);
        boolean hayFiltro = valorLimpio != null && !"Todos".equalsIgnoreCase(valorLimpio);

        boolean esNumero = false;
        int idLabNumero = -1;
        if (hayFiltro) {
            try {
                idLabNumero = Integer.parseInt(valorLimpio);
                esNumero = true;
            } catch (NumberFormatException ignored) {
                esNumero = false;
            }
        }

        if (hayFiltro) {
            if (esNumero) {
                sql.append("WHERE l.id_laboratorio = ? ");
            } else {
                sql.append("WHERE UPPER(TO_CHAR(l.aula)) = UPPER(?) ")
                        .append("OR UPPER(TO_CHAR(l.nombre_lab)) LIKE UPPER(?) ");
            }
        }

        sql.append("ORDER BY rf.fecha_reporte DESC");

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            if (hayFiltro) {
                if (esNumero) {
                    ps.setInt(1, idLabNumero);
                } else {
                    ps.setString(1, valorLimpio);
                    ps.setString(2, "%" + valorLimpio + "%");
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new HashMap<>();
                    fila.put("id_reporte", rs.getInt("id_reporte"));
                    fila.put("idReporte", rs.getInt("id_reporte"));
                    fila.put("descripcion_falla", rs.getString("descripcion_falla"));
                    fila.put("incidencia", rs.getString("descripcion_falla"));
                    fila.put("prioridad", rs.getString("prioridad"));
                    fila.put("fecha_reporte", rs.getString("fecha_reporte"));
                    fila.put("fecha", rs.getString("fecha_reporte"));
                    fila.put("estado", rs.getString("estado"));
                    fila.put("numero_pc", rs.getString("numero_pc"));
                    fila.put("pc", rs.getString("numero_pc"));
                    fila.put("nombre_lab", rs.getString("nombre_lab"));
                    fila.put("aula", rs.getString("aula"));
                    fila.put("matricula", rs.getString("matricula"));
                    fila.put("grado", rs.getInt("grado"));
                    fila.put("grupo", rs.getInt("grupo"));

                    // Formatear Nombre Completo
                    String nom = rs.getString("nombre_alumno");
                    String pat = rs.getString("apellido_paterno");
                    String mat = rs.getString("apellido_materno");
                    String nombreCompleto = (nom != null ? nom : "") + " "
                            + (pat != null ? pat : "") + " "
                            + (mat != null ? mat : "");

                    fila.put("nombre_alumno", nombreCompleto.trim());
                    fila.put("nombre", nombreCompleto.trim());

                    lista.add(fila);
                }
            }

        } catch (Exception e) {
            System.err.println("=== ERROR EN FILTRADO POR LAB EN INCIDENCIADAO ===");
            e.printStackTrace();
        }

        return lista;
    }
}