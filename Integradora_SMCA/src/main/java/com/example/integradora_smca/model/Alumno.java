package com.example.integradora_smca.model;

public class Alumno {

    private String matricula;
    private String nombre;
    private String apellidos;
    private String correo;
    private String hashPassword;
    private String grupoIdGrupo;
    private int rolIdRol;
    private String fotoPerfil;

    // Constructor vacío
    public Alumno() {
    }

    // Constructor completo
    public Alumno(String matricula, String nombre, String apellidos, String correo, String hashPassword, String grupoIdGrupo, int rolIdRol, String fotoPerfil) {
        this.matricula = matricula;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.correo = correo;
        this.hashPassword = hashPassword;
        this.grupoIdGrupo = grupoIdGrupo;
        this.rolIdRol = rolIdRol;
        this.fotoPerfil = fotoPerfil;
    }

    // Getters y Setters

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
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

    public String getGrupoIdGrupo() {
        return grupoIdGrupo;
    }

    public void setGrupoIdGrupo(String grupoIdGrupo) {
        this.grupoIdGrupo = grupoIdGrupo;
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