package com.example.integradora_smca.model.dao;

// IMPORTANTE: Asegúrate de importar aquí tu modelo/clase de la entidad Bitacora
import com.example.integradora_smca.model.Bitacora;
import com.example.integradora_smca.utils.SQLConnector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BitacoraDao {

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

    // =================================================================================
    // MÉTODO 2: OBTENER LOS REGISTROS DE LA BITÁCORA FILTRADOS POR AULA (PARA LA TABLA)
    // =================================================================================
    public List<Bitacora> obtenerBitacoraPorAula(String aula) {
        List<Bitacora> lista = new ArrayList<>();

        // Consulta base: Hacemos un JOIN con alumno y laboratorio
        StringBuilder sql = new StringBuilder(
                "SELECT b.id_bitacora, a.nombre, a.apellido_paterno, a.apellido_materno, " +
                        "b.alumno_matricula, l.aula, b.numero_pc, b.fecha, b.hora_inicio, b.hora_final " +
                        "FROM bitacora b " +
                        "INNER JOIN alumno a ON b.alumno_matricula = a.matricula " +
                        "INNER JOIN laboratorio l ON b.id_laboratorio = l.id_laboratorio "
        );

        // Si se recibe un aula específica, le agregamos el filtro WHERE
        if (aula != null && !aula.trim().isEmpty()) {
            sql.append("WHERE l.aula = ? ");
        }

        // Ordenamos para que los registros más recientes salgan primero
        sql.append("ORDER BY b.fecha DESC, b.hora_inicio DESC");

        try (Connection con = SQLConnector.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            // Si hay un filtro de aula, pasamos el parámetro
            if (aula != null && !aula.trim().isEmpty()) {
                ps.setString(1, aula);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bitacora registro = new Bitacora();

                    registro.setIdBitacora(rs.getInt("id_bitacora"));

                    // Concatenamos el nombre del alumno para mostrarlo bonito en la tabla
                    String nombreCompleto = rs.getString("nombre") + " " +
                            rs.getString("apellido_paterno") + " " +
                            rs.getString("apellido_materno");
                    registro.setNombreCompleto(nombreCompleto);

                    registro.setMatricula(rs.getString("alumno_matricula"));
                    registro.setSalon(rs.getString("aula"));
                    registro.setNumeroPc(rs.getString("numero_pc"));

                    // Si tus campos de fecha y hora son String, se dejan así.
                    // Si en tu modelo son Date o Time, cambia rs.getString por rs.getDate o rs.getTime
                    registro.setFecha(rs.getString("fecha"));
                    registro.setHoraInicio(rs.getString("hora_inicio"));
                    registro.setHoraFinal(rs.getString("hora_final"));

                    lista.add(registro);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al consultar la bitácora por aula: " + e.getMessage());
            e.printStackTrace();
        }

        return lista;
    }
}