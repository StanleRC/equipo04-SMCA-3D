package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.HistorialAlumnoDto;
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
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.mockito.Mockito.*;

public class HistorialAlumnoServletTest {

    private HistorialAlumnoServlet servlet;

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
        servlet = new HistorialAlumnoServlet();

        // Inyección por reflexión
        Field field = HistorialAlumnoServlet.class.getDeclaredField("alumnoDao");
        field.setAccessible(true);
        field.set(servlet, alumnoDaoMock);
    }


    @Test
    void testDoGetUsuarioAutenticadoConHistorial() throws Exception {
        Alumno alumno = new Alumno();
        alumno.setMatricula("20261234");

        List<HistorialAlumnoDto> historialEsperado = new ArrayList<>();
        historialEsperado.add(new HistorialAlumnoDto());

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(alumno);
        when(alumnoDaoMock.getHistorialByMatricula("20261234")).thenReturn(historialEsperado);
        when(request.getContextPath()).thenReturn("");
        when(request.getRequestDispatcher("/views/alumno/historial_alumno.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(request, times(1)).setAttribute("listaHistorial", historialEsperado);
        verify(request, times(1)).getRequestDispatcher("/views/alumno/historial_alumno.jsp");
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
    void testDoGetUsuarioNoLogueadoRedirigeAIndex() throws Exception {
        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(null);
        when(request.getContextPath()).thenReturn("/app");

        servlet.doGet(request, response);

        verify(response, times(1)).sendRedirect("/app/index.jsp");
        verifyNoInteractions(alumnoDaoMock);
    }


    @Test
    void testDoGetMatriculaNula() throws Exception {
        Alumno alumno = new Alumno();
        alumno.setMatricula(null);

        when(request.getSession(false)).thenReturn(session);
        when(session.getAttribute("usuarioLogueado")).thenReturn(alumno);
        when(alumnoDaoMock.getHistorialByMatricula(null)).thenReturn(Collections.emptyList());
        when(request.getRequestDispatcher("/views/alumno/historial_alumno.jsp")).thenReturn(dispatcher);

        servlet.doGet(request, response);

        verify(alumnoDaoMock, times(1)).getHistorialByMatricula(null);
        verify(request, times(1)).setAttribute("listaHistorial", Collections.emptyList());
        verify(dispatcher, times(1)).forward(request, response);
    }
}