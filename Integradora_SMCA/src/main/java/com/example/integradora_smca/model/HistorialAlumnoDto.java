package com.example.integradora_smca.model;

public class HistorialAlumnoDto {
    private String grado;
    private String grupo;
    private String numeroPc;
    private String matricula;
    private String nombreCompleto;
    private String fecha;
    private String incidencia;
    private String estado;

    public HistorialAlumnoDto() {}

    // Getters y Setters
    public String getGrado() { return grado; }
    public void setGrado(String grado) { this.grado = grado; }

    public String getGrupo() { return grupo; }
    public void setGrupo(String grupo) { this.grupo = grupo; }

    public String getNumeroPc() { return numeroPc; }
    public void setNumeroPc(String numeroPc) { this.numeroPc = numeroPc; }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public String getNombreCompleto() { return nombreCompleto; }
    public void setNombreCompleto(String nombreCompleto) { this.nombreCompleto = nombreCompleto; }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public String getIncidencia() { return incidencia; }
    public void setIncidencia(String incidencia) { this.incidencia = incidencia; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}