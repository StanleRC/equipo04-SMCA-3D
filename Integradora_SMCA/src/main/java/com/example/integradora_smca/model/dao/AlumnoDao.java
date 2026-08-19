package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.HistorialAlumnoDto;
import com.example.integradora_smca.model.SecurityUtils;
import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AlumnoDao {

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

    /**
     * Devuelve la conexión a su estado normal antes de cerrarla.
     * Es importante si SQLConnector usa un pool: una conexión devuelta con autoCommit=false
     * hace que la siguiente operación del sistema no guarde nada hasta un commit explícito.
     */
    private void restaurarYCerrar(Connection con) {
        if (con == null) return;
        try {
            con.setAutoCommit(true);
        } catch (SQLException ignored) {
            // La conexión pudo cerrarse antes; no hay nada que restaurar.
        }
        try {
            con.close();
        } catch (SQLException ignored) {
        }
    }

    public boolean existeAlumno(String matricula, String correo) {
        String sql = "SELECT COUNT(*) FROM alumno WHERE UPPER(TRIM(matricula)) = UPPER(TRIM(?)) OR LOWER(TRIM(correo)) = LOWER(TRIM(?))";
        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, matricula != null ? matricula.trim() : "");
            ps.setString(2, correo != null ? correo.trim().toLowerCase() : "");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean create(Alumno entidad) {
        if (existeAlumno(entidad.getMatricula(), entidad.getCorreo())) {
            System.err.println("--> ERROR: Matrícula o correo ya registrados.");
            return false;
        }

        String sqlContrasena = "INSERT INTO contrasena (hash_password) VALUES (?)";
        String sqlAlumno = "INSERT INTO alumno (matricula, nombre, apellido_paterno, apellido_materno, correo, id_contrasena, grupo_id_grupo, rol_id_rol, foto_perfil) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        try {
            con = obtenerConexionValida();
            con.setAutoCommit(false);

            String passwordHash = SecurityUtils.hashPassword(entidad.getHashPassword());

            long idContrasenaGenerado;
            try (PreparedStatement psPass = con.prepareStatement(sqlContrasena, new String[]{"ID_CONTRASENA"})) {
                psPass.setString(1, passwordHash);
                psPass.executeUpdate();

                try (ResultSet rsKeys = psPass.getGeneratedKeys()) {
                    if (rsKeys != null && rsKeys.next()) {
                        idContrasenaGenerado = rsKeys.getLong(1);
                    } else {
                        throw new SQLException("No se obtuvo el ID_CONTRASENA.");
                    }
                }
            }

            try (PreparedStatement psAlumno = con.prepareStatement(sqlAlumno)) {
                psAlumno.setString(1, entidad.getMatricula().trim().toUpperCase());
                psAlumno.setString(2, entidad.getNombre().trim());
                psAlumno.setString(3, entidad.getApellidoPaterno().trim());
                psAlumno.setString(4, entidad.getApellidoMaterno().trim());
                psAlumno.setString(5, entidad.getCorreo().trim().toLowerCase());
                psAlumno.setLong(6, idContrasenaGenerado);
                psAlumno.setString(7, entidad.getGrupoIdGrupo().trim());
                psAlumno.setInt(8, entidad.getRolIdRol());
                psAlumno.setString(9, entidad.getFotoPerfil());
                psAlumno.executeUpdate();
            }

            con.commit();
            System.out.println("--> REGISTRO EXITOSO: Matrícula [" + entidad.getMatricula().toUpperCase() + "]");
            return true;

        } catch (SQLException e) {
            System.err.println("--> ERROR EN CREATE ALUMNO: " + e.getMessage());
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            restaurarYCerrar(con);
        }
    }

    public Alumno login(String matricula, String contrasena) {
        if (matricula == null || contrasena == null) return null;

        String sql = "SELECT a.matricula, a.nombre, a.apellido_paterno, a.apellido_materno, a.correo, a.grupo_id_grupo, " +
                "a.rol_id_rol, a.foto_perfil, c.hash_password " +
                "FROM alumno a " +
                "INNER JOIN contrasena c ON a.id_contrasena = c.id_contrasena " +
                "WHERE UPPER(TRIM(a.matricula)) = UPPER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String passBD = rs.getString("hash_password");
                    String inputHash = SecurityUtils.hashPassword(contrasena.trim());

                    if (passBD != null && inputHash != null && passBD.trim().equalsIgnoreCase(inputHash)) {
                        System.out.println("--> LOGIN EXITOSO: Matrícula [" + matricula.trim() + "]");
                        return mapResultSetToAlumno(rs);
                    }
                    System.out.println("--> LOGIN FALLIDO: credenciales incorrectas.");
                } else {
                    System.out.println("--> LOGIN FALLIDO: credenciales incorrectas.");
                }
            }
        } catch (SQLException e) {
            System.err.println("--> ERROR EN LOGIN: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Alumno> getAll() {
        List<Alumno> lista = new ArrayList<>();
        String sql = "SELECT a.matricula, a.nombre, a.apellido_paterno, a.apellido_materno, a.correo, a.grupo_id_grupo, " +
                "a.rol_id_rol, a.foto_perfil, c.hash_password " +
                "FROM alumno a " +
                "INNER JOIN contrasena c ON a.id_contrasena = c.id_contrasena";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapResultSetToAlumno(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Alumno getById(String matricula) {
        String sql = "SELECT a.matricula, a.nombre, a.apellido_paterno, a.apellido_materno, a.correo, a.grupo_id_grupo, " +
                "a.rol_id_rol, a.foto_perfil, c.hash_password " +
                "FROM alumno a " +
                "INNER JOIN contrasena c ON a.id_contrasena = c.id_contrasena " +
                "WHERE UPPER(TRIM(a.matricula)) = UPPER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAlumno(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(Alumno entidad) {
        String sql = "UPDATE alumno SET nombre = ?, apellido_paterno = ?, apellido_materno = ?, correo = ?, foto_perfil = ? " +
                "WHERE UPPER(TRIM(matricula)) = UPPER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, entidad.getNombre().trim());
            ps.setString(2, entidad.getApellidoPaterno().trim());
            ps.setString(3, entidad.getApellidoMaterno().trim());
            ps.setString(4, entidad.getCorreo().trim().toLowerCase());
            ps.setString(5, entidad.getFotoPerfil());
            ps.setString(6, entidad.getMatricula().trim());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String matricula) {
        String sql = "DELETE FROM alumno WHERE UPPER(TRIM(matricula)) = UPPER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Alumno getPerfilCompletoByMatricula(String matricula) {
        String sql = "SELECT a.matricula, a.nombre, a.apellido_paterno, a.apellido_materno, " +
                "a.correo, a.foto_perfil, " +
                "g.id_grupo, g.grado, g.letra_grupo, c.nombre_carrera " +
                "FROM alumno a " +
                // TO_CHAR en ambos lados: sin esto Oracle intenta convertir
                // 'DSM3D' a número y lanza ORA-01722.
                "INNER JOIN grupo g   ON TO_CHAR(g.id_grupo) = TO_CHAR(a.grupo_id_grupo) " +
                "INNER JOIN carrera c ON c.id_carrera = g.carrera_id_carrera " +
                "WHERE UPPER(TRIM(a.matricula)) = UPPER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Alumno a = new Alumno();
                    a.setMatricula(rs.getString("matricula"));
                    a.setNombre(rs.getString("nombre"));
                    a.setApellidoPaterno(rs.getString("apellido_paterno"));
                    a.setApellidoMaterno(rs.getString("apellido_materno"));
                    a.setCorreo(rs.getString("correo"));
                    a.setFotoPerfil(rs.getString("foto_perfil"));
                    a.setGrupoIdGrupo(rs.getString("id_grupo"));
                    return a;
                }
            }
        } catch (SQLException e) {
            // Sin este mensaje el fallo era invisible: el servlet solo veía null
            // y concluía que el alumno no existía.
            System.err.println("--> ERROR EN PERFIL COMPLETO: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<HistorialAlumnoDto> getHistorialByMatricula(String matricula) {
        List<HistorialAlumnoDto> lista = new ArrayList<>();

        String sql = "SELECT g.grado, g.letra_grupo AS grupo, a.matricula, " +
                "(a.nombre || ' ' || a.apellido_paterno || ' ' || a.apellido_materno) AS nombre_completo, " +
                "l.aula, b.numero_pc, " +
                "TO_CHAR(b.fecha, 'DD/MM/YYYY') AS fecha, " +
                // hora_inicio y hora_final son VARCHAR2 y ya guardan 'HH:MM'.
                // Aplicarles TO_CHAR hace que Oracle los trate como número (ORA-01722).
                "b.hora_inicio, b.hora_final, " +
                "NVL(DBMS_LOB.SUBSTR(r.descripcion_falla, 500, 1), 'Ninguna') AS incidencia, " +
                "NVL(r.estado, 'Sin reporte') AS estado " +
                "FROM bitacora b " +
                "INNER JOIN alumno a      ON UPPER(TRIM(a.matricula)) = UPPER(TRIM(b.alumno_matricula)) " +
                // TO_CHAR en ambos lados: id_grupo y grupo_id_grupo no comparten tipo.
                "INNER JOIN grupo g       ON TO_CHAR(g.id_grupo) = TO_CHAR(a.grupo_id_grupo) " +
                "INNER JOIN laboratorio l ON l.id_laboratorio = b.id_laboratorio " +
                "LEFT  JOIN reporte_falla r ON r.id_bitacora = b.id_bitacora " +
                "WHERE UPPER(TRIM(a.matricula)) = UPPER(TRIM(?)) " +
                "ORDER BY b.fecha DESC, b.id_bitacora DESC";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistorialAlumnoDto h = new HistorialAlumnoDto();
                    h.setGrado(rs.getString("grado"));
                    h.setGrupo(rs.getString("grupo"));
                    h.setSalon(rs.getString("aula"));
                    h.setNumeroPc(rs.getString("numero_pc"));
                    h.setMatricula(rs.getString("matricula"));
                    h.setNombreCompleto(rs.getString("nombre_completo"));
                    h.setFecha(rs.getString("fecha"));
                    h.setHoraInicial(rs.getString("hora_inicio"));
                    h.setHoraFinal(rs.getString("hora_final"));
                    h.setIncidencia(rs.getString("incidencia"));
                    h.setEstado(rs.getString("estado"));
                    lista.add(h);
                }
            }
        } catch (SQLException e) {
            System.err.println("--> ERROR EN HISTORIAL: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    private Alumno mapResultSetToAlumno(ResultSet rs) throws SQLException {
        Alumno a = new Alumno();
        a.setMatricula(rs.getString("matricula"));
        a.setNombre(rs.getString("nombre"));
        a.setApellidoPaterno(rs.getString("apellido_paterno"));
        a.setApellidoMaterno(rs.getString("apellido_materno"));
        a.setCorreo(rs.getString("correo"));
        a.setGrupoIdGrupo(rs.getString("grupo_id_grupo"));
        a.setRolIdRol(rs.getInt("rol_id_rol"));
        a.setFotoPerfil(rs.getString("foto_perfil"));

        try {
            a.setHashPassword(rs.getString("hash_password"));
        } catch (SQLException ignored) {
        }

        return a;
    }

    public boolean existeCorreo(String correo) {
        if (correo == null || correo.trim().isEmpty()) return false;

        String sql = "SELECT COUNT(*) FROM alumno WHERE LOWER(TRIM(correo)) = LOWER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("--> ERROR EN EXISTE CORREO: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Reemplaza la contraseña del alumno identificado por su correo.
     * Si el alumno existe pero no tiene fila en 'contrasena' (id_contrasena nulo o huérfano),
     * se crea la fila y se enlaza, en lugar de fallar en silencio como antes.
     */
    public boolean actualizarPasswordPorCorreo(String correo, String nuevaPassword) {
        if (correo == null || nuevaPassword == null) return false;

        String passwordHash = SecurityUtils.hashPassword(nuevaPassword.trim());
        String correoLimpio = correo.trim().toLowerCase();

        String sqlUpdate = "UPDATE contrasena SET hash_password = ? " +
                "WHERE id_contrasena = (SELECT id_contrasena FROM alumno WHERE LOWER(TRIM(correo)) = ?)";

        Connection con = null;
        try {
            con = obtenerConexionValida();
            con.setAutoCommit(false);

            int filasAfectadas;
            try (PreparedStatement ps = con.prepareStatement(sqlUpdate)) {
                ps.setString(1, passwordHash);
                ps.setString(2, correoLimpio);
                filasAfectadas = ps.executeUpdate();
            }

            if (filasAfectadas == 0) {
                filasAfectadas = crearYEnlazarContrasena(con, correoLimpio, passwordHash);
            }

            if (filasAfectadas > 0) {
                con.commit();
                System.out.println(">>> [AlumnoDao] Contraseña actualizada para: [" + correoLimpio + "]");
                return true;
            }

            con.rollback();
            System.err.println(">>> [AlumnoDao] No existe alumno con el correo: [" + correoLimpio + "]");
            return false;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [AlumnoDao] Error al actualizar la contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            restaurarYCerrar(con);
        }
    }

    /** Crea una fila en 'contrasena' y la enlaza al alumno. Devuelve filas afectadas. */
    private int crearYEnlazarContrasena(Connection con, String correoLimpio, String passwordHash)
            throws SQLException {

        // Sin alumno no hay nada que enlazar.
        try (PreparedStatement psCheck = con.prepareStatement(
                "SELECT COUNT(*) FROM alumno WHERE LOWER(TRIM(correo)) = ?")) {
            psCheck.setString(1, correoLimpio);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (!rs.next() || rs.getInt(1) == 0) {
                    return 0;
                }
            }
        }

        long idContrasena = -1;
        try (PreparedStatement psInsert = con.prepareStatement(
                "INSERT INTO contrasena (hash_password) VALUES (?)", new String[]{"ID_CONTRASENA"})) {
            psInsert.setString(1, passwordHash);
            psInsert.executeUpdate();
            try (ResultSet rs = psInsert.getGeneratedKeys()) {
                if (rs.next()) {
                    idContrasena = rs.getLong(1);
                }
            }
        }

        if (idContrasena <= 0) return 0;

        try (PreparedStatement psLink = con.prepareStatement(
                "UPDATE alumno SET id_contrasena = ? WHERE LOWER(TRIM(correo)) = ?")) {
            psLink.setLong(1, idContrasena);
            psLink.setString(2, correoLimpio);
            return psLink.executeUpdate();
        }
    }


    public List<Map<String, Object>> buscarAlumnos(String termino) {
        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT a.matricula, a.correo, a.foto_perfil, NVL(a.activo, 'S') AS activo, " +
                "(a.nombre || ' ' || a.apellido_paterno || ' ' || a.apellido_materno) AS nombre_completo, " +
                "g.id_grupo, g.grado, g.letra_grupo AS grupo, c.nombre_carrera " +
                "FROM alumno a " +
                // TO_CHAR en ambos lados: id_grupo y grupo_id_grupo no comparten tipo.
                "INNER JOIN grupo g   ON TO_CHAR(g.id_grupo) = TO_CHAR(a.grupo_id_grupo) " +
                "INNER JOIN carrera c ON c.id_carrera = g.carrera_id_carrera " +
                "WHERE UPPER(a.nombre || ' ' || a.apellido_paterno || ' ' || a.apellido_materno) LIKE UPPER(?) " +
                "   OR UPPER(a.matricula) LIKE UPPER(?) " +
                "   OR UPPER(a.correo)    LIKE UPPER(?) " +
                "   OR UPPER(TO_CHAR(g.id_grupo)) LIKE UPPER(?) " +
                "ORDER BY a.apellido_paterno, a.apellido_materno, a.nombre";

        String patron = "%" + (termino == null ? "" : termino.trim()) + "%";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (int i = 1; i <= 4; i++) ps.setString(i, patron);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new HashMap<>();
                    fila.put("matricula", rs.getString("matricula"));
                    fila.put("nombreCompleto", rs.getString("nombre_completo"));
                    fila.put("grado", rs.getString("grado"));
                    fila.put("grupo", rs.getString("grupo"));
                    fila.put("idGrupo", rs.getString("id_grupo"));
                    fila.put("carrera", rs.getString("nombre_carrera"));
                    fila.put("correo", rs.getString("correo"));
                    fila.put("activo", rs.getString("activo"));
                    lista.add(fila);
                }
            }
        } catch (SQLException e) {
            System.err.println("--> ERROR EN BUSCAR ALUMNOS: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    /** Deshabilita o reactiva sin borrar nada. */
    public boolean cambiarEstadoAlumno(String matricula, boolean activo) {
        if (matricula == null || matricula.trim().isEmpty()) return false;

        String sql = "UPDATE alumno SET activo = ? WHERE UPPER(TRIM(matricula)) = UPPER(TRIM(?))";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, activo ? "S" : "N");
            ps.setString(2, matricula.trim());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("--> ERROR AL CAMBIAR ESTADO: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /** true si el alumno está activo. También devuelve true si no existe la columna. */
    public boolean estaActivo(String matricula) {
        if (matricula == null || matricula.trim().isEmpty()) return true;

        String sql = "SELECT NVL(activo, 'S') FROM alumno " +
                "WHERE UPPER(TRIM(matricula)) = UPPER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return !"N".equalsIgnoreCase(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return true;
    }




}