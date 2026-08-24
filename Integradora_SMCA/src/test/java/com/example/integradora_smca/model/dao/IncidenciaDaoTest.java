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

class IncidenciaDaoTest {

    private IncidenciaDao incidenciaDao;

    private MockedStatic<SQLConnector> mockedSQLConnector;
    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;

    @BeforeEach
    void setUp() throws SQLException {
        incidenciaDao = new IncidenciaDao();

        mockConnection = mock(Connection.class);
        mockPreparedStatement = mock(PreparedStatement.class);
        mockResultSet = mock(ResultSet.class);

        mockedSQLConnector = mockStatic(SQLConnector.class);
        mockedSQLConnector.when(SQLConnector::getConnection).thenReturn(mockConnection);

        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockConnection.prepareStatement(anyString(), any(String[].class))).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockPreparedStatement.getGeneratedKeys()).thenReturn(mockResultSet);
    }

    @AfterEach
    void tearDown() {
        mockedSQLConnector.close();
    }

    // 1. Prueba de guardado de incidencia por alumno exitoso
    @Test
    void testGuardarIncidenciaAlumnoExitoso() throws SQLException {
        // Simular consulta de ID de laboratorio
        when(mockResultSet.next()).thenReturn(true, true);
        when(mockResultSet.getInt("id_laboratorio")).thenReturn(10);

        // Simular generación de ID de Bitácora
        when(mockResultSet.getLong(1)).thenReturn(50L);
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = incidenciaDao.guardarIncidenciaAlumno(
                "Pantalla parpadea", "Alta", "05", "CC10", "20253DS111", null
        );

        assertTrue(resultado);
        verify(mockConnection).commit();
    }

    // 2. Prueba de guardado de incidencia cuando no existe el laboratorio
    @Test
    void testGuardarIncidenciaAlumnoLaboratorioNoEncontrado() throws SQLException {
        when(mockResultSet.next()).thenReturn(false);

        boolean resultado = incidenciaDao.guardarIncidenciaAlumno(
                "Falla", "Media", "01", "AULA_INEXISTENTE", "20253DS111", null
        );

        assertFalse(resultado);
        verify(mockConnection).rollback();
    }

    // 3. Prueba de revisión por administrador (Validar)
    @Test
    void testProcesarRevisionAdminValidar() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = incidenciaDao.procesarRevisionAdmin(100, "validar");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, IncidenciaDao.ESTADO_VALIDADO);
        verify(mockPreparedStatement).setInt(2, 100);
        verify(mockPreparedStatement).setString(3, IncidenciaDao.ESTADO_PENDIENTE);
        verify(mockConnection).commit();
    }

    // 4. Prueba de revisión por administrador (Descartar)
    @Test
    void testProcesarRevisionAdminDescartar() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = incidenciaDao.procesarRevisionAdmin(100, "descartar");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, IncidenciaDao.ESTADO_DESCARTADO);
    }

    // 5. Prueba de revisión con acción inválida o ID erróneo
    @Test
    void testProcesarRevisionAdminAccionInvalida() {
        assertFalse(incidenciaDao.procesarRevisionAdmin(100, "accion_desconocida"));
        assertFalse(incidenciaDao.procesarRevisionAdmin(0, "validar"));
    }

    // 6. Prueba de guardado de foto de evidencia exitoso
    @Test
    void testGuardarFotoEvidenciaExitoso() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = incidenciaDao.guardarFotoEvidencia(100, "evidencia1.jpg");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, "evidencia1.jpg");
        verify(mockPreparedStatement).setInt(2, 100);
    }

    // 7. Prueba de guardado de foto de evidencia con nombre nulo o vacío
    @Test
    void testGuardarFotoEvidenciaNombreInvalido() {
        assertFalse(incidenciaDao.guardarFotoEvidencia(100, null));
        assertFalse(incidenciaDao.guardarFotoEvidencia(100, "   "));
    }

    // 8. Prueba de filtrado de incidencias por laboratorio (por Aula "CC10")
    @Test
    void testListarIncidenciasPorLaboratorioPorAula() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("id_reporte")).thenReturn(1);
        when(mockResultSet.getString("aula")).thenReturn("CC10");

        List<Map<String, Object>> resultado = incidenciaDao.listarIncidenciasPorLaboratorio("CC10");

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        verify(mockPreparedStatement).setString(1, "CC10");
    }

    // 9. Prueba de filtrado de incidencias por laboratorio (por ID numérico "10")
    @Test
    void testListarIncidenciasPorLaboratorioPorId() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("id_reporte")).thenReturn(2);

        List<Map<String, Object>> resultado = incidenciaDao.listarIncidenciasPorLaboratorio("10");

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        verify(mockPreparedStatement).setInt(1, 10);
    }

    // 10. Prueba de obtención de reporte por ID de reporte
    @Test
    void testObtenerReportePorIdExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("id_reporte")).thenReturn(100);
        when(mockResultSet.getString("descripcion")).thenReturn("Mouse roto");
        when(mockResultSet.getString("aula")).thenReturn("CC10");

        Map<String, Object> resultado = incidenciaDao.obtenerReportePorId(100);

        assertNotNull(resultado);
        assertEquals(100, resultado.get("idReporte"));
        assertEquals("Mouse roto", resultado.get("incidencia"));
        verify(mockPreparedStatement).setInt(1, 100);
    }

    // 11. Prueba de listado de laboratorios
    @Test
    void testListarLaboratoriosExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getInt("id_laboratorio")).thenReturn(1);
        when(mockResultSet.getString("aula")).thenReturn("CC10");
        when(mockResultSet.getString("edificio")).thenReturn("E1");
        when(mockResultSet.getString("nombre_lab")).thenReturn("Laboratorio Cómputo");

        List<Map<String, Object>> resultado = incidenciaDao.listarLaboratorios();

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("CC10", resultado.get(0).get("aula"));
    }
}