package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.Alumno;
import com.example.integradora_smca.model.Docente;
import com.example.integradora_smca.model.dao.AlumnoDao;
import com.example.integradora_smca.model.dao.DocenteDao;

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
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Locale;

@WebServlet("/EditarPerfilServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class EditarPerfilServlet extends HttpServlet {

    private AlumnoDao alumnoDao;
    private DocenteDao docenteDao;

    @Override
    public void init() throws ServletException {
        alumnoDao = new AlumnoDao();
        docenteDao = new DocenteDao();
    }

    /**
     * Carpeta donde viven las fotos.
     *
     * IMPORTANTE: no se usa getRealPath(), que apunta dentro de target/. IntelliJ borra
     * esa carpeta en cada Run, y por eso las fotos desaparecían aunque el nombre siguiera
     * guardado en la base de datos. Esta ruta está fuera del proyecto, así que persiste.
     */
    static Path carpetaFotos() throws IOException {
        String base = System.getProperty("catalina.base");
        if (base == null || base.trim().isEmpty()) {
            base = System.getProperty("user.home") + File.separator + "bitacora";
        }
        Path dir = Paths.get(base, "uploads", "perfiles").toAbsolutePath().normalize();
        Files.createDirectories(dir);
        return dir;
    }

    /** Devuelve la extensión solo si es una imagen aceptada; null en cualquier otro caso. */
    static String extensionValida(String nombreArchivo) {
        if (nombreArchivo == null) return null;

        // Algunos navegadores mandan la ruta completa, no solo el nombre.
        String limpio = nombreArchivo.replace('\\', '/');
        int barra = limpio.lastIndexOf('/');
        if (barra >= 0) limpio = limpio.substring(barra + 1);

        int punto = limpio.lastIndexOf('.');
        // Esta comprobación faltaba: sin ella, un archivo sin punto reventaba con
        // StringIndexOutOfBoundsException en fileName.substring(...).
        if (punto < 0 || punto == limpio.length() - 1) return null;

        String ext = limpio.substring(punto + 1).toLowerCase(Locale.ROOT);
        return (ext.equals("png") || ext.equals("jpg") || ext.equals("jpeg")) ? ext : null;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        Object usuarioObj = null;
        if (session != null) {
            usuarioObj = session.getAttribute("usuarioLogueado");
            if (usuarioObj == null) usuarioObj = session.getAttribute("docente");
            if (usuarioObj == null) usuarioObj = session.getAttribute("alumno");
        }

        if (usuarioObj == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String nombre = limpiar(request.getParameter("nombre"));
        String apellidoPaterno = limpiar(request.getParameter("apellidoPaterno"));
        String apellidoMaterno = limpiar(request.getParameter("apellidoMaterno"));
        String correo = limpiar(request.getParameter("correo")).toLowerCase();

        // 1. Guardar la foto nueva, si el usuario subió una
        String nombreFoto = guardarFoto(request);

        // 2. Escribir en la base de datos Y actualizar la sesión
        String vistaDestino;
        boolean guardado;

        if (usuarioObj instanceof Docente) {
            Docente docente = (Docente) usuarioObj;
            docente.setNombre(nombre);
            docente.setApellidoPaterno(apellidoPaterno);
            docente.setApellidoMaterno(apellidoMaterno);
            docente.setCorreo(correo);
            if (nombreFoto != null) {
                docente.setFotoPerfil(nombreFoto);
            }

            // Esto es lo que faltaba: sin esta línea nada llegaba a la base de datos.
            guardado = docenteDao.actualizarPerfil(docente);

            session.setAttribute("usuarioLogueado", docente);
            session.setAttribute("docente", docente);
            vistaDestino = "/views/admin/perfil_admin-docente.jsp";

        } else {
            Alumno alumno = (Alumno) usuarioObj;
            alumno.setNombre(nombre);
            alumno.setApellidoPaterno(apellidoPaterno);
            alumno.setApellidoMaterno(apellidoMaterno);
            alumno.setCorreo(correo);
            if (nombreFoto != null) {
                alumno.setFotoPerfil(nombreFoto);
            }

            // update() ya actualiza nombre, apellidos, correo y foto_perfil por matrícula.
            guardado = alumnoDao.update(alumno);

            session.setAttribute("usuarioLogueado", alumno);
            session.setAttribute("alumno", alumno);
            vistaDestino = "/views/alumno/editar_perfil_alumno.jsp";
        }

        if (!guardado) {
            // Suele pasar si el correo ya pertenece a otra persona (restricción UNIQUE).
            log("[EditarPerfil] La base de datos rechazó los cambios de: " + correo);
        }

        response.sendRedirect(request.getContextPath() + vistaDestino
                + (guardado ? "?guardado=1" : "?guardado=0"));
    }

    /** Devuelve el nombre del archivo guardado, o null si no se subió foto o no es válida. */
    private String guardarFoto(HttpServletRequest request) throws IOException, ServletException {

        Part filePart;
        try {
            filePart = request.getPart("fotoPerfil");
        } catch (IllegalStateException e) {
            log("[EditarPerfil] La imagen supera el tamaño permitido.");
            return null;
        }

        if (filePart == null || filePart.getSize() == 0) {
            return null; // no subió nada: se conserva la foto actual
        }

        String extension = extensionValida(filePart.getSubmittedFileName());
        if (extension == null) {
            log("[EditarPerfil] Archivo rechazado, no es PNG ni JPG.");
            return null;
        }

        // El nombre lo genera el servidor. Reutilizar el del usuario permitiría
        // rutas como "../../algo.png" y escribir fuera de la carpeta prevista.
        String nombreFoto = "perfil_" + System.currentTimeMillis() + "." + extension;
        Path destino = carpetaFotos().resolve(nombreFoto);

        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, destino, StandardCopyOption.REPLACE_EXISTING);
        }

        return nombreFoto;
    }

    private String limpiar(String valor) {
        return valor == null ? "" : valor.trim();
    }
}