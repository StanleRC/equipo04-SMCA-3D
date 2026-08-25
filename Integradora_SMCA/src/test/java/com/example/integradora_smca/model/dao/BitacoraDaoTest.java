package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.utils.SQLConnector;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class BitacoraDaoTest {

    private BitacoraDao bitacoraDao;

    private MockedStatic<SQLConnector> mockedSQLConnector;
    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;

    @BeforeEach
    void setUp() throws SQLException {
        bitacoraDao = new BitacoraDao();

        mockConnection = mock(Connection.class);
        mockPreparedStatement = mock(PreparedStatement.class);
        mockResultSet = mock(ResultSet.class);

        mockedSQLConnector = mockStatic(SQLConnector.class);
        mockedSQLConnector.when(SQLConnector::getConnection).thenReturn(mockConnection);

        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
    }

    @AfterEach
    void tearDown() {
        mockedSQLConnector.close();
    }

    // 1. Prueba de obtención de bitácora por aula específica
    @Test
    void testObtenerBitacoraPorAulaExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("id_bitacora")).thenReturn(1);
        when(mockResultSet.getString("aula")).thenReturn("CC10");
        when(mockResultSet.getString("edificio")).thenReturn("E1");
        when(mockResultSet.getString("numero_pc")).thenReturn("PC-05");
        when(mockResultSet.getString("matricula")).thenReturn("20253DS111");
        when(mockResultSet.getString("nombre_completo")).thenReturn("Judith Aguilar");
        when(mockResultSet.getString("grado")).thenReturn("2");
        when(mockResultSet.getString("grupo")).thenReturn("D");
        when(mockResultSet.getString("fecha")).thenReturn("23/08/2026");
        when(mockResultSet.getString("hora_inicio")).thenReturn("10:00");
        when(mockResultSet.getString("hora_final")).thenReturn("12:00");
        when(mockResultSet.getString("descripcion")).thenReturn("Sin problemas");
        when(mockResultSet.getString("estado")).thenReturn("Sin reporte");
        when(mockResultSet.getInt("id_reporte")).thenReturn(0);
        when(mockResultSet.wasNull()).thenReturn(true);

        List<Map<String, Object>> resultado = bitacoraDao.obtenerBitacoraPorAula("CC10");

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("CC10", resultado.get(0).get("salon"));
        verify(mockPreparedStatement).setString(1, "CC10");
    }

    // 2. Prueba de obtención de bitácora seleccionando 'Todos' o valor nulo
    @Test
    void testObtenerBitacoraPorAulaTodos() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("id_bitacora")).thenReturn(2);

        List<Map<String, Object>> resultado = bitacoraDao.obtenerBitacoraPorAula("Todos");

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        verify(mockPreparedStatement, never()).setString(anyInt(), anyString());
    }

    // 3. Prueba de listar toda la bitácora
    @Test
    void testListarBitacora() throws SQLException {
        when(mockResultSet.next()).thenReturn(false);

        List<Map<String, Object>> resultado = bitacoraDao.listarBitacora();

        assertNotNull(resultado);
        assertTrue(resultado.isEmpty());
    }

    // 4. Prueba de listar sesiones abiertas por aula
    @Test
    void testListarSesionesAbiertasConAula() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("id_bitacora")).thenReturn(3);
        when(mockResultSet.getString("hora_final")).thenReturn(null);

        List<Map<String, Object>> resultado = bitacoraDao.listarSesionesAbiertas("CC10");

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        verify(mockPreparedStatement).setString(1, "CC10");
    }

    // 5. Prueba de listar laboratorios disponibles
    @Test
    void testListarLaboratoriosExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("id_laboratorio")).thenReturn(101);
        when(mockResultSet.getString("aula")).thenReturn("CC10");
        when(mockResultSet.getString("edificio")).thenReturn("E1");
        when(mockResultSet.getString("nombre_lab")).thenReturn("Laboratorio Cómputo");

        List<Map<String, Object>> resultado = bitacoraDao.listarLaboratorios();

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("Laboratorio Cómputo", resultado.get(0).get("nombreLab"));
    }

    // 6. Prueba de registro de entrada exitoso
    @Test
    void testRegistrarEntradaExitoso() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = bitacoraDao.registrarEntrada("20253DS111", "05", "CC10");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, "05");
        verify(mockPreparedStatement).setString(2, "20253DS111");
        verify(mockPreparedStatement).setString(3, "CC10");
        verify(mockConnection).commit();
    }

    // 7. Prueba de registro de entrada fallido por falta de parámetros
    @Test
    void testRegistrarEntradaParametrosInvalidos() {
        assertFalse(bitacoraDao.registrarEntrada(null, "05", "CC10"));
        assertFalse(bitacoraDao.registrarEntrada("20253DS111", "05", "  "));
    }

    // 8. Prueba de cierre de sesión en bitácora exitoso
    @Test
    void testCerrarSesionBitacoraExitoso() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = bitacoraDao.cerrarSesionBitacora("20253DS111");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, "20253DS111");
        verify(mockConnection).commit();
    }

    // 9. Prueba de cierre de sesión en bitácora fallido por matrícula nula
    @Test
    void testCerrarSesionBitacoraMatriculaNula() {
        assertFalse(bitacoraDao.cerrarSesionBitacora(null));
        assertFalse(bitacoraDao.cerrarSesionBitacora("   "));
    }

    // 10. Prueba de manejo de excepciones SQL al registrar entrada
    @Test
    void testRegistrarEntradaExcepcionSql() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenThrow(new SQLException("Error simulado"));

        boolean resultado = bitacoraDao.registrarEntrada("20253DS111", "05", "CC10");

        assertFalse(resultado);
        verify(mockConnection).rollback();
    }
}