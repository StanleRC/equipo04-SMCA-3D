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
import java.util.List;

public class AlumnoDao {

    public boolean create(Alumno entidad) {
        String sqlContrasena = "INSERT INTO contrasena (hash_password) VALUES (?)";
        String sqlAlumno = "INSERT INTO alumno (matricula, nombre, apellido_paterno, apellido_materno, correo, id_contrasena, grupo_id_grupo, rol_id_rol, foto_perfil) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        Connection con = null;
        PreparedStatement psPass = null;
        PreparedStatement psAlumno = null;
        ResultSet rsKeys = null;

        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            // Se encripta la contraseña y SE GUARDA EN LA BASE DE DATOS
            String passwordHash = SecurityUtils.hashPassword(entidad.getHashPassword());

            psPass = con.prepareStatement(sqlContrasena, new String[]{"ID_CONTRASENA"});
            psPass.setString(1, passwordHash);
            psPass.executeUpdate();

            rsKeys = psPass.getGeneratedKeys();
            long idContrasenaGenerado = -1;
            if (rsKeys != null && rsKeys.next()) {
                idContrasenaGenerado = rsKeys.getLong(1);
            } else {
                throw new SQLException("No se obtuvo el ID_CONTRASENA.");
            }

            psAlumno = con.prepareStatement(sqlAlumno);
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
            try { if (rsKeys != null) rsKeys.close(); } catch (SQLException ignored) {}
            try { if (psPass != null) psPass.close(); } catch (SQLException ignored) {}
            try { if (psAlumno != null) psAlumno.close(); } catch (SQLException ignored) {}
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (SQLException ignored) {}
        }
    }

    public Alumno login(String matricula, String contrasena) {
        if (matricula == null || contrasena == null) return null;

        String sql = "SELECT a.matricula, a.nombre, a.apellido_paterno, a.apellido_materno, a.correo, a.grupo_id_grupo, " +
                "a.rol_id_rol, a.foto_perfil, c.hash_password " +
                "FROM alumno a " +
                "INNER JOIN contrasena c ON a.id_contrasena = c.id_contrasena " +
                "WHERE UPPER(TRIM(a.matricula)) = UPPER(TRIM(?))";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("--> LOGIN EXITOSO: Matrícula [" + matricula.trim() + "]");
                    return mapResultSetToAlumno(rs);
                } else {
                    System.out.println("--> LOGIN FALLIDO: Matrícula no encontrada.");
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

        try (Connection con = SQLConnector.getConnection();
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

        try (Connection con = SQLConnector.getConnection();
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

        try (Connection con = SQLConnector.getConnection();
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

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Alumno getPerfilCompletoByMatricula(String matricula) {
        String sql = "SELECT a.matricula, a.nombre, a.apellido_paterno, a.apellido_materno, a.correo, a.foto_perfil, " +
                "g.id_grupo, g.grado, g.numero_grupo, c.nombre_carrera " +
                "FROM alumno a " +
                "INNER JOIN grupo g ON a.grupo_id_grupo = g.id_grupo " +
                "INNER JOIN carrera c ON g.carrera_id_carrera = c.id_carrera " +
                "WHERE UPPER(TRIM(a.matricula)) = UPPER(TRIM(?))";

        try (Connection con = SQLConnector.getConnection();
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
            e.printStackTrace();
        }
        return null;
    }

    public List<HistorialAlumnoDto> getHistorialByMatricula(String matricula) {
        List<HistorialAlumnoDto> lista = new ArrayList<>();
        String sql = "SELECT g.grado, g.numero_grupo, a.matricula, " +
                "(a.nombre || ' ' || a.apellido_paterno || ' ' || a.apellido_materno) AS nombre_completo, " +
                "TO_CHAR(b.fecha, 'DD/MM/YYYY') AS fecha_formateada, " +
                "b.estado_asistencia " +
                "FROM bitacora b " +
                "INNER JOIN alumno a ON UPPER(TRIM(b.alumno_matricula)) = UPPER(TRIM(a.matricula)) " +
                "INNER JOIN grupo g ON a.grupo_id_grupo = g.id_grupo " +
                "WHERE UPPER(TRIM(a.matricula)) = UPPER(TRIM(?)) " +
                "ORDER BY b.fecha DESC";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, matricula.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistorialAlumnoDto h = new HistorialAlumnoDto();
                    h.setGrado(rs.getString("grado"));
                    h.setGrupo(rs.getString("numero_grupo"));
                    h.setMatricula(rs.getString("matricula"));
                    h.setNombreCompleto(rs.getString("nombre_completo"));
                    h.setFecha(rs.getString("fecha_formateada"));
                    h.setEstado(rs.getString("estado_asistencia"));
                    lista.add(h);
                }
            }
        } catch (SQLException e) {
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
        } catch (SQLException ignored) {}

        return a;
    }
}