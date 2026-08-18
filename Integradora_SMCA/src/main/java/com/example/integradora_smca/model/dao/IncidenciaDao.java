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
 * Consultas sobre REPORTE_FALLA (lo que en las pantallas se llama "incidencias").
 *
 * Notas del esquema real:
 *  - La tabla se llama reporte_falla, no incidencia. La llave es id_reporte.
 *  - El estado vive en estado_reporte, con 'Pendiente' por defecto.
 *  - descripcion_falla es CLOB. Se lee con DBMS_LOB.SUBSTR porque TO_CHAR()
 *    revienta si el texto pasa de 4000 caracteres.
 *  - El parámetro ?lab=CC10 de las pantallas corresponde a laboratorio.aula,
 *    no a un id numérico.
 */
public class IncidenciaDao {

    /** Tope de caracteres que se muestran de la descripción en las tablas. */
    private static final int MAX_DESCRIPCION = 500;

    private static final String SELECT_BASE =
            "SELECT r.id_reporte, " +
                    "       g.grado, " +
                    "       g.numero_grupo, " +
                    "       r.numero_pc, " +
                    "       a.matricula, " +
                    "       (a.nombre || ' ' || a.apellido_paterno || ' ' || a.apellido_materno) AS nombre_completo, " +
                    "       TO_CHAR(r.fecha_reporte, 'DD/MM/YYYY') AS fecha, " +
                    "       TO_CHAR(r.fecha_reporte, 'HH24:MI')    AS hora, " +
                    "       DBMS_LOB.SUBSTR(r.descripcion_falla, " + MAX_DESCRIPCION + ", 1) AS descripcion, " +
                    "       r.prioridad, " +
                    "       r.estado_reporte, " +
                    "       r.foto_evidencia, " +
                    "       l.aula, " +
                    "       l.edificio " +
                    "FROM reporte_falla r " +
                    "INNER JOIN alumno a      ON UPPER(TRIM(a.matricula)) = UPPER(TRIM(r.alumno_matricula)) " +
                    "INNER JOIN grupo g       ON g.id_grupo = a.grupo_id_grupo " +
                    "INNER JOIN laboratorio l ON l.id_laboratorio = r.id_laboratorio ";

    private Connection obtenerConexionValida() throws SQLException {
        Connection con = SQLConnector.getConnection();
        if (con == null || con.isClosed()) {
            con = SQLConnector.getConnection();
        }
        if (con == null) {
            throw new SQLException("No se pudo obtener conexión con la base de datos.");
        }
        return con;
    }

    /** Todos los reportes, de todos los laboratorios. */
    public List<Map<String, Object>> listarIncidencias() {
        return ejecutar(SELECT_BASE + "ORDER BY r.fecha_reporte DESC", null);
    }

    /**
     * Reportes de un laboratorio.
     * @param aula el valor que llega en ?lab=, por ejemplo "CC10" o "CA1".
     */
    public List<Map<String, Object>> listarIncidenciasPorLaboratorio(String aula) {
        if (aula == null || aula.trim().isEmpty()) {
            return listarIncidencias();
        }
        String sql = SELECT_BASE
                + "WHERE UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "ORDER BY r.fecha_reporte DESC";
        return ejecutar(sql, aula.trim());
    }

    /** Solo los que siguen esperando revisión. */
    public List<Map<String, Object>> listarPendientesPorLaboratorio(String aula) {
        String sql = SELECT_BASE
                + "WHERE UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "  AND r.estado_reporte = 'Pendiente' "
                + "ORDER BY r.fecha_reporte DESC";
        return ejecutar(sql, aula == null ? "" : aula.trim());
    }

    /**
     * Marca un reporte como revisado.
     *
     * @param accion "validar" o "descartar" (también acepta directamente
     *               "Validado" / "Descartado").
     */
    public boolean procesarRevisionAdmin(int idReporte, String accion) {
        String nuevoEstado = traducirAccion(accion);
        if (nuevoEstado == null || idReporte <= 0) {
            return false;
        }

        // Solo se toca lo que sigue pendiente: evita que dos administradores
        // se pisen el resultado si abren la misma pantalla al mismo tiempo.
        String sql = "UPDATE reporte_falla SET estado_reporte = ? " +
                "WHERE id_reporte = ? AND estado_reporte = 'Pendiente'";

        Connection con = null;
        try {
            con = obtenerConexionValida();
            con.setAutoCommit(false);

            int filas;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, nuevoEstado);
                ps.setInt(2, idReporte);
                filas = ps.executeUpdate();
            }

            if (filas > 0) {
                con.commit();
                return true;
            }

            con.rollback();
            System.err.println(">>> [IncidenciaDao] El reporte " + idReporte + " no existe o ya fue revisado.");
            return false;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [IncidenciaDao] Error al revisar el reporte: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            cerrar(con);
        }
    }

    /**
     * Registra el reporte que levanta el alumno.
     *
     * @param idBitacora fila de bitácora asociada, o null si el alumno reporta
     *                   sin tener una sesión de equipo abierta.
     * @return el id_reporte generado, o -1 si falló.
     */
    public int crearReporte(String matricula, String aula, String numeroPc,
                            String descripcion, String prioridad,
                            String fotoEvidencia, Integer idBitacora) {

        if (matricula == null || aula == null || descripcion == null || descripcion.trim().isEmpty()) {
            return -1;
        }

        String sql = "INSERT INTO reporte_falla " +
                "(descripcion_falla, prioridad, foto_evidencia, numero_pc, estado_reporte, " +
                " alumno_matricula, id_laboratorio, id_bitacora) " +
                "VALUES (?, ?, ?, ?, 'Pendiente', ?, " +
                "        (SELECT id_laboratorio FROM laboratorio WHERE UPPER(TRIM(aula)) = UPPER(TRIM(?))), " +
                "        ?)";

        Connection con = null;
        try {
            con = obtenerConexionValida();
            con.setAutoCommit(false);

            int idGenerado = -1;

            try (PreparedStatement ps = con.prepareStatement(sql, new String[]{"ID_REPORTE"})) {
                ps.setString(1, descripcion.trim());
                ps.setString(2, prioridad == null || prioridad.trim().isEmpty() ? "Media" : prioridad.trim());
                ps.setString(3, fotoEvidencia);
                ps.setString(4, numeroPc);
                ps.setString(5, matricula.trim());
                ps.setString(6, aula.trim());

                if (idBitacora == null) {
                    ps.setNull(7, java.sql.Types.NUMERIC);
                } else {
                    ps.setInt(7, idBitacora);
                }

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        idGenerado = rs.getInt(1);
                    }
                }
            }

            if (idGenerado > 0) {
                con.commit();
                return idGenerado;
            }

            con.rollback();
            return -1;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [IncidenciaDao] Error al crear el reporte: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            cerrar(con);
        }
    }

    /** Laboratorios existentes, para llenar los selectores sin quemarlos en el HTML. */
    public List<Map<String, Object>> listarLaboratorios() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT id_laboratorio, aula, edificio, nombre_lab " +
                "FROM laboratorio ORDER BY edificio, aula";

        try (Connection con = obtenerConexionValida();
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
            e.printStackTrace();
        }
        return lista;
    }

    // ------------------------------------------------------------------
    // Apoyo
    // ------------------------------------------------------------------

    private List<Map<String, Object>> ejecutar(String sql, String parametro) {
        List<Map<String, Object>> lista = new ArrayList<>();

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (parametro != null) {
                ps.setString(1, parametro);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println(">>> [IncidenciaDao] Error al listar: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    private Map<String, Object> mapear(ResultSet rs) throws SQLException {
        Map<String, Object> fila = new HashMap<>();
        fila.put("idReporte", rs.getInt("id_reporte"));
        fila.put("grado", rs.getString("grado"));
        fila.put("grupo", rs.getString("numero_grupo"));
        fila.put("numeroPc", rs.getString("numero_pc"));
        fila.put("matricula", rs.getString("matricula"));
        fila.put("nombreCompleto", rs.getString("nombre_completo"));
        fila.put("fecha", rs.getString("fecha"));
        fila.put("hora", rs.getString("hora"));
        fila.put("incidencia", rs.getString("descripcion"));
        fila.put("prioridad", rs.getString("prioridad"));
        fila.put("estado", rs.getString("estado_reporte"));
        fila.put("fotoEvidencia", rs.getString("foto_evidencia"));
        fila.put("salon", rs.getString("aula"));
        fila.put("edificio", rs.getString("edificio"));
        return fila;
    }

    private String traducirAccion(String accion) {
        if (accion == null) return null;
        String a = accion.trim().toLowerCase();

        if (a.equals("validar") || a.equals("validado")) return "Validado";
        if (a.equals("descartar") || a.equals("descartado")) return "Descartado";
        return null;
    }

    private void cerrar(Connection con) {
        if (con == null) return;
        try { con.setAutoCommit(true); } catch (SQLException ignored) { }
        try { con.close(); } catch (SQLException ignored) { }
    }


    /**
     * Registra el uso del equipo en BITACORA y, si el alumno escribió algo,
     * el reporte en REPORTE_FALLA ligado a esa fila. Todo en una sola transacción:
     * o se guardan las dos cosas, o no se guarda ninguna.
     *
     * @param idLaboratorio acepta el id numérico o el nombre del aula ("CC10").
     * @param horaFin       formato HH:MM, o null si la sesión sigue abierta.
     */
    public boolean guardarIncidenciaAlumno(String descripcionFalla, String prioridad,
                                           String numeroPc, String idLaboratorio,
                                           String matriculaAlumno, String horaFin) {

        if (matriculaAlumno == null || matriculaAlumno.trim().isEmpty()
                || idLaboratorio == null || idLaboratorio.trim().isEmpty()) {
            System.err.println(">>> [IncidenciaDao] Falta matrícula o laboratorio.");
            return false;
        }

        boolean tieneHoraFin = horaFin != null && !horaFin.trim().isEmpty();

        // hora_final es TIMESTAMP: se arma con la fecha de hoy más la hora que mandó el form.
        String sqlBitacora = tieneHoraFin
                ? "INSERT INTO bitacora (fecha, hora_inicio, hora_final, numero_pc, alumno_matricula, id_laboratorio) "
                + "VALUES (SYSDATE, SYSTIMESTAMP, "
                + "        TO_TIMESTAMP(TO_CHAR(SYSDATE,'DD/MM/YYYY') || ' ' || ?, 'DD/MM/YYYY HH24:MI'), "
                + "        ?, ?, ?)"
                : "INSERT INTO bitacora (fecha, hora_inicio, hora_final, numero_pc, alumno_matricula, id_laboratorio) "
                + "VALUES (SYSDATE, SYSTIMESTAMP, NULL, ?, ?, ?)";

        String sqlReporte = "INSERT INTO reporte_falla "
                + "(descripcion_falla, prioridad, numero_pc, estado_reporte, "
                + " alumno_matricula, id_laboratorio, id_bitacora) "
                + "VALUES (?, ?, ?, 'Pendiente', ?, ?, ?)";

        Connection con = null;
        try {
            con = obtenerConexionValida();
            con.setAutoCommit(false);

            Integer idLab = resolverLaboratorio(con, idLaboratorio);
            if (idLab == null) {
                con.rollback();
                System.err.println(">>> [IncidenciaDao] El laboratorio '" + idLaboratorio + "' no existe.");
                return false;
            }

            int idBitacora = -1;

            try (PreparedStatement ps = con.prepareStatement(sqlBitacora, new String[]{"ID_BITACORA"})) {
                int i = 1;
                if (tieneHoraFin) ps.setString(i++, horaFin.trim());
                ps.setString(i++, numeroPc);
                ps.setString(i++, matriculaAlumno.trim());
                ps.setInt(i, idLab);

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) idBitacora = rs.getInt(1);
                }
            }

            if (idBitacora <= 0) {
                con.rollback();
                return false;
            }

            // El reporte es opcional: puede usar el equipo sin que nada falle.
            if (descripcionFalla != null && !descripcionFalla.trim().isEmpty()) {
                try (PreparedStatement ps = con.prepareStatement(sqlReporte)) {
                    ps.setString(1, descripcionFalla.trim());
                    ps.setString(2, (prioridad == null || prioridad.trim().isEmpty()) ? "Media" : prioridad.trim());
                    ps.setString(3, numeroPc);
                    ps.setString(4, matriculaAlumno.trim());
                    ps.setInt(5, idLab);
                    ps.setInt(6, idBitacora);
                    ps.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [IncidenciaDao] Error al guardar la incidencia: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            cerrar(con);
        }
    }

    /** Acepta el id numérico o el nombre del aula; devuelve null si no existe. */
    private Integer resolverLaboratorio(Connection con, String valor) throws SQLException {
        String limpio = valor.trim();

        try {
            int id = Integer.parseInt(limpio);
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id_laboratorio FROM laboratorio WHERE id_laboratorio = ?")) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next() ? rs.getInt(1) : null;
                }
            }
        } catch (NumberFormatException noEsNumero) {
            // El form mandó el aula ("CC10") en lugar del id.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id_laboratorio FROM laboratorio WHERE UPPER(TRIM(aula)) = UPPER(TRIM(?))")) {
                ps.setString(1, limpio);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next() ? rs.getInt(1) : null;
                }
            }
        }
    }






}