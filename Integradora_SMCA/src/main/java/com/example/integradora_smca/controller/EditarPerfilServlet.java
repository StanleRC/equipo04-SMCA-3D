package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/EditarPerfilServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1,  // 1 MB
        maxFileSize = 1024 * 1024 * 2,       // 2 MB
        maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class EditarPerfilServlet extends HttpServlet {

    private AlumnoDao alumnoDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Alumno usuarioLogueado = (session != null) ? (Alumno) session.getAttribute("usuarioLogueado") : null;

        if (usuarioLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Obtener datos del formulario
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");

        // Procesar la foto de perfil recibida en el formulario
        Part filePart = request.getPart("fotoPerfil");
        String nombreFoto = usuarioLogueado.getFotoPerfil(); // Retener foto actual por defecto

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String extension = "";

            int i = fileName.lastIndexOf('.');
            if (i > 0) {
                extension = fileName.substring(i);
            }

            // Generar nombre único para evitar duplicados
            nombreFoto = UUID.randomUUID().toString() + extension;

            // Ruta de almacenamiento en el servidor
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img" + File.separator + "perfiles";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + nombreFoto);
        }

        // Actualizar datos del objeto
        usuarioLogueado.setNombre(nombre);
        usuarioLogueado.setCorreo(correo);
        usuarioLogueado.setFotoPerfil(nombreFoto);

        // Guardar cambios en la BD
        boolean actualizado = alumnoDao.update(usuarioLogueado);

        if (actualizado) {
            // Actualizar el objeto almacenado en la sesión
            session.setAttribute("usuarioLogueado", usuarioLogueado);
            response.sendRedirect(request.getContextPath() + "/views/alumno/perfil_alumno.jsp?msj=exito");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/alumno/editar_perfil_alumno.jsp?msj=error");
        }
    }
}