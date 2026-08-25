package com.example.integradora_smca.model;

/**
 * Interfaz UsuarioPersonal
 * @Autor: Stanle Reyes
 * @Fecha: 25/08/2026
 * @Funcionalidad: Define el contrato común para el personal que inicia sesión
 * en el panel administrativo. Permite unificar el acceso a atributos y métodos
 * de Docente y Administrador, evitando duplicación de lógica en servlets y JSP.
 * Proporciona métodos para obtener datos personales, rol y utilidades como
 * nombre completo y verificación de administrador.
 */
public interface UsuarioPersonal {

    // Constantes de roles según la tabla ROL
    int ROL_ADMINISTRADOR = 1;
    int ROL_DOCENTE = 2;
    int ROL_ALUMNO = 3;

    /**
     * @return llave primaria como texto (id_docente o id_administrador)
     */
    String getIdentificador();

    /**
     * @return nombre del usuario
     */
    String getNombre();

    /**
     * @return apellido paterno del usuario
     */
    String getApellidoPaterno();

    /**
     * @return apellido materno del usuario
     */
    String getApellidoMaterno();

    /**
     * @return correo electrónico del usuario
     */
    String getCorreo();

    /**
     * @return foto de perfil del usuario
     */
    String getFotoPerfil();

    /**
     * @return identificador del rol asignado
     */
    int getRolIdRol();

    /**
     * Determina si el usuario es administrador.
     * @return true si el rol corresponde a administrador
     */
    default boolean isAdministrador() {
        return getRolIdRol() == ROL_ADMINISTRADOR;
    }

    /**
     * @return nombre completo del usuario (nombre + apellidos)
     */
    default String getNombreCompleto() {
        return ((getNombre() == null ? "" : getNombre()) + " "
                + (getApellidoPaterno() == null ? "" : getApellidoPaterno()) + " "
                + (getApellidoMaterno() == null ? "" : getApellidoMaterno())).trim();
    }

    /**
     * @return etiqueta legible del rol (Administrador o Docente)
     */
    default String getRolTexto() {
        return isAdministrador() ? "Administrador" : "Docente";
    }
}
