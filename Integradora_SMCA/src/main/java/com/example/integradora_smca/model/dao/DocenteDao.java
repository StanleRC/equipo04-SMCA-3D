package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DocenteDao {

    public boolean create(Docente entidad) {
        String sql = "INSERT INTO docente (nombre, apellidos, correo, hash_password, rol_id_rol, foto_perfil) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, entidad.getNombre());
            ps.setString(2, entidad.getApellidos());
            ps.setString(3, entidad.getCorreo());
            ps.setString(4, entidad.getHashPassword());
            ps.setInt(5, entidad.getRolIdRol());
            ps.setString(6, entidad.getFotoPerfil());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Docente> getAll() {
        List<Docente> lista = new ArrayList<>();
        String sql = "SELECT * FROM docente";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Docente d = new Docente();
                d.setNombre(rs.getString("nombre"));
                d.setApellidos(rs.getString("apellidos"));
                d.setCorreo(rs.getString("correo"));
                d.setHashPassword(rs.getString("hash_password"));
                d.setRolIdRol(rs.getInt("rol_id_rol"));
                d.setFotoPerfil(rs.getString("foto_perfil"));
                lista.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Docente getById(String id) {
        String sql = "SELECT * FROM docente WHERE id_docente = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Docente d = new Docente();
                    d.setNombre(rs.getString("nombre"));
                    d.setApellidos(rs.getString("apellidos"));
                    d.setCorreo(rs.getString("correo"));
                    d.setHashPassword(rs.getString("hash_password"));
                    d.setRolIdRol(rs.getInt("rol_id_rol"));
                    d.setFotoPerfil(rs.getString("foto_perfil"));
                    return d;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(Docente entidad) {
        String sql = "UPDATE docente SET nombre = ?, apellidos = ?, correo = ?, foto_perfil = ? WHERE id_docente = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, entidad.getNombre());
            ps.setString(2, entidad.getApellidos());
            ps.setString(3, entidad.getCorreo());
            ps.setString(4, entidad.getFotoPerfil());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String id) {
        String sql = "DELETE FROM docente WHERE id_docente = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Docente login(String idDocente, String contrasena) {
        String sql = "SELECT * FROM docente WHERE id_docente = ? AND hash_password = ?";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, idDocente.trim());
            ps.setString(2, contrasena);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Docente d = new Docente();

                    d.setNombre(rs.getString("nombre"));
                    d.setApellidos(rs.getString("apellidos"));
                    d.setCorreo(rs.getString("correo"));
                    d.setRolIdRol(rs.getInt("rol_id_rol"));
                    d.setFotoPerfil(rs.getString("foto_perfil"));
                    return d;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Docente loginByCorreo(String correo, String contrasena) {
        String sql = "SELECT * FROM docente WHERE correo = ? AND hash_password = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);
            ps.setString(2, contrasena);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Docente d = new Docente();

                    // Si id_docente es autoincremental NUMBER
                    d.setIdDocente(rs.getInt("id_docente"));

                    d.setNombre(rs.getString("nombre"));
                    d.setApellidos(rs.getString("apellidos"));
                    d.setCorreo(rs.getString("correo"));
                    d.setHashPassword(rs.getString("hash_password"));
                    d.setRolIdRol(rs.getInt("rol_id_rol"));
                    d.setFotoPerfil(rs.getString("foto_perfil"));

                    return d;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
