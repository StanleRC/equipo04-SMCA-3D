package com.example.integradora_smca.model;

public class Alumno {
    private int id;
    private String nombre;
    private String correo;
    private String matricula;
    private String contrasena;
    private String rol; // Por defecto se guardará como "estudiante"

    // Constructor vacío (Obligatorio para que Java Beans o frameworks no den problemas)
    public Alumno() {}

    // Constructor completo para crear objetos rápidamente
    public Alumno(int id, String nombre, String correo, String matricula, String contrasena, String rol) {
        this.id = id;
        this.nombre = nombre;
        this.correo = correo;
        this.matricula = matricula;
        this.contrasena = contrasena;
        this.rol = rol;
    }

    // Getters y Setters (Para que el Servlet y el DAO puedan leer y escribir los datos)
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }
}