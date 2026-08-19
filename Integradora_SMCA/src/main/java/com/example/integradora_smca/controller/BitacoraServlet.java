package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.dao.BitacoraDao;
// IMPORTANTE: Asegúrate de importar la clase (DTO/Modelo) que usas para la Bitácora
// import com.example.integradora_smca.model.BitacoraDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/BitacoraServlet")
public class BitacoraServlet extends HttpServlet {

    private BitacoraDao bitacoraDao;

    @Override
    public void init() throws ServletException {
        bitacoraDao = new BitacoraDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Obtener el parámetro del aula seleccionada (Ej: "CC10", "CA1", etc.)
        String aulaSeleccionada = request.getParameter("lab");

        // 2. Consultar la lista de bitácoras filtrada por el aula (o todas si viene nulo)
        // Nota: Asegúrate de que tu DAO devuelva una lista de tu objeto Bitacora (List<BitacoraDTO> o similar)
        List<?> listaBitacora = bitacoraDao.obtenerBitacoraPorAula(aulaSeleccionada);

        // 3. Enviar la lista de datos y el nombre del aula a la vista
        request.setAttribute("listaBitacora", listaBitacora);

        if (aulaSeleccionada == null || aulaSeleccionada.trim().isEmpty()) {
            request.setAttribute("labActual", "Todos");
        } else {
            request.setAttribute("labActual", aulaSeleccionada);
        }

        // 4. Redirigir a tu tabla bitacora.jsp
        // (Ajusta la ruta si tu bitacora.jsp está en otra carpeta, por ejemplo: "/views/admin/bitacora.jsp")
        request.getRequestDispatcher("/views/admin/bitacora.jsp").forward(request, response);
    }
}