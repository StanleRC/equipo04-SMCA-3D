package com.example.integradora_smca.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;

/**
 * Entrega las fotos de perfil que ahora viven fuera de target/.
 *
 * Está mapeado en la MISMA ruta que ya usan tus JSP
 * (/assets/img/perfiles/loquesea.png), así que no tienes que cambiar ningún src="".
 *
 * Busca en este orden:
 *   1. la carpeta externa donde EditarPerfilServlet guarda las fotos nuevas
 *   2. assets/img/perfiles del proyecto, para default.png y fotos viejas
 *   3. si no encuentra nada, entrega default.png
 */
@WebServlet("/assets/img/perfiles/*")
public class FotoPerfilServlet extends HttpServlet {

    private static final String POR_DEFECTO = "default.png";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getPathInfo(); // llega como "/perfil_123.png"
        if (nombre != null && nombre.startsWith("/")) {
            nombre = nombre.substring(1);
        }

        // Un nombre con ".." o barras podría leer archivos fuera de la carpeta.
        if (nombre == null || nombre.isEmpty()
                || nombre.contains("..") || nombre.contains("/") || nombre.contains("\\")) {
            nombre = POR_DEFECTO;
        }

        Path archivo = localizar(nombre);

        if (archivo == null) {
            nombre = POR_DEFECTO;
            archivo = localizar(nombre);
        }

        if (archivo == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        response.setContentType(nombre.toLowerCase().endsWith(".png") ? "image/png" : "image/jpeg");
        response.setContentLengthLong(Files.size(archivo));
        response.setHeader("Cache-Control", "public, max-age=86400");

        try (InputStream in = Files.newInputStream(archivo);
             OutputStream out = response.getOutputStream()) {
            in.transferTo(out);
        }
    }

    private Path localizar(String nombre) throws IOException {
        // Misma carpeta que usa EditarPerfilServlet para escribir.
        Path externo = EditarPerfilServlet.carpetaFotos().resolve(nombre);
        if (Files.isRegularFile(externo) && Files.isReadable(externo)) {
            return externo;
        }

        String rutaProyecto = getServletContext().getRealPath("/assets/img/perfiles/" + nombre);
        if (rutaProyecto != null) {
            Path interno = Path.of(rutaProyecto);
            if (Files.isRegularFile(interno) && Files.isReadable(interno)) {
                return interno;
            }
        }

        return null;
    }
}