package com.example.integradora_smca.model;

import java.sql.Timestamp;

public class Incidencia {
    private int idReporte;
    private String descripcionFalla;
    private String prioridad;
    private Timestamp fechaReporte;
    private String numeroPc;
    private String estadoReporte;
    private String idLaboratorio;
    private String nombreLab;
    private String matricula;
    private String alumnoNombre;

    public Incidencia() {
    }

    public Incidencia(int idReporte, String descripcionFalla, String prioridad, Timestamp fechaReporte, String numeroPc, String estadoReporte, String idLaboratorio, String nombreLab, String matricula, String alumnoNombre) {
        this.idReporte = idReporte;
        this.descripcionFalla = descripcionFalla;
        this.prioridad = prioridad;
        this.fechaReporte = fechaReporte;
        this.numeroPc = numeroPc;
        this.estadoReporte = estadoReporte;
        this.idLaboratorio = idLaboratorio;
        this.nombreLab = nombreLab;
        this.matricula = matricula;
        this.alumnoNombre = alumnoNombre;
    }

    // Getters y Setters
    public int getIdReporte() { return idReporte; }
    public void setIdReporte(int idReporte) { this.idReporte = idReporte; }

    public String getDescripcionFalla() { return descripcionFalla; }
    public void setDescripcionFalla(String descripcionFalla) { this.descripcionFalla = descripcionFalla; }

    public String getPrioridad() { return prioridad; }
    public void setPrioridad(String prioridad) { this.prioridad = prioridad; }

    public Timestamp getFechaReporte() { return fechaReporte; }
    public void setFechaReporte(Timestamp fechaReporte) { this.fechaReporte = fechaReporte; }

    public String getNumeroPc() { return numeroPc; }
    public void setNumeroPc(String numeroPc) { this.numeroPc = numeroPc; }

    public String getEstadoReporte() { return estadoReporte; }
    public void setEstadoReporte(String estadoReporte) { this.estadoReporte = estadoReporte; }

    public String getIdLaboratorio() { return idLaboratorio; }
    public void setIdLaboratorio(String idLaboratorio) { this.idLaboratorio = idLaboratorio; }

    public String getNombreLab() { return nombreLab; }
    public void setNombreLab(String nombreLab) { this.nombreLab = nombreLab; }

    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }

    public String getAlumnoNombre() { return alumnoNombre; }
    public void setAlumnoNombre(String alumnoNombre) { this.alumnoNombre = alumnoNombre; }
}