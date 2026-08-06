package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.lang.reflect.Field;

import static org.mockito.Mockito.*;

public class LoginServletTest {

    private LoginServlet servlet;

    @Mock
    private AlumnoDao alumnoDaoMock;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        servlet = new LoginServlet();


        Field field = LoginServlet.class.getDeclaredField("alumnoDao");
        field.setAccessible(true);
        field.set(servlet, alumnoDaoMock);
    }


    @Test
    void testDoGetRedirigeAIndex() throws Exception {
        when(request.getContextPath()).thenReturn("/app");

        servlet.doGet(request, response);

        verify(response, times(1)).sendRedirect("/app/index.jsp");
    }


    @Test
    void testDoPostLoginExitoso() throws Exception {
        Alumno alumnoValido = new Alumno();
        alumnoValido.setMatricula("2026001");

        when(request.getParameter("matricula")).thenReturn("2026001");
        when(request.getParameter("password")).thenReturn("123456");
        when(alumnoDaoMock.login("2026001", "123456")).thenReturn(alumnoValido);
        when(request.getSession()).thenReturn(session);
        when(request.getContextPath()).thenReturn("/app");

        servlet.doPost(request, response);

        verify(request, times(1)).setCharacterEncoding("UTF-8");
        verify(session, times(1)).setAttribute("usuarioLogueado", alumnoValido);
        verify(session, times(1)).setAttribute("rol", "Alumno");
        verify(response, times(1)).sendRedirect("/app/views/alumno/crear_incidencia_alumno.jsp");
    }


    @Test
    void testDoPostLoginFallido() throws Exception {
        when(request.getParameter("matricula")).thenReturn("2026001");
        when(request.getParameter("password")).thenReturn("clave_incorrecta");
        when(alumnoDaoMock.login("2026001", "clave_incorrecta")).thenReturn(null);
        when(request.getRequestDispatcher("/index.jsp")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request, times(1)).setAttribute("errorMessage", "Matrícula o contraseña incorrectas.");
        verify(dispatcher, times(1)).forward(request, response);
    }


    @Test
    void testDoPostCamposVacios() throws Exception {
        when(request.getParameter("matricula")).thenReturn("   ");
        when(request.getParameter("password")).thenReturn("");
        when(request.getRequestDispatcher("/index.jsp")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request, times(1)).setAttribute("errorMessage", "Por favor, completa todos los campos.");
        verify(dispatcher, times(1)).forward(request, response);
        verifyNoInteractions(alumnoDaoMock);
    }
}