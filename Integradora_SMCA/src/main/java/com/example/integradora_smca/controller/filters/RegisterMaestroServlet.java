package com.example.integradora_smca.controller.filters;

import com.example.integradora_smca.model.dao.DocenteDao;
import com.example.integradora_smca.model.dao.Docente;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterMaestroServlet")
public class RegisterMaestroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DocenteDao docenteDao;

    @Override
    public void init() throws ServletException {
        this.docenteDao = new DocenteDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register/registrar_maestro.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Captura los inputs basándose en el parámetro 'name' de tu formulario JSP
        String nombre = request.getParameter("nombre");
        String apellidoPaterno = request.getParameter("apellidoPaterno");
        String apellidoMaterno = request.getParameter("apellidoMaterno");
        String correo = request.getParameter("correo");
        String pass = request.getParameter("pass");
        String confirmPass = request.getParameter("confirmPass");
        String telefono = request.getParameter("telefono");

        // Validaciones del servidor secundarias
        if (nombre == null || nombre.trim().isEmpty() ||
                apellidoPaterno == null || apellidoPaterno.trim().isEmpty() ||
                correo == null || correo.trim().isEmpty() ||
                pass == null || pass.trim().isEmpty()) {

            request.setAttribute("error", "Faltan datos obligatorios para el registro.");
            request.getRequestDispatcher("/register/registrar_maestro.jsp").forward(request, response);
            return;
        }

        if (!pass.equals(confirmPass)) {
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("/register/registrar_maestro.jsp").forward(request, response);
            return;
        }

        // Crear instancia usando tu modelo Docente
        Docente nuevoDocente = new Docente(correo, nombre, apellidoPaterno, apellidoMaterno, pass, telefono);

        // Intentar guardar en la Base de Datos Oracle
        boolean guardado = docenteDao.registrarDocente(nuevoDocente);

        if (guardado) {
            // Éxito: va hacia tu página de bitácora
            response.sendRedirect(request.getContextPath() + "/bitacora.jsp?status=success");
        } else {
            // Error: regresa notificando el fallo
            request.setAttribute("error", "Error al guardar el registro. Comprueba si el correo ya está registrado.");
            request.getRequestDispatcher("/register/registrar_maestro.jsp").forward(request, response);
        }
    }
}