package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.model.SecurityUtils;
import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DocenteDao {

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

    /** Devuelve la conexión a autoCommit=true antes de cerrarla (importante si hay pool). */
    private void restaurarYCerrar(Connection con) {
        if (con == null) return;
        try { con.setAutoCommit(true); } catch (SQLException ignored) { }
        try { con.close(); } catch (SQLException ignored) { }
    }

    public boolean existeDocente(String correo) {
        if (correo == null) return false;
        String sql = "SELECT COUNT(*) FROM docente WHERE LOWER(TRIM(correo)) = LOWER(TRIM(?))";
        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo.trim().toLowerCase());
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

    /** Método expuesto para el servlet de recuperación de contraseña. */
    public boolean existeCorreo(String correo) {
        return existeDocente(correo);
    }

    public boolean create(Docente entidad) {
        if (existeDocente(entidad.getCorreo())) {
            System.err.println("--> ERROR: El correo ya está registrado para otro docente.");
            return false;
        }

        String sqlPass = "INSERT INTO contrasena (hash_password) VALUES (?)";
        String sqlDocente = "INSERT INTO docente (id_docente, nombre, apellido_paterno, apellido_materno, correo, id_contrasena, rol_id_rol, foto_perfil) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        try {
            con = obtenerConexionValida();
            con.setAutoCommit(false);

            String passOriginal = entidad.getHashPassword() != null ? entidad.getHashPassword().trim() : "";
            if (passOriginal.isEmpty()) {
                con.rollback();
                return false;
            }

            // Evitar re-hashear si el valor ya viene en SHA-256.
            String passToSave = esHashSha256(passOriginal)
                    ? passOriginal.toLowerCase()
                    : SecurityUtils.hashPassword(passOriginal);

            int idContrasenaGenerado = -1;

            try (PreparedStatement psPass = con.prepareStatement(sqlPass, new String[]{"ID_CONTRASENA"})) {
                psPass.setString(1, passToSave);
                psPass.executeUpdate();
                try (ResultSet rs = psPass.getGeneratedKeys()) {
                    if (rs.next()) {
                        idContrasenaGenerado = rs.getInt(1);
                    }
                }
            }

            if (idContrasenaGenerado <= 0) {
                try (PreparedStatement psSeq = con.prepareStatement("SELECT MAX(id_contrasena) FROM contrasena");
                     ResultSet rsSeq = psSeq.executeQuery()) {
                    if (rsSeq.next()) {
                        idContrasenaGenerado = rsSeq.getInt(1);
                    }
                }
            }

            if (idContrasenaGenerado <= 0) {
                con.rollback();
                return false;
            }

            int idDocenteFinal = 1;
            try (PreparedStatement psMax = con.prepareStatement("SELECT NVL(MAX(id_docente), 0) + 1 FROM docente");
                 ResultSet rsMax = psMax.executeQuery()) {
                if (rsMax.next()) {
                    idDocenteFinal = rsMax.getInt(1);
                }
            }

            try (PreparedStatement psDocente = con.prepareStatement(sqlDocente)) {
                psDocente.setInt(1, idDocenteFinal);
                psDocente.setString(2, entidad.getNombre());
                psDocente.setString(3, entidad.getApellidoPaterno());
                psDocente.setString(4, entidad.getApellidoMaterno());
                psDocente.setString(5, entidad.getCorreo().trim().toLowerCase());
                psDocente.setInt(6, idContrasenaGenerado);
                psDocente.setInt(7, entidad.getRolIdRol() > 0 ? entidad.getRolIdRol() : 2);
                psDocente.setString(8, entidad.getFotoPerfil() != null ? entidad.getFotoPerfil() : "default.png");

                int filas = psDocente.executeUpdate();
                con.commit();
                return filas > 0;
            }

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            e.printStackTrace();
            return false;
        } finally {
            restaurarYCerrar(con);
        }
    }

    public Docente loginByCorreo(String correo, String contrasena) {

        /*
         * OPTIMIZACIÓN SQL:
         * Quitamos el LOWER(TRIM(d.correo)) de la base de datos.
         * Como ya limpiamos la variable en Java, hacer esto directamente en el WHERE
         * permite que la base de datos use sus índices (haciendo la consulta mucho más rápida).
         */
        String sql = "SELECT " +
                "d.id_docente, d.nombre, d.apellido_paterno, d.apellido_materno, " +
                "d.correo, d.rol_id_rol, d.foto_perfil, c.hash_password " +
                "FROM docente d " +
                "INNER JOIN contrasena c ON d.id_contrasena = c.id_contrasena " +
                "WHERE d.correo = ?";

        // Limpieza de inputs
        String correoLimpio = correo != null ? correo.trim().toLowerCase() : "";
        String passInputLimpia = contrasena != null ? contrasena.trim() : "";

        try (
                Connection con = obtenerConexionValida();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setString(1, correoLimpio);

            try (ResultSet rs = ps.executeQuery()) {

                // 1. Verificamos si la consulta arrojó resultados
                if (rs.next()) {
                    String hashBD = rs.getString("hash_password");

                    // 2. Verificamos si la contraseña coincide
                    if (validarPassword(passInputLimpia, hashBD)) {
                        System.out.println(">>> [EXITO] Login exitoso para el docente: " + correoLimpio);
                        return mapearDocente(rs);
                    } else {
                        // FALLO 1: El correo existe, pero la contraseña no hace match.
                        System.out.println(">>> [FALLO] Contraseña incorrecta para: " + correoLimpio);
                        System.out.println("    -> Hash guardado en BD: " + hashBD);
                    }
                } else {
                    // FALLO 2: El correo NO existe, o el INNER JOIN falló (No tiene contraseña ligada).
                    System.out.println(">>> [FALLO] Usuario no encontrado o sin contraseña vinculada: " + correoLimpio);
                }
            }

        } catch (SQLException e) {
            System.err.println(">>> [ERROR SQL] Fallo en loginByCorreo:");
            e.printStackTrace();
        }

        return null; // Si algo falla, retorna null para que el Servlet muestre el mensaje de error.
    }

    public Docente login(String idOrCorreo, String contrasena) {
        String sql = "SELECT d.id_docente, d.nombre, d.apellido_paterno, d.apellido_materno, d.correo, d.rol_id_rol, d.foto_perfil, c.hash_password " +
                "FROM docente d " +
                "LEFT JOIN contrasena c ON d.id_contrasena = c.id_contrasena " +
                "WHERE LOWER(TRIM(d.correo)) = LOWER(TRIM(?)) " +
                "OR CAST(d.id_docente AS VARCHAR2(50)) = TRIM(?)";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String valor = idOrCorreo != null ? idOrCorreo.trim() : "";
            ps.setString(1, valor);
            ps.setString(2, valor);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String passInput = contrasena != null ? contrasena.trim() : "";
                    if (validarPassword(passInput, rs.getString("hash_password"))) {
                        return mapearDocente(rs);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Docente mapearDocente(ResultSet rs) throws SQLException {
        Docente d = new Docente();
        d.setIdDocente(rs.getInt("id_docente"));
        d.setNombre(rs.getString("nombre"));
        d.setApellidoPaterno(rs.getString("apellido_paterno"));
        d.setApellidoMaterno(rs.getString("apellido_materno"));
        d.setCorreo(rs.getString("correo"));
        d.setHashPassword(rs.getString("hash_password"));
        d.setRolIdRol(rs.getInt("rol_id_rol"));
        d.setFotoPerfil(rs.getString("foto_perfil"));
        return d;
    }

    /**
     * La versión anterior aceptaba también la comparación directa contra el valor almacenado.
     * Eso significaba que quien conociera el hash guardado podía escribirlo como contraseña
     * y entrar. Ahora la comparación en texto plano solo aplica cuando el valor de la BD
     * claramente NO es un hash SHA-256, para no romper cuentas antiguas cargadas a mano.
     */
    private boolean validarPassword(String passInput, String passBD) {
        if (passBD == null || passInput == null) return false;

        String cleanBD = passBD.trim();
        String cleanInput = passInput.trim();
        String inputHash = SecurityUtils.hashPassword(cleanInput);

        if (inputHash != null && inputHash.equalsIgnoreCase(cleanBD)) {
            return true;
        }

        // Compatibilidad con registros heredados guardados sin hashear.
        return !esHashSha256(cleanBD) && cleanInput.equals(cleanBD);
    }

    private boolean esHashSha256(String valor) {
        return valor != null && valor.length() == 64 && valor.matches("^[a-fA-F0-9]+$");
    }

    /**
     * Reemplaza la contraseña del docente identificado por su correo.
     * Si el docente existe pero no tiene fila en 'contrasena', se crea y se enlaza.
     */
    public boolean actualizarPasswordPorCorreo(String correo, String nuevaPassword) {
        if (correo == null || nuevaPassword == null) return false;

        String passwordHash = SecurityUtils.hashPassword(nuevaPassword.trim());
        String correoLimpio = correo.trim().toLowerCase();

        String sqlUpdate = "UPDATE contrasena SET hash_password = ? " +
                "WHERE id_contrasena = (SELECT id_contrasena FROM docente WHERE LOWER(TRIM(correo)) = ?)";

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
                System.out.println(">>> [DocenteDao] Contraseña actualizada para: [" + correoLimpio + "]");
                return true;
            }

            con.rollback();
            System.err.println(">>> [DocenteDao] No existe docente con el correo: [" + correoLimpio + "]");
            return false;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [DocenteDao] Error al actualizar la contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            restaurarYCerrar(con);
        }
    }

    private int crearYEnlazarContrasena(Connection con, String correoLimpio, String passwordHash)
            throws SQLException {

        try (PreparedStatement psCheck = con.prepareStatement(
                "SELECT COUNT(*) FROM docente WHERE LOWER(TRIM(correo)) = ?")) {
            psCheck.setString(1, correoLimpio);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (!rs.next() || rs.getInt(1) == 0) {
                    return 0;
                }
            }
        }

        int idContrasena = -1;
        try (PreparedStatement psInsert = con.prepareStatement(
                "INSERT INTO contrasena (hash_password) VALUES (?)", new String[]{"ID_CONTRASENA"})) {
            psInsert.setString(1, passwordHash);
            psInsert.executeUpdate();
            try (ResultSet rs = psInsert.getGeneratedKeys()) {
                if (rs.next()) {
                    idContrasena = rs.getInt(1);
                }
            }
        }

        if (idContrasena <= 0) return 0;

        try (PreparedStatement psLink = con.prepareStatement(
                "UPDATE docente SET id_contrasena = ? WHERE LOWER(TRIM(correo)) = ?")) {
            psLink.setInt(1, idContrasena);
            psLink.setString(2, correoLimpio);
            return psLink.executeUpdate();
        }
    }
    public boolean actualizarPerfil(Docente d) {
        if (d == null || d.getIdDocente() <= 0) return false;

        boolean cambiaFoto = d.getFotoPerfil() != null && !d.getFotoPerfil().trim().isEmpty();

        String sql = cambiaFoto
                ? "UPDATE docente SET nombre = ?, apellido_paterno = ?, apellido_materno = ?, correo = ?, foto_perfil = ? WHERE id_docente = ?"
                : "UPDATE docente SET nombre = ?, apellido_paterno = ?, apellido_materno = ?, correo = ? WHERE id_docente = ?";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;
            ps.setString(i++, d.getNombre());
            ps.setString(i++, d.getApellidoPaterno());
            ps.setString(i++, d.getApellidoMaterno());
            ps.setString(i++, d.getCorreo().trim().toLowerCase());
            if (cambiaFoto) ps.setString(i++, d.getFotoPerfil().trim());
            ps.setInt(i, d.getIdDocente());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("--> ERROR AL ACTUALIZAR PERFIL DOCENTE: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}