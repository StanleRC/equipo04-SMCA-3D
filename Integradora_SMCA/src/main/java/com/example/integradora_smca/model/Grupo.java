package com.example.integradora_smca.model;

public class Grupo {
    private String idGrupo;
    private int numeroGrupo;
    private int grado;
    private String carreraIdCarrera;

    public Grupo() {
    }

    public Grupo(String idGrupo, int numeroGrupo, int grado, String carreraIdCarrera) {
        this.idGrupo = idGrupo;
        this.numeroGrupo = numeroGrupo;
        this.grado = grado;
        this.carreraIdCarrera = carreraIdCarrera;
    }

    public String getIdGrupo() {
        return idGrupo;
    }

    public void setIdGrupo(String idGrupo) {
        this.idGrupo = idGrupo;
    }

    public int getNumeroGrupo() {
        return numeroGrupo;
    }

    public void setNumeroGrupo(int numeroGrupo) {
        this.numeroGrupo = numeroGrupo;
    }

    public int getGrado() {
        return grado;
    }

    public void setGrado(int grado) {
        this.grado = grado;
    }

    public String getCarreraIdCarrera() {
        return carreraIdCarrera;
    }

    public void setCarreraIdCarrera(String carreraIdCarrera) {
        this.carreraIdCarrera = carreraIdCarrera;
    }
}