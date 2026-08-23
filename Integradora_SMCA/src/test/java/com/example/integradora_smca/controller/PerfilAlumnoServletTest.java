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

public class PerfilAlumnoServletTest {

    private PerfilAlumnoServlet servlet;

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
        servlet = new PerfilAlumnoServlet();


        Field field = PerfilAlumnoServlet.class.getDeclaredField("alumnoDao");
        field.setAccessible(true);
        field.set(servlet, alumnoDaoMock);
    }

    @Test
    void testDoGetUsuarioAutenticadoExito() throws Exception {
        Alumno usuarioLogueado = new Alumno();
        usuarioLogueado.setMatricula("2026001");

        Alumno alumnoActualizado = new Alumno();
        alumnoActualizado.setMatricula("2026001");
        alumnoActualizado.setFotoPerfil("/uploads/perfil.png");

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(usuarioLogueado);
        when(alumnoDaoMock.getById("2026001")).thenReturn(alumnoActualizado);
        when(request.getRequestDispatcher("/views/alumno/perfil_alumno.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(session, times(1)).setAttribute("usuarioLogueado", alumnoActualizado);
        verify(session, times(1)).setAttribute("usuarioFoto", "/uploads/perfil.png");
        verify(request, times(1)).getRequestDispatcher("/views/alumno/perfil_alumno.jsp");
        verify(dispatcher, times(1)).forward(request, response);
    }

    @Test
    void testDoGetSesionNulaRedirigeAIndex() throws Exception {
        when(request.getSession(false)).thenReturn(null);
        when(request.getContextPath()).thenReturn("/app");

        servlet.doGet(request, response);

        verify(response, times(1)).sendRedirect("/app/index.jsp");
        verifyNoInteractions(alumnoDaoMock);
    }

    @Test
    void testDoGetAlumnoNoEncontradoEnDbRedirigeAIndex() throws Exception {
        Alumno usuarioLogueado = new Alumno();
        usuarioLogueado.setMatricula("2026999");

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(usuarioLogueado);
        when(alumnoDaoMock.getById("2026999")).thenReturn(null); // Devuelve null
        when(request.getContextPath()).thenReturn("/app");

        servlet.doGet(request, response);

        verify(alumnoDaoMock, times(1)).getById("2026999");
        verify(response, times(1)).sendRedirect("/app/index.jsp");
    }
}