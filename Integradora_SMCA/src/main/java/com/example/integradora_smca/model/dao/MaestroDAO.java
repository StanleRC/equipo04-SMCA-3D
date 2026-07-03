package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Maestro;
import com.example.integradora_smca.utils.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MaestroDAO {

    public Maestro autenticarMaestro(String correo, String contrasena) {
        Maestro maestro = null;
        String sql = "SELECT * FROM maestros WHERE correo = ? AND contrasena = ?";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, correo);
            ps.setString(2, contrasena);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    maestro = new Maestro();
                    maestro.setId(rs.getInt("id"));
                    maestro.setNombre(rs.getString("nombre"));
                    maestro.setApellidoPaterno(rs.getString("apellido_paterno"));
                    maestro.setApellidoMaterno(rs.getString("apellido_materno"));
                    maestro.setCorreo(rs.getString("correo"));
                    maestro.setRol(rs.getString("rol"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return maestro;
    }

    public boolean registrarMaestro(Maestro maestro) {
        String sql = "INSERT INTO maestros (nombre, apellido_paterno, apellido_materno, correo, contrasena, telefono, rol) VALUES (?, ?, ?, ?, ?, ?, 'docente')";
        try (Connection con = Conexion.getConexion(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, maestro.getNombre());
            ps.setString(2, maestro.getApellidoPaterno());
            ps.setString(3, maestro.getApellidoMaterno());
            ps.setString(4, maestro.getCorreo());
            ps.setString(5, maestro.getContrasena());
            ps.setString(6, maestro.getTelefono());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}