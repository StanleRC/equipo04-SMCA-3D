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

class GrupoDaoTest {

    private GrupoDao grupoDao;

    private MockedStatic<SQLConnector> mockedSQLConnector;
    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;

    @BeforeEach
    void setUp() throws SQLException {
        grupoDao = new GrupoDao();

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

    // 1. Prueba de listado de carreras exitoso
    @Test
    void testListarCarrerasExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getString("id_carrera")).thenReturn("DSM");
        when(mockResultSet.getString("nombre_carrera")).thenReturn("Desarrollo de Software Multiplataforma");

        List<Map<String, Object>> resultado = grupoDao.listarCarreras();

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("DSM", resultado.get(0).get("idCarrera"));
        assertEquals("Desarrollo de Software Multiplataforma", resultado.get(0).get("nombreCarrera"));
    }

    // 2. Prueba de listado general de grupos exitoso
    @Test
    void testListarGruposExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getString("id_grupo")).thenReturn("DSM3D");
        when(mockResultSet.getString("grado")).thenReturn("3");
        when(mockResultSet.getString("letra_grupo")).thenReturn("D");
        when(mockResultSet.getString("carrera_id_carrera")).thenReturn("DSM");
        when(mockResultSet.getString("nombre_carrera")).thenReturn("Desarrollo de Software");

        List<Map<String, Object>> resultado = grupoDao.listarGrupos();

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("DSM3D", resultado.get(0).get("idGrupo"));
        assertEquals("3° D", resultado.get(0).get("etiqueta"));
    }

    // 3. Prueba de listado de grupos por carrera específica
    @Test
    void testListarGruposPorCarreraExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true, false);
        when(mockResultSet.getString("id_grupo")).thenReturn("DSM3D");
        when(mockResultSet.getString("grado")).thenReturn("3");
        when(mockResultSet.getString("letra_grupo")).thenReturn("D");
        when(mockResultSet.getString("carrera_id_carrera")).thenReturn("DSM");
        when(mockResultSet.getString("nombre_carrera")).thenReturn("Desarrollo de Software");

        List<Map<String, Object>> resultado = grupoDao.listarGruposPorCarrera("DSM");

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        verify(mockPreparedStatement).setString(1, "DSM");
    }

    // 4. Prueba de listado de grupos por carrera vacía o nula
    @Test
    void testListarGruposPorCarreraVacia() throws SQLException {
        when(mockResultSet.next()).thenReturn(false);

        List<Map<String, Object>> resultado = grupoDao.listarGruposPorCarrera(null);

        assertNotNull(resultado);
        verify(mockPreparedStatement, never()).setString(anyInt(), anyString());
    }

    // 5. Prueba de verificación de existencia de grupo exitosa
    @Test
    void testExisteGrupoExiste() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        boolean resultado = grupoDao.existeGrupo("DSM3D");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, "DSM3D");
    }

    // 6. Prueba de verificación cuando el grupo no existe
    @Test
    void testExisteGrupoNoExiste() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(0);

        boolean resultado = grupoDao.existeGrupo("DSM99X");

        assertFalse(resultado);
    }

    // 7. Prueba de verificación de existencia con ID nulo o vacío
    @Test
    void testExisteGrupoInvalido() {
        assertFalse(grupoDao.existeGrupo(null));
        assertFalse(grupoDao.existeGrupo("   "));
    }

    // 8. Prueba de creación de grupo exitosa
    @Test
    void testCrearGrupoExitoso() throws SQLException {
        // Simular que el grupo no existe previamente
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(0);

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        String idGenerado = grupoDao.crearGrupo("DSM", "3", "D");

        assertNotNull(idGenerado);
        assertEquals("DSM3D", idGenerado);
        verify(mockConnection).commit();
    }

    // 9. Prueba de creación de grupo duplicado
    @Test
    void testCrearGrupoDuplicado() throws SQLException {
        // Simular que el grupo ya existe
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        String idGenerado = grupoDao.crearGrupo("DSM", "3", "D");

        assertNull(idGenerado);
        verify(mockPreparedStatement, never()).executeUpdate();
    }

    // 10. Prueba de creación de grupo con parámetros nulos o vacíos
    @Test
    void testCrearGrupoParametrosVacios() {
        assertNull(grupoDao.crearGrupo(null, "3", "D"));
        assertNull(grupoDao.crearGrupo("DSM", "", "D"));
        assertNull(grupoDao.crearGrupo("DSM", "3", null));
    }

    // 11. Prueba de creación de grupo con grado no numérico
    @Test
    void testCrearGrupoGradoNoNumerico() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(0);

        String idGenerado = grupoDao.crearGrupo("DSM", "tercero", "D");

        assertNull(idGenerado);
    }
}