package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Grupo;
import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GrupoDao {

    // Obtener todos los grupos registrados por el Administrador
    public List<Grupo> getAll() {
        List<Grupo> lista = new ArrayList<>();
        String sql = "SELECT id_grupo, numero_grupo, grado, carrera_id_carrera FROM grupo";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Grupo g = new Grupo();
                g.setIdGrupo(rs.getString("id_grupo"));
                g.setNumeroGrupo(rs.getInt("numero_grupo"));
                g.setGrado(rs.getInt("grado"));
                g.setCarreraIdCarrera(rs.getString("carrera_id_carrera"));
                lista.add(g);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // Verificar si existe un grupo específico
    public boolean exists(String idGrupo) {
        String sql = "SELECT 1 FROM grupo WHERE id_grupo = ?";
        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, idGrupo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}