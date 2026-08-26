package com.example.integradora_smca;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet de prueba para forzar un error 500.
 */
@WebServlet("/error500")
public class Error500 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forzamos una excepción para simular un error interno
        throw new RuntimeException("Error forzado para probar la página 500.jsp");
    }
}
