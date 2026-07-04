package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.utils.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AlumnoDAO {

    // Método de autenticación por matrícula basado en tu base SQL
    public Alumno autenticarAlumno(String matricula, String contrasena) {
        Alumno alumno = null;
        String sql = "SELECT * FROM alumnos WHERE matricula = ? AND contrasena = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula);
            ps.setString(2, contrasena);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    alumno = new Alumno();
                    alumno.setId(rs.getInt("id"));
                    alumno.setNombre(rs.getString("nombre"));
                    alumno.setCorreo(rs.getString("correo"));
                    alumno.setMatricula(rs.getString("matricula"));
                    alumno.setRol(rs.getString("rol"));
                }
            }
        } catch (Exception e) {
            System.err.println("Error en AlumnoDAO al intentar autenticar: " + e.getMessage());
            e.printStackTrace();
        }
        return alumno; // Retornará null si no coincide la matrícula o contraseña
    }
}