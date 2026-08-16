package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.Docente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;

@WebServlet("/EditarPerfilServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class EditarPerfilServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. Obtener los parámetros del formulario
        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String correo = request.getParameter("correo");

        // 2. Procesar la foto subida (si existe)
        Part filePart = request.getPart("fotoPerfil");
        String nombreFoto = null;

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String extension = fileName.substring(fileName.lastIndexOf("."));
            nombreFoto = "profile_" + System.currentTimeMillis() + extension;

            // Ruta donde se guardan las fotos en el servidor
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img" + File.separator + "perfiles";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + nombreFoto);
        }

        // 3. Determinar la sesión y la vista de destino
        Object usuarioObj = session.getAttribute("usuarioLogueado");
        if (usuarioObj == null) {
            usuarioObj = session.getAttribute("docente");
        }
        if (usuarioObj == null) {
            usuarioObj = session.getAttribute("alumno");
        }

        String vistaDestino = "/views/admin/perfil_admin-docente.jsp"; // Valor por defecto

        if (usuarioObj instanceof Docente) {
            Docente docente = (Docente) usuarioObj;
            docente.setNombre(nombre);
            docente.setApellidoPaterno(apellidoPaterno);
            docente.setApellidoMaterno(apellidoMaterno);
            docente.setCorreo(correo);

            if (nombreFoto != null) {
                docente.setFotoPerfil(nombreFoto);
            }

            // TODO: Llama aquí a tu DAO de Docente
            // docenteDao.actualizar(docente);

            // Actualizar la sesión
            session.setAttribute("usuarioLogueado", docente);
            session.setAttribute("docente", docente);

            vistaDestino = "/views/admin/perfil_admin-docente.jsp";

        } else if (usuarioObj instanceof Alumno) {
            Alumno alumno = (Alumno) usuarioObj;
            alumno.setNombre(nombre);
            alumno.setApellidoPaterno(apellidoPaterno);
            alumno.setApellidoMaterno(apellidoMaterno);
            alumno.setCorreo(correo);

            if (nombreFoto != null) {
                alumno.setFotoPerfil(nombreFoto);
            }

            // TODO: Llama aquí a tu DAO de Alumno
            // alumnoDao.actualizar(alumno);

            // Actualizar la sesión
            session.setAttribute("usuarioLogueado", alumno);
            session.setAttribute("alumno", alumno);

            // Redirección hacia la vista del alumno
            vistaDestino = "/views/alumno/editar_perfil_alumno.jsp";
        }

        // 4. Redireccionar dinámicamente según la vista que corresponda
        response.sendRedirect(request.getContextPath() + vistaDestino);
    }
}