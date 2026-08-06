package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.mockito.Mockito.*;

public class AlumnoServletTest {

    private AlumnoServlet servlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        servlet = new AlumnoServlet();
    }

    // 1. PRUEBA DE FUNCIONAMIENTO NORMAL
    @Test
    void testDoPostDatosCorrectos() throws Exception {
        Alumno usuario = new Alumno();
        usuario.setNombre("Original");
        usuario.setCorreo("original@test.com");

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("usuario")).thenReturn(usuario);
        when(request.getParameter("nombre")).thenReturn("Juan Perez");
        when(request.getParameter("correo")).thenReturn("juan@test.com");
        when(request.getPart("fotoPerfil")).thenReturn(null);

        servlet.doPost(request, response);

        assertEquals("Juan Perez", usuario.getNombre());
        assertEquals("juan@test.com", usuario.getCorreo());
    }

    // 2. CASO LÍMITE: Intentar romper enviando campos vacíos ("")
    @Test
    void testDoPostCamposVacios() throws Exception {
        Alumno usuario = new Alumno();
        usuario.setNombre("Original");
        usuario.setCorreo("original@test.com");

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("usuario")).thenReturn(usuario);
        when(request.getParameter("nombre")).thenReturn("");
        when(request.getParameter("correo")).thenReturn("");
        when(request.getPart("fotoPerfil")).thenReturn(null);

        servlet.doPost(request, response);

        // Al no haber validaciones en el Servlet, asigna los strings vacíos
        assertEquals("", usuario.getNombre());
        assertEquals("", usuario.getCorreo());
    }

    // 3. CASO LÍMITE: Intentar romper enviando un correo con formato inválido o texto plano
    @Test
    void testDoPostCorreoFormatoInvalido() throws Exception {
        Alumno usuario = new Alumno();

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("usuario")).thenReturn(usuario);
        when(request.getParameter("nombre")).thenReturn("1234567890"); // Números como nombre
        when(request.getParameter("correo")).thenReturn("correo_invalido_sin_arroba"); // Texto sin @
        when(request.getPart("fotoPerfil")).thenReturn(null);

        servlet.doPost(request, response);

        // Se verifica cómo responde el código actual ante datos no válidos
        assertEquals("1234567890", usuario.getNombre());
        assertEquals("correo_invalido_sin_arroba", usuario.getCorreo());
    }

    // 4. CASO LÍMITE: Intentar romper enviando valores nulos
    @Test
    void testDoPostParametrosNull() throws Exception {
        Alumno usuario = new Alumno();

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("usuario")).thenReturn(usuario);
        when(request.getParameter("nombre")).thenReturn(null);
        when(request.getParameter("correo")).thenReturn(null);
        when(request.getPart("fotoPerfil")).thenReturn(null);

        servlet.doPost(request, response);

        assertNull(usuario.getNombre());
        assertNull(usuario.getCorreo());
    }
}