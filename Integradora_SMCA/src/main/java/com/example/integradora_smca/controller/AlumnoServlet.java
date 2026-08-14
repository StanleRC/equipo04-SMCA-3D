package com.example.integradora_smca.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.dao.AlumnoDao;

import java.io.File;
import java.io.IOException;

@WebServlet(name = "alumnoServlet", value = "/actualizar_perfil_servlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 5,        // 5 MB
        maxRequestSize = 1024 * 1024 * 10     // 10 MB
)
public class AlumnoServlet extends HttpServlet {

    private final AlumnoDao alumnoDao = new AlumnoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Alumno usuario = (Alumno) session.getAttribute("usuario");

        if (usuario != null) {
            String nombre = request.getParameter("nombre");
            String correo = request.getParameter("correo");

            // Subida de imagen
            Part filePart = request.getPart("fotoPerfil");
            String fileName = filePart != null ? filePart.getSubmittedFileName() : null;
            String fotoRuta = usuario.getFotoPerfil(); // Conservar foto previa si no sube nueva

            if (fileName != null && !fileName.isEmpty()) {
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                filePart.write(uploadPath + File.separator + uniqueFileName);
                fotoRuta = "assets/img/" + uniqueFileName;
            }

            usuario.setNombre(nombre);
            usuario.setCorreo(correo);
            usuario.setFotoPerfil(fotoRuta);

            alumnoDao.update(usuario);

            session.setAttribute("usuario", usuario);
        }

        // Redirección con patrón PRG
        response.sendRedirect("views/alumno/perfil_alumno.jsp");
    }
}