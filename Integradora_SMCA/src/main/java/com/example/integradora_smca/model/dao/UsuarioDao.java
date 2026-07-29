package com.example.integradora_smca.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.example.integradora_smca.utils.SQLConnector;

public class UsuarioDao {

    // Método para validar Alumnos (Ajustado a tu BD real)
    public Alumno loginAlumno(String matricula, String password) {
        Alumno alumno = null;
        // 1. Quitamos FOTO_PERFIL y corregimos a CONTRASENA_ALU y ADMIN.ALUMNO
        String sql = "SELECT MATRICULA_ALUMNO, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, ID_ROL FROM ADMIN.ALUMNO WHERE MATRICULA_ALUMNO = ? AND CONTRASENA_ALUMNO = ?";

        try (Connection con = SQLConnector.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    alumno = new Alumno();
                    alumno.setMatricula(rs.getString("MATRICULA_ALUMNO"));
                    alumno.setNombre(rs.getString("NOMBRE"));
                    alumno.setApellidoPaterno(rs.getString("APELLIDO_PATERNO"));
                    alumno.setApellidoMaterno(rs.getString("APELLIDO_MATERNO"));
                    alumno.setIdRol(rs.getInt("ID_ROL"));

                    // Como no hay columna de foto en la BD, le ponemos una temporal vacía.
                    // Tu sidebar automáticamente usará el placeholder de prueba que programamos.
                    alumno.setFotoPerfil("");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return alumno;
    }

    // Método para validar Docentes (Ajustado también por si acaso)
    public Docente loginDocente(String correo, String password) {
        Docente docente = null;
        // Ajustado de igual manera sin la columna FOTO_PERFIL por ahora
        String sql = "SELECT CORREO_INSTITUCIONAL, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, ID_ROL FROM ADMIN.DOCENTE WHERE CORREO_INSTITUCIONAL = ? AND CONTRASEÑA_DOCENTE = ?";

        try (Connection con = SQLConnector.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    docente = new Docente();
                    docente.setCorreo(rs.getString("CORREO_INSTITUCIONAL"));
                    docente.setNombre(rs.getString("NOMBRE"));
                    docente.setApellidoPaterno(rs.getString("APELLIDO_PATERNO"));
                    docente.setApellidoMaterno(rs.getString("APELLIDO_MATERNO"));
                    docente.setIdRol(rs.getInt("ID_ROL"));
                    docente.setFotoPerfil("");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return docente;
    }
}