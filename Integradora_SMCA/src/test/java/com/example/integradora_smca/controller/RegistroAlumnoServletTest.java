package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.*;

public class RegistroAlumnoServletTest {

    private RegistroAlumnoServlet servlet;

    @Mock
    private AlumnoDao alumnoDaoMock;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);

        // Sobrescribimos la creación del DAO interno para usar nuestro mock
        servlet = new RegistroAlumnoServlet() {
            @Override
            public void init() {
                // Evitamos la inicialización real del DAO
            }
        };

        // Inyectamos el mock directamente por reflexión simple
        java.lang.reflect.Field field = RegistroAlumnoServlet.class.getDeclaredField("alumnoDao");
        field.setAccessible(true);
        field.set(servlet, alumnoDaoMock);
    }

    // 1. Redirección básica a la vista vía GET
    @Test
    void testDoGetRedirigeAFormulario() throws Exception {
        when(request.getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(request, times(1)).getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp");
        verify(dispatcher, times(1)).forward(request, response);
    }

    // 2. ERROR: Las contraseñas no coinciden
    @Test
    void testDoPostContrasenasNoCoinciden() throws Exception {
        when(request.getParameter("txtPassword")).thenReturn("123456");
        when(request.getParameter("txtConfirmPassword")).thenReturn("654321");
        when(request.getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request, times(1)).setCharacterEncoding("UTF-8");
        verify(request, times(1)).setAttribute("errorMessage", "Las contraseñas no coinciden.");
        verify(dispatcher, times(1)).forward(request, response);
    }

    // 3. FLUJO NORMAL: Registro exitoso
    @Test
    void testDoPostRegistroExitoso() throws Exception {
        when(request.getParameter("txtNombre")).thenReturn("Juan");
        when(request.getParameter("txtApellidoPaterno")).thenReturn("Pérez");
        when(request.getParameter("txtApellidoMaterno")).thenReturn("Gómez");
        when(request.getParameter("txtMatricula")).thenReturn("2026001");
        when(request.getParameter("txtPassword")).thenReturn("123456");
        when(request.getParameter("txtConfirmPassword")).thenReturn("123456");
        when(request.getParameter("txtCorreo")).thenReturn("juan@utez.edu.mx");
        when(request.getParameter("grupo")).thenReturn("1A");

        when(alumnoDaoMock.create(any(Alumno.class))).thenReturn(true);
        when(request.getContextPath()).thenReturn("/app");

        servlet.doPost(request, response);

        verify(alumnoDaoMock, times(1)).create(any(Alumno.class));
        verify(response, times(1)).sendRedirect("/app/index.jsp?registro=exito");
    }

    // 4. ERROR EN DB: Matrícula/Correo duplicado o fallo al guardar
    @Test
    void testDoPostRegistroFallido() throws Exception {
        when(request.getParameter("txtNombre")).thenReturn("Juan");
        when(request.getParameter("txtApellidoPaterno")).thenReturn("Pérez");
        when(request.getParameter("txtApellidoMaterno")).thenReturn("Gómez");
        when(request.getParameter("txtMatricula")).thenReturn("2026001");
        when(request.getParameter("txtPassword")).thenReturn("123456");
        when(request.getParameter("txtConfirmPassword")).thenReturn("123456");
        when(request.getParameter("txtCorreo")).thenReturn("juan@utez.edu.mx");
        when(request.getParameter("grupo")).thenReturn("1A");

        when(alumnoDaoMock.create(any(Alumno.class))).thenReturn(false);
        when(request.getRequestDispatcher("/views/alumno/registro_directo_alumno.jsp")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(alumnoDaoMock, times(1)).create(any(Alumno.class));
        verify(request, times(1)).setAttribute("errorMessage", "Error al registrar. Verifica la matrícula o correo duplicado.");
        verify(dispatcher, times(1)).forward(request, response);
    }
}