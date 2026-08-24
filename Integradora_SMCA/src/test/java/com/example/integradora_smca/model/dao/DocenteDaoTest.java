package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.utils.SQLConnector;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockedStatic;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class DocenteDaoTest {

    private DocenteDao docenteDao;

    private MockedStatic<SQLConnector> mockedSQLConnector;
    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;

    @BeforeEach
    void setUp() throws SQLException {
        docenteDao = new DocenteDao();

        mockConnection = mock(Connection.class);
        mockPreparedStatement = mock(PreparedStatement.class);
        mockResultSet = mock(ResultSet.class);

        mockedSQLConnector = mockStatic(SQLConnector.class);
        mockedSQLConnector.when(SQLConnector::getConnection).thenReturn(mockConnection);

        when(mockConnection.isClosed()).thenReturn(false);
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockConnection.prepareStatement(anyString(), any(String[].class))).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockPreparedStatement.getGeneratedKeys()).thenReturn(mockResultSet);
    }

    @AfterEach
    void tearDown() {
        mockedSQLConnector.close();
    }

    // 1. Prueba de verificación de existencia de docente por correo exitosa
    @Test
    void testExisteDocenteExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        boolean resultado = docenteDao.existeDocente("docente@test.com");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, "docente@test.com");
    }

    // 2. Prueba de verificación cuando el correo de docente no existe
    @Test
    void testExisteDocenteNoExiste() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(0);

        boolean resultado = docenteDao.existeDocente("noexiste@test.com");

        assertFalse(resultado);
    }

    // 3. Prueba de verificación con correo nulo
    @Test
    void testExisteDocenteCorreoNulo() {
        assertFalse(docenteDao.existeDocente(null));
    }

    // 4. Prueba de Login por correo exitoso
    @Test
    void testLoginByCorreoExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("id_docente")).thenReturn(1);
        when(mockResultSet.getString("nombre")).thenReturn("Roberto");
        when(mockResultSet.getString("apellido_paterno")).thenReturn("Gómez");
        when(mockResultSet.getString("apellido_materno")).thenReturn("Bolaños");
        when(mockResultSet.getString("correo")).thenReturn("roberto@test.com");
        when(mockResultSet.getInt("rol_id_rol")).thenReturn(2);
        when(mockResultSet.getString("foto_perfil")).thenReturn("docente.png");
        when(mockResultSet.getString("hash_password")).thenReturn("123456");

        Docente docente = docenteDao.loginByCorreo("roberto@test.com", "123456");

        assertNotNull(docente);
        assertEquals(1, docente.getIdDocente());
        assertEquals("Roberto", docente.getNombre());
    }

    // 5. Prueba de Login por correo fallido por contraseña incorrecta
    @Test
    void testLoginByCorreoContrasenaIncorrecta() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("hash_password")).thenReturn("password_correcta");

        Docente docente = docenteDao.loginByCorreo("roberto@test.com", "incorrecta");

        assertNull(docente);
    }

    // 6. Prueba de Login general por ID o Correo exitoso
    @Test
    void testLoginExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt("id_docente")).thenReturn(5);
        when(mockResultSet.getString("nombre")).thenReturn("Ana");
        when(mockResultSet.getString("hash_password")).thenReturn("123456");

        Docente docente = docenteDao.login("5", "123456");

        assertNotNull(docente);
        assertEquals(5, docente.getIdDocente());
        verify(mockPreparedStatement).setString(1, "5");
        verify(mockPreparedStatement).setString(2, "5");
    }

    // 7. Prueba de actualización de perfil de docente exitosa con foto
    @Test
    void testActualizarPerfilConFoto() throws SQLException {
        Docente d = new Docente();
        d.setIdDocente(1);
        d.setNombre("Roberto");
        d.setApellidoPaterno("Gómez");
        d.setApellidoMaterno("Bolaños");
        d.setCorreo("roberto@test.com");
        d.setFotoPerfil("nueva_foto.png");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = docenteDao.actualizarPerfil(d);

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(5, "nueva_foto.png");
        verify(mockPreparedStatement).setInt(6, 1);
    }

    // 8. Prueba de actualización de perfil sin foto
    @Test
    void testActualizarPerfilSinFoto() throws SQLException {
        Docente d = new Docente();
        d.setIdDocente(1);
        d.setNombre("Roberto");
        d.setApellidoPaterno("Gómez");
        d.setApellidoMaterno("Bolaños");
        d.setCorreo("roberto@test.com");
        d.setFotoPerfil(null);

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = docenteDao.actualizarPerfil(d);

        assertTrue(resultado);
        verify(mockPreparedStatement).setInt(5, 1);
    }

    // 9. Prueba de actualización de perfil fallida con objeto nulo o ID inválido
    @Test
    void testActualizarPerfilInvalido() {
        assertFalse(docenteDao.actualizarPerfil(null));

        Docente d = new Docente();
        d.setIdDocente(0);
        assertFalse(docenteDao.actualizarPerfil(d));
    }

    // 10. Prueba de actualización de contraseña por correo exitosa
    @Test
    void testActualizarPasswordPorCorreoExitoso() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = docenteDao.actualizarPasswordPorCorreo("roberto@test.com", "nuevaPassword123");

        assertTrue(resultado);
        verify(mockConnection).commit();
    }

    // 11. Prueba de actualización de contraseña por correo fallida
    @Test
    void testActualizarPasswordPorCorreoFallido() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        boolean resultado = docenteDao.actualizarPasswordPorCorreo("noexiste@test.com", "nuevaPassword123");

        assertFalse(resultado);
        verify(mockConnection).rollback();
    }
}