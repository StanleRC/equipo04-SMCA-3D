package com.example.integradora_smca.model;

/**
 * Clase Docente
 * @Autor: Stanle Reyes
 * @Fecha: 25/08/2026
 * @Funcionalidad: Representa la entidad Docente dentro del sistema.
 * Contiene atributos de identificación, credenciales y perfil.
 * Implementa la interfaz UsuarioPersonal para garantizar consistencia en la
 * gestión de usuarios del sistema.
 */
public class Docente implements UsuarioPersonal {

    private Integer idDocente;       // Identificador único del docente
    private String nombre;           // Nombre del docente
    private String apellidoPaterno;  // Apellido paterno
    private String apellidoMaterno;  // Apellido materno
    private String correo;           // Correo electrónico
    private String hashPassword;     // Contraseña en formato hash
    private int rolIdRol;            // Rol asignado (ej. docente, coordinador)
    private String fotoPerfil;       // Foto de perfil

    /**
     * Método exigido por UsuarioPersonal
     * @return identificador único del docente como texto
     */
    @Override
    public String getIdentificador() {
        return String.valueOf(idDocente);
    }

    /**
     * Constructor vacío
     * Permite crear un objeto Docente sin inicializar atributos.
     */
    public Docente() {
    }

    /**
     * Constructor completo
     * @param idDocente identificador único del docente
     * @param nombre nombre del docente
     * @param apellidoPaterno apellido paterno
     * @param apellidoMaterno apellido materno
     * @param correo correo electrónico
     * @param hashPassword contraseña en formato hash
     * @param rolIdRol rol asignado al docente
     * @param fotoPerfil foto de perfil del docente
     */
    public Docente(Integer idDocente, String nombre, String apellidoPaterno, String apellidoMaterno,
                   String correo, String hashPassword, int rolIdRol, String fotoPerfil) {
        this.idDocente = idDocente;
        this.nombre = nombre;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
        this.correo = correo;
        this.hashPassword = hashPassword;
        this.rolIdRol = rolIdRol;
        this.fotoPerfil = fotoPerfil;
    }

    /**
     * @return identificador único del docente
     */
    public Integer getIdDocente() {
        return idDocente;
    }

    /**
     * @param idDocente establece el identificador del docente
     */
    public void setIdDocente(Integer idDocente) {
        this.idDocente = idDocente;
    }

    /**
     * @return nombre del docente
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre establece el nombre del docente
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return apellido paterno del docente
     */
    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    /**
     * @param apellidoPaterno establece el apellido paterno
     */
    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }

    /**
     * @return apellido materno del docente
     */
    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    /**
     * @param apellidoMaterno establece el apellido materno
     */
    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
    }

    /**
     * @return correo electrónico del docente
     */
    public String getCorreo() {
        return correo;
    }

    /**
     * @param correo establece el correo electrónico
     */
    public void setCorreo(String correo) {
        this.correo = correo;
    }

    /**
     * @return contraseña en formato hash
     */
    public String getHashPassword() {
        return hashPassword;
    }

    /**
     * @param hashPassword establece la contraseña en formato hash
     */
    public void setHashPassword(String hashPassword) {
        this.hashPassword = hashPassword;
    }

    /**
     * @return rol asignado al docente
     */
    public int getRolIdRol() {
        return rolIdRol;
    }

    /**
     * @param rolIdRol establece el rol del docente
     */
    public void setRolIdRol(int rolIdRol) {
        this.rolIdRol = rolIdRol;
    }

    /**
     * @return foto de perfil del docente
     */
    public String getFotoPerfil() {
        return fotoPerfil;
    }

    /**
     * @param fotoPerfil establece la foto de perfil
     */
    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }
}
