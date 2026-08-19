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
 * Consultas sobre REPORTE_FALLA (en las pantallas se le llama "incidencias").
 *
 * NOMBRES REALES DE COLUMNA (distintos del script de creación):
 *   grupo.letra_grupo    — no numero_grupo
 *   reporte_falla.estado — no estado_reporte
 *
 * Los datos del alumno y del laboratorio se obtienen SIEMPRE a través de
 * bitacora (r.id_bitacora), nunca de columnas propias de reporte_falla: la
 * tabla real no guarda ahí ni la matrícula ni el id del laboratorio.
 *
 * ESTADOS: 'Pendiente', 'Validado', 'Descartado'. Son los tres valores que
 * comparan los JSP; si aquí se escribieran otros (VALIDA, DESCARTADA) las
 * pastillas de color nunca coincidirían.
 */
public class IncidenciaDao {

    /** descripcion_falla es CLOB: TO_CHAR revienta si pasa de 4000 caracteres. */
    private static final int MAX_DESCRIPCION = 500;

    public static final String ESTADO_PENDIENTE = "Pendiente";
    public static final String ESTADO_VALIDADO = "Validado";
    public static final String ESTADO_DESCARTADO = "Descartado";

    private static final String SELECT_BASE =
            "SELECT r.id_reporte, " +
                    "       g.grado, " +
                    "       g.letra_grupo AS grupo, " +
                    "       b.numero_pc, " +
                    "       a.matricula, " +
                    "       (a.nombre || ' ' || a.apellido_paterno || ' ' || a.apellido_materno) AS nombre_completo, " +
                    "       TO_CHAR(r.fecha_reporte, 'DD/MM/YYYY') AS fecha, " +
                    "       TO_CHAR(r.fecha_reporte, 'HH24:MI')    AS hora, " +
                    "       DBMS_LOB.SUBSTR(r.descripcion_falla, " + MAX_DESCRIPCION + ", 1) AS descripcion, " +
                    "       r.prioridad, " +
                    "       r.estado, " +
                    "       r.foto_evidencia, " +
                    "       r.id_bitacora, " +
                    "       l.aula, " +
                    "       l.edificio, " +
                    "       l.nombre_lab " +
                    "FROM reporte_falla r " +
                    "INNER JOIN bitacora b    ON b.id_bitacora = r.id_bitacora " +
                    "INNER JOIN alumno a      ON UPPER(TRIM(a.matricula)) = UPPER(TRIM(b.alumno_matricula)) " +
                    "INNER JOIN grupo g       ON g.id_grupo = a.grupo_id_grupo " +
                    "INNER JOIN laboratorio l ON l.id_laboratorio = b.id_laboratorio ";

    // ------------------------------------------------------------------
    // Alta: lo que registra el alumno
    // ------------------------------------------------------------------

    /**
     * Registra el uso del equipo en BITACORA y, si el alumno escribió algo,
     * el reporte en REPORTE_FALLA ligado a esa fila. Todo en una transacción:
     * o se guardan las dos cosas, o no se guarda ninguna.
     *
     * @param aula    nombre del aula ("CC10"), no el id.
     * @param horaFin se ignora: la hora de salida se graba al cerrar sesión.
     */
    public boolean guardarIncidenciaAlumno(String descripcionFalla, String prioridad,
                                           String numeroPc, String aula,
                                           String matriculaAlumno, String horaFin) {

        if (seguro(matriculaAlumno) == null || seguro(aula) == null) {
            System.err.println(">>> [IncidenciaDao] Falta matrícula o aula.");
            return false;
        }

        /*
         * hora_inicio es TIMESTAMP y antes se le insertaba el texto '22:15'
         * con TO_CHAR. Oracle lo convertía implícitamente y por eso quedaban
         * horas incoherentes. Ahora se usa SYSTIMESTAMP, y hora_final se deja
         * en NULL hasta que el alumno cierra sesión.
         */
        String sqlBitacora = "INSERT INTO bitacora "
                + "(fecha, hora_inicio, hora_final, numero_pc, alumno_matricula, id_laboratorio) "
                + "VALUES (SYSDATE, SYSTIMESTAMP, NULL, ?, ?, ?)";

        String sqlReporte = "INSERT INTO reporte_falla "
                + "(id_bitacora, descripcion_falla, fecha_reporte, prioridad, estado) "
                + "VALUES (?, ?, CURRENT_TIMESTAMP, ?, '" + ESTADO_PENDIENTE + "')";

        Connection con = null;
        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            Integer idLab = resolverLaboratorio(con, aula.trim());
            if (idLab == null) {
                con.rollback();
                System.err.println(">>> [IncidenciaDao] El aula '" + aula + "' no existe.");
                return false;
            }

            long idBitacora = -1;

            try (PreparedStatement ps = con.prepareStatement(sqlBitacora, new String[]{"ID_BITACORA"})) {
                ps.setString(1, seguro(numeroPc));
                ps.setString(2, matriculaAlumno.trim());
                ps.setInt(3, idLab);
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) idBitacora = rs.getLong(1);
                }
            }

            if (idBitacora <= 0) {
                con.rollback();
                System.err.println(">>> [IncidenciaDao] No se obtuvo el ID_BITACORA.");
                return false;
            }

            // El reporte es opcional: se puede usar el equipo sin que falle nada.
            String falla = seguro(descripcionFalla);
            if (falla != null) {
                try (PreparedStatement ps = con.prepareStatement(sqlReporte)) {
                    ps.setLong(1, idBitacora);
                    ps.setString(2, falla);
                    ps.setString(3, seguro(prioridad) != null ? seguro(prioridad) : "Media");
                    ps.executeUpdate();
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [IncidenciaDao] Error al registrar la incidencia: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            cerrar(con);
        }
    }

    // ------------------------------------------------------------------
    // Revisión: lo que hace el docente
    // ------------------------------------------------------------------

    /**
     * Marca un reporte como revisado.
     *
     * @param accionAdmin "validar" o "descartar".
     */
    public boolean procesarRevisionAdmin(int idReporte, String accionAdmin) {

        String nuevoEstado = traducirAccion(accionAdmin);
        if (nuevoEstado == null || idReporte <= 0) {
            System.err.println(">>> [IncidenciaDao] Acción no reconocida: " + accionAdmin);
            return false;
        }

        /*
         * Solo se toca lo que sigue pendiente. Así, si dos personas abren la
         * misma pantalla al mismo tiempo, la segunda no sobrescribe la decisión
         * de la primera y recibe false.
         */
        String sql = "UPDATE reporte_falla SET estado = ? "
                + "WHERE id_reporte = ? AND estado = ?";

        Connection con = null;
        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            int filas;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, nuevoEstado);
                ps.setInt(2, idReporte);
                ps.setString(3, ESTADO_PENDIENTE);
                filas = ps.executeUpdate();
            }

            if (filas > 0) {
                con.commit();
                return true;
            }

            con.rollback();
            System.err.println(">>> [IncidenciaDao] El reporte " + idReporte
                    + " no existe o ya fue revisado.");
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

    /** Guarda el nombre del archivo de evidencia en la fila del reporte. */
    public boolean guardarFotoEvidencia(int idReporte, String nombreArchivo) {
        if (seguro(nombreArchivo) == null) return false;

        String sql = "UPDATE reporte_falla SET foto_evidencia = ? WHERE id_reporte = ?";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreArchivo.trim());
            ps.setInt(2, idReporte);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println(">>> [IncidenciaDao] Error al guardar la evidencia: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------
    // Lecturas
    // ------------------------------------------------------------------

    /** Todos los reportes, de todos los laboratorios. */
    public List<Map<String, Object>> listarIncidencias() {
        return ejecutar(SELECT_BASE + "ORDER BY r.fecha_reporte DESC", null);
    }

    /**
     * Reportes de un laboratorio.
     *
     * @param aulaOId acepta el nombre del aula ("CC10") o el id numérico.
     *                Si viene vacío o "Todos", devuelve todo.
     */
    public List<Map<String, Object>> listarIncidenciasPorLaboratorio(String aulaOId) {

        String valor = seguro(aulaOId);

        if (valor == null || "Todos".equalsIgnoreCase(valor)) {
            return listarIncidencias();
        }

        // Si es número, filtra por id; si no, por nombre de aula.
        boolean esNumero = valor.matches("\\d+");

        String sql = esNumero
                ? SELECT_BASE + "WHERE l.id_laboratorio = ? ORDER BY r.fecha_reporte DESC"
                : SELECT_BASE + "WHERE UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "ORDER BY r.fecha_reporte DESC";

        List<Map<String, Object>> lista = new ArrayList<>();

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (esNumero) {
                ps.setInt(1, Integer.parseInt(valor));
            } else {
                ps.setString(1, valor);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println(">>> [IncidenciaDao] Error al filtrar por laboratorio: " + e.getMessage());
            e.printStackTrace();
        }

        return lista;
    }

    /** Solo los que siguen esperando revisión. */
    public List<Map<String, Object>> listarPendientesPorLaboratorio(String aula) {
        String sql = SELECT_BASE
                + "WHERE UPPER(TRIM(l.aula)) = UPPER(TRIM(?)) "
                + "  AND r.estado = '" + ESTADO_PENDIENTE + "' "
                + "ORDER BY r.fecha_reporte DESC";

        return ejecutar(sql, seguro(aula) == null ? "" : aula.trim());
    }

    /** Un solo reporte con todos sus datos. Se usa para armar el correo. */
    public Map<String, Object> obtenerReportePorId(int idReporte) {

        String sql = SELECT_BASE + "WHERE r.id_reporte = ?";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReporte);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println(">>> [IncidenciaDao] Error al leer el reporte " + idReporte
                    + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /** Laboratorios existentes, para llenar las pantallas sin quemarlos en el HTML. */
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
            System.err.println(">>> [IncidenciaDao] Error al listar laboratorios: " + e.getMessage());
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
                    lista.add(mapear(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println(">>> [IncidenciaDao] Error al listar: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Cada dato se guarda con dos llaves cuando hace falta (por ejemplo
     * "numeroPc" y "numero_pc"), para que sirva tanto a los JSP nuevos como
     * a cualquier vista que todavía use el nombre viejo.
     */
    private Map<String, Object> mapear(ResultSet rs) throws SQLException {
        Map<String, Object> fila = new HashMap<>();

        fila.put("idReporte", rs.getInt("id_reporte"));
        fila.put("id_reporte", rs.getInt("id_reporte"));

        fila.put("grado", rs.getString("grado"));
        fila.put("grupo", rs.getString("grupo"));

        fila.put("numeroPc", rs.getString("numero_pc"));
        fila.put("numero_pc", rs.getString("numero_pc"));
        fila.put("pc", rs.getString("numero_pc"));

        fila.put("matricula", rs.getString("matricula"));

        String nombreCompleto = rs.getString("nombre_completo");
        fila.put("nombreCompleto", nombreCompleto);
        fila.put("nombre", nombreCompleto);
        fila.put("nombre_alumno", nombreCompleto);

        fila.put("fecha", rs.getString("fecha"));
        fila.put("fecha_reporte", rs.getString("fecha"));
        fila.put("hora", rs.getString("hora"));

        String descripcion = rs.getString("descripcion");
        fila.put("incidencia", descripcion);
        fila.put("descripcion_falla", descripcion);

        fila.put("prioridad", rs.getString("prioridad"));
        fila.put("estado", rs.getString("estado"));
        fila.put("fotoEvidencia", rs.getString("foto_evidencia"));

        fila.put("salon", rs.getString("aula"));
        fila.put("aula", rs.getString("aula"));
        fila.put("edificio", rs.getString("edificio"));
        fila.put("nombre_lab", rs.getString("nombre_lab"));

        int idBitacora = rs.getInt("id_bitacora");
        fila.put("idBitacora", rs.wasNull() ? null : idBitacora);

        return fila;
    }

    /** Convierte el aula en id. Devuelve null si no existe. */
    private Integer resolverLaboratorio(Connection con, String aula) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT id_laboratorio FROM laboratorio WHERE UPPER(TRIM(aula)) = UPPER(TRIM(?))")) {
            ps.setString(1, aula);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : null;
            }
        }
    }

    private String traducirAccion(String accion) {
        if (accion == null) return null;
        String a = accion.trim().toLowerCase();

        if (a.equals("validar") || a.equals("validado")) return ESTADO_VALIDADO;
        if (a.equals("descartar") || a.equals("descartado")) return ESTADO_DESCARTADO;
        return null;
    }

    private String seguro(String valor) {
        return (valor != null && !valor.trim().isEmpty()) ? valor.trim() : null;
    }

    private void cerrar(Connection con) {
        if (con == null) return;
        try { con.setAutoCommit(true); } catch (SQLException ignored) { }
        try { con.close(); } catch (SQLException ignored) { }
    }
}