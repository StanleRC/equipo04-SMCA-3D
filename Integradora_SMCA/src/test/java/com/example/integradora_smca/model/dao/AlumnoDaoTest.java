package com.example.integradora_smca.model.dao;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.HistorialAlumnoDto;
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

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class AlumnoDaoTest {

    private AlumnoDao alumnoDao;

    private MockedStatic<SQLConnector> sqlConnectorMockedStatic;
    private Connection connectionMock;
    private PreparedStatement preparedStatementMock;
    private ResultSet resultSetMock;

    @BeforeEach
    void setUp() throws SQLException {
        alumnoDao = new AlumnoDao();

        // Mocks de los objetos JDBC
        connectionMock = mock(Connection.class);
        preparedStatementMock = mock(PreparedStatement.class);
        resultSetMock = mock(ResultSet.class);

        // Interceptamos la llamada estática SQLConnector.getConnection()
        sqlConnectorMockedStatic = mockStatic(SQLConnector.class);
        sqlConnectorMockedStatic.when(SQLConnector::getConnection).thenReturn(connectionMock);

        // Configuración por defecto para las consultas SQL
        when(connectionMock.prepareStatement(anyString())).thenReturn(preparedStatementMock);
        when(preparedStatementMock.executeQuery()).thenReturn(resultSetMock);
    }

    @AfterEach
    void tearDown() {
        // Liberamos el mock estático al terminar cada test
        sqlConnectorMockedStatic.close();
    }

    // 1. Prueba de creación exitosa de un Alumno
    @Test
    void testCreateExitoso() throws SQLException {
        Alumno alumno = new Alumno();
        alumno.setMatricula("2026001");
        alumno.setNombre("Carlos");
        alumno.setApellidos("Pérez");
        alumno.setCorreo("carlos@utez.edu.mx");
        alumno.setHashPassword("secret123");
        alumno.setGrupoIdGrupo("1A");
        alumno.setRolIdRol(1);
        alumno.setFotoPerfil("perfil.png");

        when(preparedStatementMock.executeUpdate()).thenReturn(1);

        boolean resultado = alumnoDao.create(alumno);

        assertTrue(resultado);
        verify(preparedStatementMock, times(1)).executeUpdate();
    }

    // 2. Prueba de consulta de todos los alumnos (getAll)
    @Test
    void testGetAllExitoso() throws SQLException {
        when(resultSetMock.next()).thenReturn(true, false);
        when(resultSetMock.getString("matricula")).thenReturn("2026001");
        when(resultSetMock.getString("nombre")).thenReturn("Carlos");
        when(resultSetMock.getString("apellidos")).thenReturn("Pérez");
        when(resultSetMock.getString("correo")).thenReturn("carlos@utez.edu.mx");
        when(resultSetMock.getString("hash_password")).thenReturn("secret123");
        when(resultSetMock.getString("grupo_id_grupo")).thenReturn("1A");
        when(resultSetMock.getInt("rol_id_rol")).thenReturn(1);
        when(resultSetMock.getString("foto_perfil")).thenReturn("perfil.png");

        List<Alumno> lista = alumnoDao.getAll();

        assertNotNull(lista);
        assertEquals(1, lista.size());
        assertEquals("2026001", lista.get(0).getMatricula());
    }

    // 3. Prueba de consulta por ID/Matrícula (getById)
    @Test
    void testGetByIdEncontrado() throws SQLException {
        when(resultSetMock.next()).thenReturn(true);
        when(resultSetMock.getString("matricula")).thenReturn("2026001");
        when(resultSetMock.getString("nombre")).thenReturn("Carlos");
        when(resultSetMock.getString("apellidos")).thenReturn("Pérez");
        when(resultSetMock.getString("correo")).thenReturn("carlos@utez.edu.mx");
        when(resultSetMock.getString("hash_password")).thenReturn("secret123");
        when(resultSetMock.getString("grupo_id_grupo")).thenReturn("1A");
        when(resultSetMock.getInt("rol_id_rol")).thenReturn(1);
        when(resultSetMock.getString("foto_perfil")).thenReturn("perfil.png");

        Alumno alumno = alumnoDao.getById("2026001");

        assertNotNull(alumno);
        assertEquals("Carlos", alumno.getNombre());
        verify(preparedStatementMock, times(1)).setString(1, "2026001");
    }

    // 4. Prueba de Login exitoso
    @Test
    void testLoginExitoso() throws SQLException {
        when(resultSetMock.next()).thenReturn(true);
        when(resultSetMock.getString("matricula")).thenReturn("2026001");
        when(resultSetMock.getString("nombre")).thenReturn("Carlos");
        when(resultSetMock.getString("apellidos")).thenReturn("Pérez");
        when(resultSetMock.getString("correo")).thenReturn("carlos@utez.edu.mx");
        when(resultSetMock.getString("grupo_id_grupo")).thenReturn("1A");
        when(resultSetMock.getInt("rol_id_rol")).thenReturn(1);
        when(resultSetMock.getString("foto_perfil")).thenReturn("perfil.png");

        Alumno alumno = alumnoDao.login("2026001", "secret123");

        assertNotNull(alumno);
        assertEquals("2026001", alumno.getMatricula());
        verify(preparedStatementMock, times(1)).setString(1, "2026001");
        verify(preparedStatementMock, times(1)).setString(2, "secret123");
    }

    // 5. Prueba de actualización exitosa (update)
    @Test
    void testUpdateExitoso() throws SQLException {
        Alumno alumno = new Alumno();
        alumno.setNombre("Carlos");
        alumno.setApellidos("Pérez Updated");
        alumno.setCorreo("carlos_upd@utez.edu.mx");
        alumno.setFotoPerfil("perfil2.png");
        alumno.setMatricula("2026001");

        when(preparedStatementMock.executeUpdate()).thenReturn(1);

        boolean resultado = alumnoDao.update(alumno);

        assertTrue(resultado);
        verify(preparedStatementMock, times(1)).executeUpdate();
    }

    // 6. Prueba de eliminación (delete)
    @Test
    void testDeleteExitoso() throws SQLException {
        when(preparedStatementMock.executeUpdate()).thenReturn(1);

        boolean resultado = alumnoDao.delete("2026001");

        assertTrue(resultado);
        verify(preparedStatementMock, times(1)).setString(1, "2026001");
    }

    // 7. Prueba de consulta de perfil completo (getPerfilCompletoByMatricula)
    @Test
    void testGetPerfilCompletoByMatriculaExitoso() throws SQLException {
        when(resultSetMock.next()).thenReturn(true);
        when(resultSetMock.getString("matricula")).thenReturn("2026001");
        when(resultSetMock.getString("nombre")).thenReturn("Carlos");
        when(resultSetMock.getString("apellidos")).thenReturn("Pérez");
        when(resultSetMock.getString("correo")).thenReturn("carlos@utez.edu.mx");
        when(resultSetMock.getString("foto_perfil")).thenReturn("perfil.png");
        when(resultSetMock.getString("id_grupo")).thenReturn("1A");

        Alumno alumno = alumnoDao.getPerfilCompletoByMatricula("2026001");

        assertNotNull(alumno);
        assertEquals("2026001", alumno.getMatricula());
        assertEquals("1A", alumno.getGrupoIdGrupo());
    }

    // 8. Prueba de consulta de historial (getHistorialByMatricula)
    @Test
    void testGetHistorialByMatriculaExitoso() throws SQLException {
        when(resultSetMock.next()).thenReturn(true, false);
        when(resultSetMock.getString("grado")).thenReturn("1");
        when(resultSetMock.getString("numero_grupo")).thenReturn("A");
        when(resultSetMock.getString("numero_pc")).thenReturn("PC-05");
        when(resultSetMock.getString("matricula")).thenReturn("2026001");
        when(resultSetMock.getString("nombre_completo")).thenReturn("Carlos Pérez");
        when(resultSetMock.getString("fecha_formateada")).thenReturn("06/08/2026");
        when(resultSetMock.getString("incidencia")).thenReturn("Ninguna");
        when(resultSetMock.getString("estado")).thenReturn("Activo");

        List<HistorialAlumnoDto> historial = alumnoDao.getHistorialByMatricula("2026001");

        assertNotNull(historial);
        assertEquals(1, historial.size());
        assertEquals("PC-05", historial.get(0).getNumeroPc());
    }
}