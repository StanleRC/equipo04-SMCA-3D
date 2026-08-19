package com.example.integradora_smca.model;

public class Bitacora {

    private int idBitacora;
    private String nombreCompleto;
    private String matricula;
    private String salon; // Representa el Aula
    private String numeroPc;
    private String fecha;
    private String horaInicio;
    private String horaFinal;

    // Constructor vacío
    public Bitacora() {
    }

    // Constructor con parámetros (opcional, pero útil)
    public Bitacora(int idBitacora, String nombreCompleto, String matricula, String salon, String numeroPc, String fecha, String horaInicio, String horaFinal) {
        this.idBitacora = idBitacora;
        this.nombreCompleto = nombreCompleto;
        this.matricula = matricula;
        this.salon = salon;
        this.numeroPc = numeroPc;
        this.fecha = fecha;
        this.horaInicio = horaInicio;
        this.horaFinal = horaFinal;
    }

    // --- GETTERS Y SETTERS ---

    public int getIdBitacora() {
        return idBitacora;
    }

    public void setIdBitacora(int idBitacora) {
        this.idBitacora = idBitacora;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public String getSalon() {
        return salon;
    }

    public void setSalon(String salon) {
        this.salon = salon;
    }

    public String getNumeroPc() {
        return numeroPc;
    }

    public void setNumeroPc(String numeroPc) {
        this.numeroPc = numeroPc;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    public String getHoraFinal() {
        return horaFinal;
    }

    public void setHoraFinal(String horaFinal) {
        this.horaFinal = horaFinal;
    }
}