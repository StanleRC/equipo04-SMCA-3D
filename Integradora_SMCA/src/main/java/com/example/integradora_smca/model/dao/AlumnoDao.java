package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.HistorialAlumnoDto;
import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AlumnoDao {

    public boolean create(Alumno entidad) {
        String sql = "INSERT INTO alumno (matricula, nombre, apellidos, correo, hash_password, grupo_id_grupo, rol_id_rol, foto_perfil) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, entidad.getMatricula());
            ps.setString(2, entidad.getNombre());
            ps.setString(3, entidad.getApellidos());
            ps.setString(4, entidad.getCorreo());
            ps.setString(5, entidad.getHashPassword());
            ps.setString(6, entidad.getGrupoIdGrupo());
            ps.setInt(7, entidad.getRolIdRol());
            ps.setString(8, entidad.getFotoPerfil());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Alumno> getAll() {
        List<Alumno> lista = new ArrayList<>();
        String sql = "SELECT * FROM alumno";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Alumno a = new Alumno();
                a.setMatricula(rs.getString("matricula"));
                a.setNombre(rs.getString("nombre"));
                a.setApellidos(rs.getString("apellidos"));
                a.setCorreo(rs.getString("correo"));
                a.setHashPassword(rs.getString("hash_password"));
                a.setGrupoIdGrupo(rs.getString("grupo_id_grupo"));
                a.setRolIdRol(rs.getInt("rol_id_rol"));
                a.setFotoPerfil(rs.getString("foto_perfil"));
                lista.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Alumno getById(String id) {
        String sql = "SELECT * FROM alumno WHERE matricula = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Alumno a = new Alumno();
                    a.setMatricula(rs.getString("matricula"));
                    a.setNombre(rs.getString("nombre"));
                    a.setApellidos(rs.getString("apellidos"));
                    a.setCorreo(rs.getString("correo"));
                    a.setHashPassword(rs.getString("hash_password"));
                    a.setGrupoIdGrupo(rs.getString("grupo_id_grupo"));
                    a.setRolIdRol(rs.getInt("rol_id_rol"));
                    a.setFotoPerfil(rs.getString("foto_perfil"));
                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(Alumno entidad) {
        String sql = "UPDATE alumno SET nombre = ?, apellidos = ?, correo = ?, foto_perfil = ? WHERE matricula = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, entidad.getNombre());
            ps.setString(2, entidad.getApellidos());
            ps.setString(3, entidad.getCorreo());
            ps.setString(4, entidad.getFotoPerfil());
            ps.setString(5, entidad.getMatricula());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String id) {
        String sql = "DELETE FROM alumno WHERE matricula = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Alumno login(String matricula, String contrasena) {
        String sql = "SELECT * FROM alumno WHERE matricula = ? AND hash_password = ?";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            ps.setString(2, contrasena);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Alumno a = new Alumno();
                    a.setMatricula(rs.getString("matricula"));
                    a.setNombre(rs.getString("nombre"));
                    a.setApellidos(rs.getString("apellidos"));
                    a.setCorreo(rs.getString("correo"));
                    a.setGrupoIdGrupo(rs.getString("grupo_id_grupo"));
                    a.setRolIdRol(rs.getInt("rol_id_rol"));
                    a.setFotoPerfil(rs.getString("foto_perfil"));
                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Obtiene la información del alumno junto con los datos de su grupo y carrera
    public Alumno getPerfilCompletoByMatricula(String matricula) {
        String sql = "SELECT a.matricula, a.nombre, a.apellidos, a.correo, a.foto_perfil, " +
                "g.id_grupo, g.grado, g.numero_grupo, c.nombre_carrera " +
                "FROM alumno a " +
                "INNER JOIN grupo g ON a.grupo_id_grupo = g.id_grupo " +
                "INNER JOIN carrera c ON g.carrera_id_carrera = c.id_carrera " +
                "WHERE a.matricula = ?";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Alumno a = new Alumno();
                    a.setMatricula(rs.getString("matricula"));
                    a.setNombre(rs.getString("nombre"));
                    a.setApellidos(rs.getString("apellidos"));
                    a.setCorreo(rs.getString("correo"));
                    a.setFotoPerfil(rs.getString("foto_perfil"));
                    a.setGrupoIdGrupo(rs.getString("id_grupo"));

                    return a;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Obtiene el historial de registros de la bitácora filtrado por el alumno
    public List<HistorialAlumnoDto> getHistorialByMatricula(String matricula) {
        List<HistorialAlumnoDto> lista = new ArrayList<>();
        String sql = "SELECT g.grado, g.numero_grupo, b.numero_pc, a.matricula, " +
                "CONCAT(a.nombre, ' ', a.apellidos) AS nombre_completo, " +
                "DATE_FORMAT(b.fecha_hora, '%d/%m/%Y') AS fecha_formateada, " +
                "IFNULL(b.incidencia, 'Ninguna') AS incidencia, b.estado " +
                "FROM bitacora b " +
                "INNER JOIN alumno a ON b.alumno_matricula = a.matricula " +
                "INNER JOIN grupo g ON a.grupo_id_grupo = g.id_grupo " +
                "WHERE a.matricula = ? " +
                "ORDER BY b.fecha_hora DESC";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistorialAlumnoDto h = new HistorialAlumnoDto();
                    h.setGrado(rs.getString("grado"));
                    h.setGrupo(rs.getString("numero_grupo"));
                    h.setNumeroPc(rs.getString("numero_pc"));
                    h.setMatricula(rs.getString("matricula"));
                    h.setNombreCompleto(rs.getString("nombre_completo"));
                    h.setFecha(rs.getString("fecha_formateada"));
                    h.setIncidencia(rs.getString("incidencia"));
                    h.setEstado(rs.getString("estado"));
                    lista.add(h);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}