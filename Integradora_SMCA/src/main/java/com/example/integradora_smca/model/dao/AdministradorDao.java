package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Administrador;
import com.example.integradora_smca.model.SecurityUtils;
import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Acceso a la tabla ADMINISTRADOR.
 *
 * Espeja a DocenteDao a propósito: mismos nombres de método, para que los servlets
 * puedan intentar con uno y luego con el otro sin escribir dos flujos distintos.
 */
public class AdministradorDao {

    private static final String SELECT_LOGIN =
            "SELECT a.id_administrador, a.nombre, a.apellido_paterno, a.apellido_materno, " +
                    "       a.correo, a.rol_id_rol, a.foto_perfil, c.hash_password " +
                    "FROM administrador a " +
                    "INNER JOIN contrasena c ON c.id_contrasena = a.id_contrasena ";

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

    // ------------------------------------------------------------------
    // Consultas
    // ------------------------------------------------------------------

    public boolean existeCorreo(String correo) {
        if (correo == null || correo.trim().isEmpty()) return false;

        String sql = "SELECT COUNT(*) FROM administrador WHERE LOWER(TRIM(correo)) = LOWER(TRIM(?))";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Administrador loginByCorreo(String correo, String contrasena) {
        String sql = SELECT_LOGIN + "WHERE LOWER(TRIM(a.correo)) = LOWER(TRIM(?))";

        String correoLimpio = correo != null ? correo.trim().toLowerCase() : "";
        String passLimpia = contrasena != null ? contrasena.trim() : "";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correoLimpio);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && validarPassword(passLimpia, rs.getString("hash_password"))) {
                    return mapear(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println(">>> [AdministradorDao] Error en login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Administrador getById(String idAdministrador) {
        if (idAdministrador == null) return null;

        String sql = SELECT_LOGIN + "WHERE TRIM(a.id_administrador) = TRIM(?)";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, idAdministrador.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ------------------------------------------------------------------
    // Modificaciones
    // ------------------------------------------------------------------

    /**
     * Guarda los datos del perfil.
     * Si fotoPerfil viene vacío no se toca la columna, para que editar el nombre
     * sin subir imagen no borre la foto que ya estaba guardada.
     */
    public boolean actualizarPerfil(Administrador a) {
        if (a == null || a.getIdAdministrador() == null) return false;

        boolean cambiaFoto = a.getFotoPerfil() != null && !a.getFotoPerfil().trim().isEmpty();

        String sql = cambiaFoto
                ? "UPDATE administrador SET nombre = ?, apellido_paterno = ?, apellido_materno = ?, "
                + "correo = ?, foto_perfil = ? WHERE TRIM(id_administrador) = TRIM(?)"
                : "UPDATE administrador SET nombre = ?, apellido_paterno = ?, apellido_materno = ?, "
                + "correo = ? WHERE TRIM(id_administrador) = TRIM(?)";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;
            ps.setString(i++, a.getNombre());
            ps.setString(i++, a.getApellidoPaterno());
            ps.setString(i++, a.getApellidoMaterno());
            ps.setString(i++, a.getCorreo().trim().toLowerCase());
            if (cambiaFoto) ps.setString(i++, a.getFotoPerfil().trim());
            ps.setString(i, a.getIdAdministrador());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            // Suele caer aquí si el correo ya pertenece a otro usuario (restricción UNIQUE).
            System.err.println(">>> [AdministradorDao] Error al actualizar perfil: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /** Necesario para que el flujo de recuperación de contraseña también cubra a los admins. */
    public boolean actualizarPasswordPorCorreo(String correo, String nuevaPassword) {
        if (correo == null || nuevaPassword == null) return false;

        String passwordHash = SecurityUtils.hashPassword(nuevaPassword.trim());
        String correoLimpio = correo.trim().toLowerCase();

        String sql = "UPDATE contrasena SET hash_password = ? " +
                "WHERE id_contrasena = " +
                "(SELECT id_contrasena FROM administrador WHERE LOWER(TRIM(correo)) = ?)";

        Connection con = null;
        try {
            con = obtenerConexionValida();
            con.setAutoCommit(false);

            int filas;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, passwordHash);
                ps.setString(2, correoLimpio);
                filas = ps.executeUpdate();
            }

            if (filas > 0) {
                con.commit();
                System.out.println(">>> [AdministradorDao] Contraseña actualizada para: " + correoLimpio);
                return true;
            }

            con.rollback();
            return false;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [AdministradorDao] Error al cambiar contraseña: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            restaurarYCerrar(con);
        }
    }

    // ------------------------------------------------------------------
    // Apoyo
    // ------------------------------------------------------------------

    private Administrador mapear(ResultSet rs) throws SQLException {
        Administrador a = new Administrador();
        a.setIdAdministrador(rs.getString("id_administrador"));
        a.setNombre(rs.getString("nombre"));
        a.setApellidoPaterno(rs.getString("apellido_paterno"));
        a.setApellidoMaterno(rs.getString("apellido_materno"));
        a.setCorreo(rs.getString("correo"));
        a.setHashPassword(rs.getString("hash_password"));
        a.setRolIdRol(rs.getInt("rol_id_rol"));
        a.setFotoPerfil(rs.getString("foto_perfil"));
        return a;
    }

    /**
     * Compara contra el SHA-256 guardado.
     * La comparación en texto plano solo aplica cuando el valor de la base
     * claramente NO es un hash, para no romper cuentas cargadas a mano.
     */
    private boolean validarPassword(String passInput, String passBD) {
        if (passBD == null || passInput == null) return false;

        String cleanBD = passBD.trim();
        String cleanInput = passInput.trim();
        String inputHash = SecurityUtils.hashPassword(cleanInput);

        if (inputHash != null && inputHash.equalsIgnoreCase(cleanBD)) {
            return true;
        }
        return !esHashSha256(cleanBD) && cleanInput.equals(cleanBD);
    }

    private boolean esHashSha256(String valor) {
        return valor != null && valor.length() == 64 && valor.matches("^[a-fA-F0-9]+$");
    }
}