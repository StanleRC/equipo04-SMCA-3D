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

/**
 * Consultas sobre BITACORA: quién usó qué equipo y en qué horario.
 *
 * Sobre la columna "Estado":
 * la tabla bitacora NO tiene ninguna columna de estado. El Validado / Pendiente
 * / Descartado que se ve en la pantalla es el del reporte de falla ligado a esa
 * fila (reporte_falla.estado_reporte), por eso se hace LEFT JOIN. Si el alumno
 * no levantó ningún reporte, se muestra "Sin reporte".
 */
public class BitacoraDao {

    /** descripcion_falla es CLOB: TO_CHAR revienta si pasa de 4000 caracteres. */
    private static final int MAX_DESCRIPCION = 500;

    private static final String SELECT_BASE =
            "SELECT b.id_bitacora, " +
                    "       l.aula, " +
                    "       l.edificio, " +
                    "       b.numero_pc, " +
                    "       a.matricula, " +
                    "       (a.nombre || ' ' || a.apellido_paterno || ' ' || a.apellido_materno) AS nombre_completo, " +
                    "       g.grado, " +
                    "       g.numero_grupo, " +
                    // Antes la fecha salía como '2026-08-19 04:35:45'. El TO_CHAR la deja legible.
                    "       TO_CHAR(b.fecha, 'DD/MM/YYYY')    AS fecha, " +
                    "       TO_CHAR(b.hora_inicio, 'HH24:MI') AS hora_inicio, " +
                    "       TO_CHAR(b.hora_final, 'HH24:MI')  AS hora_final, " +
                    "       r.id_reporte, " +
                    "       DBMS_LOB.SUBSTR(r.descripcion_falla, " + MAX_DESCRIPCION + ", 1) AS descripcion, " +
                    "       NVL(r.estado_reporte, 'Sin reporte') AS estado " +
                    "FROM bitacora b " +
                    "INNER JOIN alumno a      ON UPPER(TRIM(a.matricula)) = UPPER(TRIM(b.alumno_matricula)) " +
                    "INNER JOIN grupo g       ON g.id_grupo = a.grupo_id_grupo " +
                    "INNER JOIN laboratorio l ON l.id_laboratorio = b.id_laboratorio " +
                    "LEFT  JOIN reporte_falla r ON r.id_bitacora = b.id_bitacora ";

    // ------------------------------------------------------------------
    // Consultas
    // ------------------------------------------------------------------

    /**
     * Bitácora de un aula. Si el aula viene vacía o es "Todos", devuelve todo.
     *
     * @param aula el valor de ?lab=, por ejemplo "CC10". Corresponde a
     *             laboratorio.aula, no a un id numérico.
     */
    public List<Map<String, Object>> obtenerBitacoraPorAula(String aula) {

        boolean todos = (aula == null || aula.trim().isEmpty() || "Todos".equalsIgnoreCase(aula.trim()));

        String sql = todos
                ? SELECT_BASE + "ORDER BY b.fecha DESC, b.hora_inicio DESC"
                : SELECT_BASE + "WHERE UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "ORDER BY b.fecha DESC, b.hora_inicio DESC";

        return ejecutar(sql, todos ? null : aula.trim());
    }

    /** Toda la bitácora, de todos los laboratorios. */
    public List<Map<String, Object>> listarBitacora() {
        return obtenerBitacoraPorAula(null);
    }

    /** Alias, por si alguna pantalla vieja llama a este nombre. */
    public List<Map<String, Object>> listarBitacoraPorLaboratorio(String aula) {
        return obtenerBitacoraPorAula(aula);
    }

    /** Solo las sesiones que siguen abiertas (hora_final todavía nula). */
    public List<Map<String, Object>> listarSesionesAbiertas(String aula) {
        boolean todos = (aula == null || aula.trim().isEmpty() || "Todos".equalsIgnoreCase(aula.trim()));

        String sql = todos
                ? SELECT_BASE + "WHERE b.hora_final IS NULL ORDER BY b.hora_inicio DESC"
                : SELECT_BASE + "WHERE b.hora_final IS NULL "
                + "AND UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "ORDER BY b.hora_inicio DESC";

        return ejecutar(sql, todos ? null : aula.trim());
    }

    /** Laboratorios existentes, para armar la pantalla de selección. */
    public List<Map<String, Object>> listarLaboratorios() {
        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT id_laboratorio, aula, edificio, nombre_lab " +
                "FROM laboratorio ORDER BY edificio, aula";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("idLaboratorio", rs.getInt("id_laboratorio"));
                fila.put("aula", rs.getString("aula"));
                fila.put("edificio", rs.getString("edificio"));
                fila.put("nombreLab", rs.getString("nombre_lab"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println(">>> [BitacoraDao] Error al listar laboratorios: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    // ------------------------------------------------------------------
    // Apoyo
    // ------------------------------------------------------------------

    private List<Map<String, Object>> ejecutar(String sql, String parametro) {
        List<Map<String, Object>> lista = new ArrayList<>();

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (parametro != null) {
                ps.setString(1, parametro);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new HashMap<>();
                    fila.put("idBitacora", rs.getInt("id_bitacora"));
                    fila.put("salon", rs.getString("aula"));
                    fila.put("edificio", rs.getString("edificio"));
                    fila.put("numeroPc", rs.getString("numero_pc"));
                    fila.put("matricula", rs.getString("matricula"));
                    fila.put("nombreCompleto", rs.getString("nombre_completo"));
                    fila.put("grado", rs.getString("grado"));
                    fila.put("grupo", rs.getString("numero_grupo"));
                    fila.put("fecha", rs.getString("fecha"));
                    fila.put("horaInicio", rs.getString("hora_inicio"));
                    fila.put("horaFinal", rs.getString("hora_final"));
                    fila.put("incidencia", rs.getString("descripcion"));
                    fila.put("estado", rs.getString("estado"));

                    // getInt devuelve 0 cuando la columna es NULL, así que se comprueba aparte:
                    // 0 significaría "reporte número cero", que no existe.
                    int idReporte = rs.getInt("id_reporte");
                    fila.put("idReporte", rs.wasNull() ? null : idReporte);

                    lista.add(fila);
                }
            }
        } catch (SQLException e) {
            System.err.println(">>> [BitacoraDao] Error al listar la bitácora: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Registra la entrada de un alumno a un equipo.
     *
     * Orden de parámetros según LoginAlumnoServlet:
     *   matricula, numeroPc, aula, horaEntrada, horaSalida
     *
     * hora_inicio y hora_final son TIMESTAMP, así que las horas HH:MM del
     * formulario se combinan con la fecha de hoy.
     */
    public boolean registrarEntrada(String matricula, String numeroPc, String aula,
                                    String horaEntrada, String horaSalida) {

        if (matricula == null || matricula.trim().isEmpty()
                || aula == null || aula.trim().isEmpty()) {
            System.err.println(">>> [BitacoraDao] Falta matrícula o aula.");
            return false;
        }

        boolean tieneEntrada = horaEntrada != null && !horaEntrada.trim().isEmpty();
        boolean tieneSalida = horaSalida != null && !horaSalida.trim().isEmpty();

        String expEntrada = tieneEntrada
                ? "TO_TIMESTAMP(TO_CHAR(SYSDATE,'DD/MM/YYYY') || ' ' || ?, 'DD/MM/YYYY HH24:MI')"
                : "SYSTIMESTAMP";

        String expSalida = tieneSalida
                ? "TO_TIMESTAMP(TO_CHAR(SYSDATE,'DD/MM/YYYY') || ' ' || ?, 'DD/MM/YYYY HH24:MI')"
                : "NULL";

        // El aula llega como "CC10", no como id: se resuelve con la subconsulta.
        String sql = "INSERT INTO bitacora "
                + "(fecha, hora_inicio, hora_final, numero_pc, alumno_matricula, id_laboratorio) "
                + "VALUES (SYSDATE, " + expEntrada + ", " + expSalida + ", ?, ?, "
                + "        (SELECT id_laboratorio FROM laboratorio "
                + "         WHERE UPPER(TRIM(aula)) = UPPER(TRIM(?))))";

        Connection con = null;
        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            int filas;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int i = 1;
                if (tieneEntrada) ps.setString(i++, horaEntrada.trim());
                if (tieneSalida) ps.setString(i++, horaSalida.trim());
                ps.setString(i++, numeroPc == null ? null : numeroPc.trim());
                ps.setString(i++, matricula.trim());
                ps.setString(i, aula.trim());

                filas = ps.executeUpdate();
            }

            if (filas > 0) {
                con.commit();
                return true;
            }

            con.rollback();
            return false;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            // Si el aula no existe en LABORATORIO, la subconsulta da NULL y
            // revienta por la restricción NOT NULL de id_laboratorio.
            System.err.println(">>> [BitacoraDao] Error al registrar la entrada: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ignored) { }
                try { con.close(); } catch (SQLException ignored) { }
            }
        }
    }
}