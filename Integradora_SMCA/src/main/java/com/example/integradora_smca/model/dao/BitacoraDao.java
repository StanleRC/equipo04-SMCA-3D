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
 * bitacora NO tiene columna de estado. El Validado / Pendiente / Descartado que
 * se ve en pantalla es el del reporte de falla ligado a esa fila, por eso el
 * LEFT JOIN. Si el alumno no reportó nada, se muestra "Sin reporte".
 *
 * DIFERENCIAS ENTRE EL SCRIPT DE CREACIÓN Y LA BASE REAL:
 *   grupo.letra_grupo         — el script decía numero_grupo
 *   reporte_falla.estado      — el script decía estado_reporte
 *   bitacora.hora_inicio      — es VARCHAR2 'HH:MM', no TIMESTAMP
 *   bitacora.hora_final       — es VARCHAR2 'HH:MM', no TIMESTAMP
 *   grupo.id_grupo            — no comparte tipo con alumno.grupo_id_grupo
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
                    "       g.letra_grupo AS grupo, " +
                    // fecha SÍ es DATE, así que aquí el TO_CHAR es correcto.
                    "       TO_CHAR(b.fecha, 'DD/MM/YYYY') AS fecha, " +
                    /*
                     * hora_inicio y hora_final son VARCHAR2 y ya guardan '22:18'.
                     * Al aplicarles TO_CHAR(valor, 'HH24:MI'), Oracle asume que el primer
                     * argumento es un número, intenta convertir '22:18' y lanza ORA-01722.
                     * Se leen tal cual.
                     */
                    "       b.hora_inicio, " +
                    "       b.hora_final, " +
                    "       r.id_reporte, " +
                    "       DBMS_LOB.SUBSTR(r.descripcion_falla, " + MAX_DESCRIPCION + ", 1) AS descripcion, " +
                    "       NVL(r.estado, 'Sin reporte') AS estado " +
                    "FROM bitacora b " +
                    "INNER JOIN alumno a      ON UPPER(TRIM(a.matricula)) = UPPER(TRIM(b.alumno_matricula)) " +
                    // TO_CHAR en ambos lados: id_grupo y grupo_id_grupo no comparten tipo,
                    // y sin esto Oracle intenta convertir 'DSM3D' a número.
                    "INNER JOIN grupo g       ON TO_CHAR(g.id_grupo) = TO_CHAR(a.grupo_id_grupo) " +
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

        boolean todos = (aula == null || aula.trim().isEmpty()
                || "Todos".equalsIgnoreCase(aula.trim()));

        String sql = todos
                ? SELECT_BASE + "ORDER BY b.fecha DESC, b.id_bitacora DESC"
                : SELECT_BASE + "WHERE UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "ORDER BY b.fecha DESC, b.id_bitacora DESC";

        return ejecutar(sql, todos ? null : aula.trim());
    }

    /** Toda la bitácora, de todos los laboratorios. */
    public List<Map<String, Object>> listarBitacora() {
        return obtenerBitacoraPorAula(null);
    }

    /** Alias, por si alguna pantalla llama a este nombre. */
    public List<Map<String, Object>> listarBitacoraPorLaboratorio(String aula) {
        return obtenerBitacoraPorAula(aula);
    }

    /** Solo las sesiones que siguen abiertas (hora_final todavía nula). */
    public List<Map<String, Object>> listarSesionesAbiertas(String aula) {

        boolean todos = (aula == null || aula.trim().isEmpty()
                || "Todos".equalsIgnoreCase(aula.trim()));

        String sql = todos
                ? SELECT_BASE + "WHERE b.hora_final IS NULL ORDER BY b.id_bitacora DESC"
                : SELECT_BASE + "WHERE b.hora_final IS NULL "
                + "AND UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "ORDER BY b.id_bitacora DESC";

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
    // Modificaciones
    // ------------------------------------------------------------------

    /**
     * Abre la sesión de uso de un equipo.
     *
     * hora_final queda en NULL a propósito: se llena al cerrar sesión, con la
     * hora real de salida. Antes el alumno la elegía al entrar, y por eso la
     * base tiene registros que terminan antes de empezar (22:15 -> 13:15).
     */
    public boolean registrarEntrada(String matricula, String numeroPc, String aula) {

        if (matricula == null || matricula.trim().isEmpty()
                || aula == null || aula.trim().isEmpty()) {
            System.err.println(">>> [BitacoraDao] Falta matrícula o aula.");
            return false;
        }

        /*
         * TO_CHAR(SYSTIMESTAMP, 'HH24:MI') y no SYSTIMESTAMP a secas: la columna
         * es VARCHAR2 y guardaría la marca de tiempo completa, con zona horaria
         * incluida, en vez de '22:18'.
         *
         * El aula llega como "CC10", no como id: se resuelve con la subconsulta.
         */
        String sql = "INSERT INTO bitacora "
                + "(fecha, hora_inicio, hora_final, numero_pc, alumno_matricula, id_laboratorio) "
                + "VALUES (SYSDATE, TO_CHAR(SYSTIMESTAMP, 'HH24:MI'), NULL, ?, ?, "
                + "        (SELECT id_laboratorio FROM laboratorio "
                + "         WHERE UPPER(TRIM(aula)) = UPPER(TRIM(?))))";

        Connection con = null;
        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            int filas;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, numeroPc == null ? null : numeroPc.trim());
                ps.setString(2, matricula.trim());
                ps.setString(3, aula.trim());
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
            // Si el aula no existe, la subconsulta da NULL y choca con el NOT NULL.
            System.err.println(">>> [BitacoraDao] Error al registrar la entrada: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            cerrar(con);
        }
    }

    /**
     * Graba la hora de salida en las sesiones que el alumno dejó abiertas.
     * Devuelve false si no había ninguna, lo cual es normal, no un error.
     */
    public boolean cerrarSesionBitacora(String matricula) {
        if (matricula == null || matricula.trim().isEmpty()) return false;

        // Solo toca filas con hora_final NULL: no reescribe sesiones ya cerradas.
        String sql = "UPDATE bitacora SET hora_final = TO_CHAR(SYSTIMESTAMP, 'HH24:MI') "
                + "WHERE UPPER(TRIM(alumno_matricula)) = UPPER(TRIM(?)) "
                + "  AND hora_final IS NULL";

        Connection con = null;
        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            int filas;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, matricula.trim());
                filas = ps.executeUpdate();
            }

            con.commit();
            return filas > 0;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [BitacoraDao] Error al cerrar la bitácora: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            cerrar(con);
        }
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
                    fila.put("grupo", rs.getString("grupo"));
                    fila.put("fecha", rs.getString("fecha"));
                    fila.put("horaInicio", rs.getString("hora_inicio"));
                    fila.put("horaFinal", rs.getString("hora_final"));
                    fila.put("incidencia", rs.getString("descripcion"));
                    fila.put("estado", rs.getString("estado"));

                    // getInt devuelve 0 cuando la columna es NULL, así que se
                    // comprueba aparte: no existe el reporte número cero.
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

    private void cerrar(Connection con) {
        if (con == null) return;
        try { con.setAutoCommit(true); } catch (SQLException ignored) { }
        try { con.close(); } catch (SQLException ignored) { }
    }
}