package com.example.integradora_smca.model;

/**
 * Contrato común del personal que inicia sesión en el panel administrativo.
 *
 * ¿Por qué existe?
 * DOCENTE y ADMINISTRADOR son dos tablas separadas, pero para el sistema son
 * el mismo tipo de usuario: tienen nombre, correo, foto y rol. Sin esta interfaz,
 * cada servlet y cada filtro tendría que preguntar "¿eres Docente o Administrador?"
 * con instanceof, y bastaría olvidar un caso para provocar un ClassCastException.
 *
 * Con la interfaz, el código pide lo que necesita (getNombre, isAdministrador)
 * sin importarle de qué tabla salió el objeto.
 *
 * En los JSP funciona igual: ${perfil.nombre} o ${perfil.administrador} leen
 * estos getters sin saber la clase concreta.
 */
public interface UsuarioPersonal {

    /** Valores de la tabla ROL, en el orden en que fueron insertados. */
    int ROL_ADMINISTRADOR = 1;
    int ROL_DOCENTE = 2;
    int ROL_ALUMNO = 3;

    /**
     * Llave primaria como texto.
     * En la base ambas son VARCHAR2(30): id_docente e id_administrador.
     */
    String getIdentificador();

    String getNombre();

    String getApellidoPaterno();

    String getApellidoMaterno();

    String getCorreo();

    String getFotoPerfil();

    int getRolIdRol();

    /**
     * Único lugar del proyecto donde se decide qué significa "ser administrador".
     * Si algún día cambia el número de rol, se cambia aquí y nada más.
     *
     * En JSP se usa como ${perfil.administrador}.
     */
    default boolean isAdministrador() {
        return getRolIdRol() == ROL_ADMINISTRADOR;
    }

    /** Nombre completo, para saludos y encabezados. */
    default String getNombreCompleto() {
        return ((getNombre() == null ? "" : getNombre()) + " "
                + (getApellidoPaterno() == null ? "" : getApellidoPaterno()) + " "
                + (getApellidoMaterno() == null ? "" : getApellidoMaterno())).trim();
    }

    /** Etiqueta legible del rol, para el sidebar. */
    default String getRolTexto() {
        return isAdministrador() ? "Administrador" : "Docente";
    }
}