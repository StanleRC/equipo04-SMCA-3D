package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Consultas sobre GRUPO y CARRERA.
 *
 * Sirven para llenar los selectores de los formularios de registro. Antes esos
 * <option> estaban escritos a mano con un solo grupo ('DSM3D'), así que al dar
 * de alta un grupo nuevo no aparecía en ningún lado.
 *
 * Nota del esquema real: la columna es grupo.letra_grupo, no numero_grupo.
 */
public class GrupoDao {

    /** Carreras disponibles, para el primer selector. */
    public List<Map<String, Object>> listarCarreras() {
        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT id_carrera, nombre_carrera FROM carrera ORDER BY nombre_carrera";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();
                fila.put("idCarrera", rs.getString("id_carrera"));
                fila.put("nombreCarrera", rs.getString("nombre_carrera"));
                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println(">>> [GrupoDao] Error al listar carreras: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    /**
     * Grupos existentes con el nombre de su carrera.
     *
     * "etiqueta" viene armada para mostrarse directo en un <option>:
     * por ejemplo "3° B" para el grupo DSM3B.
     */
    public List<Map<String, Object>> listarGrupos() {
        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT g.id_grupo, g.grado, g.letra_grupo, " +
                "       g.carrera_id_carrera, c.nombre_carrera " +
                "FROM grupo g " +
                "INNER JOIN carrera c ON c.id_carrera = g.carrera_id_carrera " +
                "ORDER BY c.nombre_carrera, g.grado, g.letra_grupo";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> fila = new HashMap<>();

                String grado = rs.getString("grado");
                String letra = rs.getString("letra_grupo");

                fila.put("idGrupo", rs.getString("id_grupo"));
                fila.put("grado", grado);
                fila.put("letra", letra);
                fila.put("idCarrera", rs.getString("carrera_id_carrera"));
                fila.put("nombreCarrera", rs.getString("nombre_carrera"));
                fila.put("etiqueta", grado + "° " + letra);

                lista.add(fila);
            }
        } catch (SQLException e) {
            System.err.println(">>> [GrupoDao] Error al listar grupos: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    /** Grupos de una carrera concreta. */
    public List<Map<String, Object>> listarGruposPorCarrera(String idCarrera) {
        if (idCarrera == null || idCarrera.trim().isEmpty()) {
            return listarGrupos();
        }

        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT g.id_grupo, g.grado, g.letra_grupo, " +
                "       g.carrera_id_carrera, c.nombre_carrera " +
                "FROM grupo g " +
                "INNER JOIN carrera c ON c.id_carrera = g.carrera_id_carrera " +
                "WHERE UPPER(TRIM(g.carrera_id_carrera)) = UPPER(TRIM(?)) " +
                "ORDER BY g.grado, g.letra_grupo";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, idCarrera.trim());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> fila = new HashMap<>();

                    String grado = rs.getString("grado");
                    String letra = rs.getString("letra_grupo");

                    fila.put("idGrupo", rs.getString("id_grupo"));
                    fila.put("grado", grado);
                    fila.put("letra", letra);
                    fila.put("idCarrera", rs.getString("carrera_id_carrera"));
                    fila.put("nombreCarrera", rs.getString("nombre_carrera"));
                    fila.put("etiqueta", grado + "° " + letra);

                    lista.add(fila);
                }
            }
        } catch (SQLException e) {
            System.err.println(">>> [GrupoDao] Error al listar grupos por carrera: " + e.getMessage());
            e.printStackTrace();
        }
        return lista;
    }

    public boolean existeGrupo(String idGrupo) {
        if (idGrupo == null || idGrupo.trim().isEmpty()) return false;

        String sql = "SELECT COUNT(*) FROM grupo WHERE UPPER(TRIM(id_grupo)) = UPPER(TRIM(?))";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, idGrupo.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Da de alta un grupo.
     *
     * id_grupo no es autonumérico: se arma con carrera + grado + letra,
     * igual que el 'DSM3D' que ya existe. Así el identificador se lee solo
     * y no hace falta llevar un contador.
     *
     * @return el id generado, o null si no se pudo crear.
     */
    public String crearGrupo(String idCarrera, String grado, String letra) {

        if (idCarrera == null || idCarrera.trim().isEmpty()
                || grado == null || grado.trim().isEmpty()
                || letra == null || letra.trim().isEmpty()) {
            System.err.println(">>> [GrupoDao] Faltan datos para crear el grupo.");
            return null;
        }

        String carreraLimpia = idCarrera.trim().toUpperCase();
        String gradoLimpio = grado.trim();
        String letraLimpia = letra.trim().toUpperCase();

        String idGrupo = carreraLimpia + gradoLimpio + letraLimpia;

        if (existeGrupo(idGrupo)) {
            System.err.println(">>> [GrupoDao] El grupo " + idGrupo + " ya existe.");
            return null;
        }

        String sql = "INSERT INTO grupo (id_grupo, letra_grupo, grado, carrera_id_carrera) " +
                "VALUES (?, ?, ?, ?)";

        Connection con = null;
        try {
            con = SQLConnector.getConnection();
            con.setAutoCommit(false);

            int filas;
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, idGrupo);
                ps.setString(2, letraLimpia);
                ps.setInt(3, Integer.parseInt(gradoLimpio));
                ps.setString(4, carreraLimpia);
                filas = ps.executeUpdate();
            }

            if (filas > 0) {
                con.commit();
                System.out.println(">>> [GrupoDao] Grupo creado: " + idGrupo);
                return idGrupo;
            }

            con.rollback();
            return null;

        } catch (NumberFormatException e) {
            System.err.println(">>> [GrupoDao] El grado debe ser un número: " + grado);
            return null;

        } catch (SQLException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) { }
            }
            System.err.println(">>> [GrupoDao] Error al crear el grupo: " + e.getMessage());
            e.printStackTrace();
            return null;

        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ignored) { }
                try { con.close(); } catch (SQLException ignored) { }
            }
        }
    }
}