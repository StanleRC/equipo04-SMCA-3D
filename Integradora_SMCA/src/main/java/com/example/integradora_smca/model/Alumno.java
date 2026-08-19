package com.example.integradora_smca.model;

public class Alumno {

    private String matricula;
    private String nombre;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private String correo;
    private String hashPassword;
    private String grupoIdGrupo;
    private int rolIdRol;
    private String fotoPerfil;

    // Constructor vacío
    public Alumno() {
    }

    // Constructor completo
    public Alumno(String matricula, String nombre, String apellidoPaterno, String apellidoMaterno, String correo, String hashPassword, String grupoIdGrupo, int rolIdRol, String fotoPerfil) {
        this.matricula = matricula;
        this.nombre = nombre;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
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

    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }

    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
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