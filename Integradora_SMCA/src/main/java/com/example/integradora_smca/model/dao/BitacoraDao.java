package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BitacoraDao {

    // Se agrega el parámetro horaFinal al método
    public boolean registrarEntrada(String alumnoMatricula, String numeroPc, String aula, String horaInicio, String horaFinal) {

        // Se inserta hora_inicio y hora_final
        String sql = "INSERT INTO bitacora (fecha, hora_inicio, hora_final, numero_pc, alumno_matricula, id_laboratorio) " +
                "VALUES (CURRENT_DATE, ?, ?, ?, ?, (SELECT id_laboratorio FROM laboratorio WHERE aula = ? FETCH FIRST 1 ROWS ONLY))";

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, horaInicio != null ? horaInicio.trim() : null);
            ps.setString(2, horaFinal != null ? horaFinal.trim() : null);
            ps.setString(3, numeroPc != null ? numeroPc.trim() : null);
            ps.setString(4, alumnoMatricula != null ? alumnoMatricula.trim() : null);
            ps.setString(5, aula != null ? aula.trim() : null);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}