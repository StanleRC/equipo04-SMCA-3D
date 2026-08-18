package com.example.integradora_smca.model;

/**
 * Fila de la tabla ADMINISTRADOR.
 *
 * Nota sobre el id: en la base es VARCHAR2(30), así que aquí se guarda como String.
 * (En Docente el modelo usa int aunque la columna también sea VARCHAR2; Oracle lo
 * convierte solo, pero es una conversión implícita que conviene no repetir.)
 */
public class Administrador implements UsuarioPersonal {

    private String idAdministrador;
    private String nombre;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private String correo;
    private String hashPassword;
    private int rolIdRol;
    private String fotoPerfil;

    public Administrador() {
    }

    /** Exigido por UsuarioPersonal: la llave primaria como texto. */
    @Override
    public String getIdentificador() {
        return idAdministrador;
    }

    public String getIdAdministrador() {
        return idAdministrador;
    }

    public void setIdAdministrador(String idAdministrador) {
        this.idAdministrador = idAdministrador;
    }

    @Override
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    @Override
    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }

    @Override
    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
    }

    @Override
    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getHashPassword() {
        return hashPassword;
    }

    public void setHashPassword(String hashPassword) {
        this.hashPassword = hashPassword;
    }

    @Override
    public int getRolIdRol() {
        return rolIdRol;
    }

    public void setRolIdRol(int rolIdRol) {
        this.rolIdRol = rolIdRol;
    }

    @Override
    public String getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }
}