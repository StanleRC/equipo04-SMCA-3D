package com.example.integradora_smca.model;

/**
 * Clase Administrador
 * @Autor: Luis Uriel
 * @Fecha: 25/08/2026
 * @Funcionalidad: Representa la entidad Administrador dentro del sistema.
 * Contiene atributos de identificación, credenciales y perfil.
 * Implementa la interfaz UsuarioPersonal para garantizar consistencia en la
 * gestión de usuarios del sistema.
 */
public class Administrador implements UsuarioPersonal {

    private String idAdministrador;   // Identificador único del administrador
    private String nombre;            // Nombre del administrador
    private String apellidoPaterno;   // Apellido paterno
    private String apellidoMaterno;   // Apellido materno
    private String correo;            // Correo electrónico
    private String hashPassword;      // Contraseña en formato hash
    private int rolIdRol;             // Rol asignado (ej. administrador, superadmin)
    private String fotoPerfil;        // Foto de perfil

    /**
     * Constructor vacío
     * Permite crear un objeto Administrador sin inicializar atributos.
     */
    public Administrador() {
    }

    /**
     * Método exigido por UsuarioPersonal
     * @return identificador único del administrador como texto
     */
    @Override
    public String getIdentificador() {
        return idAdministrador;
    }

    /**
     * @return identificador único del administrador
     */
    public String getIdAdministrador() {
        return idAdministrador;
    }

    /**
     * @param idAdministrador establece el identificador del administrador
     */
    public void setIdAdministrador(String idAdministrador) {
        this.idAdministrador = idAdministrador;
    }

    /**
     * @return nombre del administrador
     */
    @Override
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre establece el nombre del administrador
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return apellido paterno del administrador
     */
    @Override
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
     * @return apellido materno del administrador
     */
    @Override
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
     * @return correo electrónico del administrador
     */
    @Override
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
     * @return rol asignado al administrador
     */
    @Override
    public int getRolIdRol() {
        return rolIdRol;
    }

    /**
     * @param rolIdRol establece el rol del administrador
     */
    public void setRolIdRol(int rolIdRol) {
        this.rolIdRol = rolIdRol;
    }

    /**
     * @return foto de perfil del administrador
     */
    @Override
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
