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
        return con;
    }

    public boolean create(Docente entidad) {
        String sqlPass = "INSERT INTO contrasena (hash_password) VALUES (?)";
        String sqlDocente = "INSERT INTO docente (id_docente, nombre, apellido_paterno, apellido_materno, correo, id_contrasena, rol_id_rol, foto_perfil) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = obtenerConexionValida()) {
            con.setAutoCommit(false);
            int idContrasenaGenerado = -1;

            String passOriginal = entidad.getHashPassword() != null ? entidad.getHashPassword().trim() : "";
            if (passOriginal.isEmpty()) {
                con.rollback();
                return false;
            }

            // Evitar re-hashear si ya viene en SHA-256 (64 chars hex)
            String passToSave;
            if (passOriginal.length() == 64 && passOriginal.matches("^[a-fA-F0-9]+$")) {
                passToSave = passOriginal.toLowerCase();
            } else {
                passToSave = SecurityUtils.hashPassword(passOriginal);
            }

            // IMPRIMIR EN CONSOLA PARA VERIFICAR EL REGISTRO
            System.out.println(">>> DOCENTE REGISTRANDO: " + entidad.getCorreo());
            System.out.println(">>> HASH A GUARDAR EN BD (" + passToSave.length() + " chars): " + passToSave);

            // 1. Insertar en la tabla CONTRASENA
            try (PreparedStatement psPass = con.prepareStatement(sqlPass, new String[]{"ID_CONTRASENA"})) {
                psPass.setString(1, passToSave);
                psPass.executeUpdate();

                try (ResultSet rs = psPass.getGeneratedKeys()) {
                    if (rs.next()) {
                        idContrasenaGenerado = rs.getInt(1);
                    }
                }
            }

            // Respaldo de obtención de ID de contraseña
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

            // 2. Generar SIEMPRE un ID_DOCENTE consecutivo automático (1, 2, 3...)
            int idDocenteFinal = 1;
            try (PreparedStatement psMax = con.prepareStatement("SELECT NVL(MAX(id_docente), 0) + 1 FROM docente");
                 ResultSet rsMax = psMax.executeQuery()) {
                if (rsMax.next()) {
                    idDocenteFinal = rsMax.getInt(1);
                }
            }

            // 3. Insertar en la tabla DOCENTE
            try (PreparedStatement psDocente = con.prepareStatement(sqlDocente)) {
                psDocente.setInt(1, idDocenteFinal);
                psDocente.setString(2, entidad.getNombre());
                psDocente.setString(3, entidad.getApellidoPaterno());
                psDocente.setString(4, entidad.getApellidoMaterno());
                psDocente.setString(5, entidad.getCorreo());
                psDocente.setInt(6, idContrasenaGenerado);
                psDocente.setInt(7, entidad.getRolIdRol() > 0 ? entidad.getRolIdRol() : 2);
                psDocente.setString(8, entidad.getFotoPerfil() != null ? entidad.getFotoPerfil() : "default.png");

                int filas = psDocente.executeUpdate();
                con.commit();
                return filas > 0;
            } catch (SQLException e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Docente loginByCorreo(String correo, String contrasena) {
        String sql = "SELECT d.id_docente, d.nombre, d.apellido_paterno, d.apellido_materno, d.correo, d.rol_id_rol, d.foto_perfil, c.hash_password " +
                "FROM docente d " +
                "INNER JOIN contrasena c ON d.id_contrasena = c.id_contrasena " +
                "WHERE LOWER(TRIM(d.correo)) = LOWER(?)";

        String correoLimpio = correo != null ? correo.trim().toLowerCase() : "";
        String passInputLimpia = contrasena != null ? contrasena.trim() : "";

        try (Connection con = obtenerConexionValida();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correoLimpio);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String passBD = rs.getString("hash_password");

                    System.out.println(">>> DOCENTE ENCONTRADO EN BD: " + rs.getString("correo"));
                    System.out.println(">>> HASH EN BD (" + (passBD != null ? passBD.length() : 0) + " chars): " + passBD);
                    System.out.println(">>> HASH INGRESADO EN LOGIN: " + SecurityUtils.hashPassword(passInputLimpia));

                    if (validarPassword(passInputLimpia, passBD)) {
                        Docente d = new Docente();
                        d.setIdDocente(rs.getInt("id_docente"));
                        d.setNombre(rs.getString("nombre"));
                        d.setApellidoPaterno(rs.getString("apellido_paterno"));
                        d.setApellidoMaterno(rs.getString("apellido_materno"));
                        d.setCorreo(rs.getString("correo"));
                        d.setHashPassword(passBD);
                        d.setRolIdRol(rs.getInt("rol_id_rol"));
                        d.setFotoPerfil(rs.getString("foto_perfil"));
                        return d;
                    } else {
                        System.out.println(">>> FALLO: Las contraseñas NO coinciden.");
                    }
                } else {
                    System.out.println(">>> FALLO: No existe ningún registro en la BD para el correo: [" + correoLimpio + "]");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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
                    String passBD = rs.getString("hash_password");
                    String passInput = contrasena != null ? contrasena.trim() : "";

                    if (validarPassword(passInput, passBD)) {
                        Docente d = new Docente();
                        d.setIdDocente(rs.getInt("id_docente"));
                        d.setNombre(rs.getString("nombre"));
                        d.setApellidoPaterno(rs.getString("apellido_paterno"));
                        d.setApellidoMaterno(rs.getString("apellido_materno"));
                        d.setCorreo(rs.getString("correo"));
                        d.setHashPassword(passBD);
                        d.setRolIdRol(rs.getInt("rol_id_rol"));
                        d.setFotoPerfil(rs.getString("foto_perfil"));
                        return d;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private boolean validarPassword(String passInput, String passBD) {
        if (passBD == null || passInput == null) return false;
        String cleanBD = passBD.trim();
        String cleanInput = passInput.trim();
        String inputHash = SecurityUtils.hashPassword(cleanInput);

        return (inputHash != null && inputHash.equalsIgnoreCase(cleanBD))
                || cleanInput.equalsIgnoreCase(cleanBD);
    }
}