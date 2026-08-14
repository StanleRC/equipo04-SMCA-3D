package com.example.integradora_smca.model;

public class Docente {

    private Integer idDocente;
    private String nombre;
    private String apellidos;
    private String correo;
    private String hashPassword;
    private int rolIdRol;
    private String fotoPerfil;

    public Docente() {
    }

    public Docente(Integer idDocente, String nombre, String apellidos, String correo, String hashPassword, int rolIdRol, String fotoPerfil) {
        this.idDocente = idDocente;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.correo = correo;
        this.hashPassword = hashPassword;
        this.rolIdRol = rolIdRol;
        this.fotoPerfil = fotoPerfil;
    }

    public Integer getIdDocente() {
        return idDocente;
    }

    public void setIdDocente(Integer idDocente) {
        this.idDocente = idDocente;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

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

    public int getRolIdRol() {
        return rolIdRol;
    }

    public void setRolIdRol(int rolIdRol) {
        this.rolIdRol = rolIdRol;
    }

    public String getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }
}

