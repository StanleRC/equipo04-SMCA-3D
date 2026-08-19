package com.example.integradora_smca.controller;

import com.example.integradora_smca.model.UsuarioPersonal;
import com.example.integradora_smca.model.dao.IncidenciaDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import com.example.integradora_smca.utils.NotificadorIncidencias;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet(name = "ValidarIncidenciasServlet", value = "/ValidarIncidenciasServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class ValidarIncidenciasServlet extends HttpServlet {

    private final IncidenciaDao incidenciaDao = new IncidenciaDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String labParam = request.getParameter("lab");
        labParam = (labParam == null || labParam.trim().isEmpty()) ? "CC2" : labParam.trim();

        List<Map<String, Object>> listaIncidencias =
                "Todos".equalsIgnoreCase(labParam)
                        ? incidenciaDao.listarIncidencias()
                        : incidenciaDao.listarIncidenciasPorLaboratorio(labParam);

        request.setAttribute("listaIncidencias", listaIncidencias);
        request.setAttribute("labActual", labParam);

        request.getRequestDispatcher("/views/admin/validar_incidencia.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String labParam = request.getParameter("lab");
        String redirectLab = (labParam != null && !labParam.trim().isEmpty())
                ? "&lab=" + labParam.trim() : "";

        String idReporteStr = request.getParameter("idReporte");
        if (idReporteStr == null || idReporteStr.trim().isEmpty()) {
            idReporteStr = request.getParameter("idIncidencia");
        }

        String accion = request.getParameter("accion");

        if (idReporteStr == null || idReporteStr.trim().isEmpty() || accion == null) {
            redirigir(request, response, "error", redirectLab);
            return;
        }

        int idReporte;
        try {
            idReporte = Integer.parseInt(idReporteStr.trim());
        } catch (NumberFormatException e) {
            redirigir(request, response, "error", redirectLab);
            return;
        }

        /*
         * Los datos del reporte se leen ANTES de actualizarlo: se necesitan para
         * armar el correo, y después de marcarlo como revisado ya no aparece
         * en el listado de pendientes.
         */
        Map<String, Object> reporte = incidenciaDao.obtenerReportePorId(idReporte);
        if (reporte == null) {
            redirigir(request, response, "error", redirectLab);
            return;
        }

        // Foto opcional. Si falla el guardado, la validación sigue adelante.
        File evidencia = guardarEvidencia(request, idReporte);
        if (evidencia != null) {
            incidenciaDao.guardarFotoEvidencia(idReporte, evidencia.getName());
        }

        boolean exito = incidenciaDao.procesarRevisionAdmin(idReporte, accion);

        if (!exito) {
            redirigir(request, response, "error", redirectLab);
            return;
        }

        String decision = "validar".equalsIgnoreCase(accion.trim()) ? "Validado" : "Descartado";

        /*
         * El correo se manda DESPUÉS del commit y su resultado no cambia el flujo:
         * si el SMTP está caído, la incidencia ya quedó revisada de todos modos.
         */
        boolean correoEnviado = NotificadorIncidencias.avisarIncidenciaRevisada(
                reporte, nombreDeQuienValida(session), decision, evidencia);

        redirigir(request, response, correoEnviado ? "ok" : "ok_sin_correo", redirectLab);
    }

    /** Carpeta de evidencias, fuera de target/ para que sobreviva a los redeploy. */
    static Path carpetaEvidencias() throws IOException {
        String base = System.getProperty("catalina.base");
        if (base == null || base.trim().isEmpty()) {
            base = System.getProperty("user.home") + File.separator + "bitacora";
        }
        Path dir = Paths.get(base, "uploads", "evidencias").toAbsolutePath().normalize();
        Files.createDirectories(dir);
        return dir;
    }

    /** Devuelve el archivo guardado, o null si no se subió foto o no es válida. */
    private File guardarEvidencia(HttpServletRequest request, int idReporte) {
        try {
            Part parte = request.getPart("fotoEvidencia");

            if (parte == null || parte.getSize() == 0) {
                return null;
            }

            String extension = extensionValida(parte.getSubmittedFileName());
            if (extension == null) {
                log("[ValidarIncidencias] Archivo rechazado, no es PNG ni JPG.");
                return null;
            }

            // El nombre lo genera el servidor: el del usuario podría traer "../".
            String nombre = "evidencia_" + idReporte + "_" + System.currentTimeMillis() + "." + extension;
            Path destino = carpetaEvidencias().resolve(nombre);

            try (InputStream in = parte.getInputStream()) {
                Files.copy(in, destino, StandardCopyOption.REPLACE_EXISTING);
            }

            return destino.toFile();

        } catch (IOException | ServletException | IllegalStateException e) {
            log("[ValidarIncidencias] No se pudo guardar la evidencia: " + e.getMessage());
            return null;
        }
    }

    private String extensionValida(String nombreArchivo) {
        if (nombreArchivo == null) return null;

        String limpio = nombreArchivo.replace('\\', '/');
        int barra = limpio.lastIndexOf('/');
        if (barra >= 0) limpio = limpio.substring(barra + 1);

        int punto = limpio.lastIndexOf('.');
        if (punto < 0 || punto == limpio.length() - 1) return null;

        String ext = limpio.substring(punto + 1).toLowerCase(Locale.ROOT);
        return (ext.equals("png") || ext.equals("jpg") || ext.equals("jpeg")) ? ext : null;
    }

    private String nombreDeQuienValida(HttpSession session) {
        Object usuario = session.getAttribute("usuarioLogueado");
        if (usuario == null) usuario = session.getAttribute("docente");
        if (usuario == null) usuario = session.getAttribute("administrador");

        if (usuario instanceof UsuarioPersonal) {
            return ((UsuarioPersonal) usuario).getNombreCompleto();
        }

        Object nombre = session.getAttribute("nombreUsuario");
        return nombre != null ? nombre.toString() : "Un usuario del sistema";
    }

    private void redirigir(HttpServletRequest request, HttpServletResponse response,
                           String msj, String redirectLab) throws IOException {
        response.sendRedirect(request.getContextPath()
                + "/ValidarIncidenciasServlet?msj=" + msj + redirectLab);
    }
}