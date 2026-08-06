package com.example.integradora_smca.controller;

import com.example.integradora_smca.utils.EmailSender;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.MockitoAnnotations;

import static org.mockito.Mockito.*;

public class RecuperarPassServletTest {

    private RecuperarPassServlet servlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private RequestDispatcher dispatcher;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        servlet = new RecuperarPassServlet();
    }

    @Test
    void testDoPostCorreoValidoEnvioExitoso() throws Exception {
        when(request.getParameter("correo")).thenReturn("alumno@utez.edu.mx");
        when(request.getRequestDispatcher("index.jsp")).thenReturn(dispatcher);

        try (MockedStatic<EmailSender> emailSenderMock = mockStatic(EmailSender.class)) {
            emailSenderMock.when(() -> EmailSender.sendMail(anyString(), anyString(), anyString())).thenAnswer(i -> null);

            servlet.doPost(request, response);

            verify(request, times(1)).setCharacterEncoding("UTF-8");
            verify(request, times(1)).setAttribute(
                    eq("mensajeExito"),
                    eq("Se han enviado las instrucciones a tu correo electrónico.")
            );
            verify(dispatcher, times(1)).forward(request, response);
            emailSenderMock.verify(() -> EmailSender.sendMail(eq("alumno@utez.edu.mx"), anyString(), anyString()), times(1));
        }
    }

    @Test
    void testDoPostCorreoValidoFalloEnvio() throws Exception {
        when(request.getParameter("correo")).thenReturn("alumno@utez.edu.mx");
        when(request.getRequestDispatcher("index.jsp")).thenReturn(dispatcher);

        try (MockedStatic<EmailSender> emailSenderMock = mockStatic(EmailSender.class)) {
            emailSenderMock.when(() -> EmailSender.sendMail(anyString(), anyString(), anyString()))
                    .thenThrow(new RuntimeException("Error SMTP"));

            servlet.doPost(request, response);

            verify(request, times(1)).setAttribute(
                    eq("mensajeError"),
                    eq("Error al enviar el correo. Intenta de nuevo más tarde.")
            );
            verify(dispatcher, times(1)).forward(request, response);
        }
    }

    @Test
    void testDoPostCorreoVacio() throws Exception {
        when(request.getParameter("correo")).thenReturn("   ");
        when(request.getRequestDispatcher("index.jsp")).thenReturn(dispatcher);

        servlet.doPost(request, response);

        verify(request, times(1)).setAttribute(
                eq("mensajeError"),
                eq("Ingresa un correo electrónico válido.")
        );
        verify(dispatcher, times(1)).forward(request, response);
    }
}
