package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Administrador;
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
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class AdministradorDaoTest {

    private AdministradorDao administradorDao;

    private MockedStatic<SQLConnector> mockedSQLConnector;
    private Connection mockConnection;
    private PreparedStatement mockPreparedStatement;
    private ResultSet mockResultSet;

    @BeforeEach
    void setUp() throws SQLException {
        administradorDao = new AdministradorDao();

        mockConnection = mock(Connection.class);
        mockPreparedStatement = mock(PreparedStatement.class);
        mockResultSet = mock(ResultSet.class);

        mockedSQLConnector = mockStatic(SQLConnector.class);
        mockedSQLConnector.when(SQLConnector::getConnection).thenReturn(mockConnection);

        when(mockConnection.isClosed()).thenReturn(false);
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
    }

    @AfterEach
    void tearDown() {
        mockedSQLConnector.close();
    }

    // 1. Prueba de verificación de existencia de correo exitoso
    @Test
    void testExisteCorreoExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        boolean resultado = administradorDao.existeCorreo("admin@test.com");

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(1, "admin@test.com");
    }

    // 2. Prueba de verificación cuando el correo no existe
    @Test
    void testExisteCorreoNoExiste() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(0);

        boolean resultado = administradorDao.existeCorreo("noexiste@test.com");

        assertFalse(resultado);
    }

    // 3. Prueba de verificación de correo nulo o vacío
    @Test
    void testExisteCorreoNuloOVacio() {
        assertFalse(administradorDao.existeCorreo(null));
        assertFalse(administradorDao.existeCorreo("   "));
    }

    // 4. Prueba de Login exitoso
    @Test
    void testLoginExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("id_administrador")).thenReturn("ADM01");
        when(mockResultSet.getString("nombre")).thenReturn("Admin");
        when(mockResultSet.getString("apellido_paterno")).thenReturn("García");
        when(mockResultSet.getString("apellido_materno")).thenReturn("López");
        when(mockResultSet.getString("correo")).thenReturn("admin@test.com");
        when(mockResultSet.getInt("rol_id_rol")).thenReturn(1);
        when(mockResultSet.getString("foto_perfil")).thenReturn("foto.png");
        when(mockResultSet.getString("hash_password")).thenReturn("123456");

        Administrador admin = administradorDao.loginByCorreo("admin@test.com", "123456");

        assertNotNull(admin);
        assertEquals("ADM01", admin.getIdAdministrador());
        assertEquals("Admin", admin.getNombre());
    }

    // 5. Prueba de Login fallido por contraseña incorrecta
    @Test
    void testLoginContrasenaIncorrecta() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("hash_password")).thenReturn("password_correcta");

        Administrador admin = administradorDao.loginByCorreo("admin@test.com", "password_incorrecta");

        assertNull(admin);
    }

    // 6. Prueba de búsqueda por ID exitosa
    @Test
    void testGetByIdExitoso() throws SQLException {
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("id_administrador")).thenReturn("ADM01");
        when(mockResultSet.getString("nombre")).thenReturn("Carlos");

        Administrador admin = administradorDao.getById("ADM01");

        assertNotNull(admin);
        assertEquals("ADM01", admin.getIdAdministrador());
        assertEquals("Carlos", admin.getNombre());
    }

    // 7. Prueba de búsqueda por ID nulo
    @Test
    void testGetByIdNulo() {
        assertNull(administradorDao.getById(null));
    }

    // 8. Prueba de actualización de perfil exitosa con foto
    @Test
    void testActualizarPerfilConFoto() throws SQLException {
        Administrador admin = new Administrador();
        admin.setIdAdministrador("ADM01");
        admin.setNombre("Carlos");
        admin.setApellidoPaterno("Pérez");
        admin.setApellidoMaterno("Ramírez");
        admin.setCorreo("carlos@test.com");
        admin.setFotoPerfil("perfil.jpg");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = administradorDao.actualizarPerfil(admin);

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(5, "perfil.jpg");
        verify(mockPreparedStatement).setString(6, "ADM01");
    }

    // 9. Prueba de actualización de perfil exitosa sin foto
    @Test
    void testActualizarPerfilSinFoto() throws SQLException {
        Administrador admin = new Administrador();
        admin.setIdAdministrador("ADM01");
        admin.setNombre("Carlos");
        admin.setApellidoPaterno("Pérez");
        admin.setApellidoMaterno("Ramírez");
        admin.setCorreo("carlos@test.com");
        admin.setFotoPerfil(null);

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = administradorDao.actualizarPerfil(admin);

        assertTrue(resultado);
        verify(mockPreparedStatement).setString(5, "ADM01");
    }

    // 10. prueba de actualización de perfil fallida por objeto nulo
    @Test
    void testActualizarPerfilNulo() {
        assertFalse(administradorDao.actualizarPerfil(null));
    }

    // 11. prueba de actualización de contraseña por correo exitosa
    @Test
    void testActualizarPasswordPorCorreoExitoso() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        boolean resultado = administradorDao.actualizarPasswordPorCorreo("admin@test.com", "nuevaPassword123");

        assertTrue(resultado);
        verify(mockConnection).commit();
    }

    // 12. Prueba de actualización de contraseña por correo fallida
    @Test
    void testActualizarPasswordPorCorreoFallido() throws SQLException {
        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        boolean resultado = administradorDao.actualizarPasswordPorCorreo("noexiste@test.com", "nuevaPassword123");

        assertFalse(resultado);
        verify(mockConnection).rollback();
    }
}