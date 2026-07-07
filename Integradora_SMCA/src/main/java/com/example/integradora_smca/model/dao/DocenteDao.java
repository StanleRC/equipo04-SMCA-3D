package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.dao.Docente;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DocenteDao {

    // Configuración para Oracle XE (Ajusta localhost, puerto de red y el SID/Servicio "XE" o "ORCL")
    private final String url = "jdbc:oracle:thin:@localhost:1521:XE";
    private final String user = "tu_usuario_oracle";
    private final String password = "tu_password_oracle";
    private final String driver = "oracle.jdbc.driver.OracleDriver";

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName(driver);
        return DriverManager.getConnection(url, user, password);
    }

    public boolean registrarDocente(Docente docente) {
        // Query adaptado a las columnas exactas de tu tabla DOCENTE
        String sql = "INSERT INTO DOCENTE (correo_institucional, nombre, apellido_paterno, apellido_materno, id_rol, contrasena, telefono) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, docente.getCorreoInstitucional());
            ps.setString(2, docente.getNombre());
            ps.setString(3, docente.getApellidoPaterno());
            ps.setString(4, docente.getApellidoMaterno());
            ps.setInt(5, docente.getIdRol()); // Por defecto guarda 2
            ps.setString(6, docente.getContrasena());
            ps.setString(7, docente.getTelefono());

            int filas = ps.executeUpdate();
            return filas > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
}