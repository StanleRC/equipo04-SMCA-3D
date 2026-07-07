package com.example.integradora_smca.model.dao;

public class Docente {
    private int idDocente;
    private String correoInstitucional;
    private String nombre;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private int idRol;
    private String contrasena; // Se mantiene para hacer Match con tu Formulario
    private String telefono;   // Se mantiene para hacer Match con tu Formulario

    public Docente() {}

    // Constructor completo para inserción
    public Docente(String correoInstitucional, String nombre, String apellidoPaterno, String apellidoMaterno, String contrasena, String telefono) {
        this.correoInstitucional = correoInstitucional;
        this.nombre = nombre;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
        this.contrasena = contrasena;
        this.telefono = telefono;
        this.idRol = 2; // Por defecto rol Docente según tu script
    }

    // Getters y Setters
    public int getIdDocente() { return idDocente; }
    public void setIdDocente(int idDocente) { this.idDocente = idDocente; }

    public String getCorreoInstitucional() { return correoInstitucional; }
    public void setCorreoInstitucional(String correoInstitucional) { this.correoInstitucional = correoInstitucional; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellidoPaterno() { return apellidoPaterno; }
    public void setApellidoPaterno(String apellidoPaterno) { this.apellidoPaterno = apellidoPaterno; }

    public String getApellidoMaterno() { return apellidoMaterno; }
    public void setApellidoMaterno(String apellidoMaterno) { this.apellidoMaterno = apellidoMaterno; }

    public int getIdRol() { return idRol; }
    public void setIdRol(int idRol) { this.idRol = idRol; }

    public String getContrasena() { return contrasena; }
    public void setContrasena(String contrasena) { this.contrasena = contrasena; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
}