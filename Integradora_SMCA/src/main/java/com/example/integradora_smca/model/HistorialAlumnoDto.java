package com.example.integradora_smca.model;

/**
 * Fila del historial de un alumno: una sesión de uso de equipo, con el reporte
 * de falla asociado si es que lo hubo.
 *
 * La versión anterior solo tenía grado, grupo, matricula, nombreCompleto, fecha
 * y estado. Faltaban salon, numeroPc, horaInicial, horaFinal e incidencia, que
 * son las que usan getHistorialByMatricula() y historial_alumno.jsp. Por eso
 * salían en rojo los setters en el DAO y la vista tronaba con
 * PropertyNotFoundException al pedir ${item.numeroPc}.
 */
public class HistorialAlumnoDto {

    private String grado;
    private String grupo;
    private String salon;
    private String numeroPc;
    private String matricula;
    private String nombreCompleto;
    private String fecha;
    private String horaInicial;
    private String horaFinal;
    private String incidencia;
    private String estado;

    public HistorialAlumnoDto() {
    }

    public String getGrado() {
        return grado;
    }

    public void setGrado(String grado) {
        this.grado = grado;
    }

    public String getGrupo() {
        return grupo;
    }

    public void setGrupo(String grupo) {
        this.grupo = grupo;
    }

    /** Aula del laboratorio: CC10, CA1, etc. */
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

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getHoraInicial() {
        return horaInicial;
    }

    public void setHoraInicial(String horaInicial) {
        this.horaInicial = horaInicial;
    }

    /** Puede venir null: la sesión sigue abierta y la vista muestra "En curso". */
    public String getHoraFinal() {
        return horaFinal;
    }

    public void setHoraFinal(String horaFinal) {
        this.horaFinal = horaFinal;
    }

    /** Descripción del reporte de falla, o "Ninguna" si el alumno no reportó nada. */
    public String getIncidencia() {
        return incidencia;
    }

    public void setIncidencia(String incidencia) {
        this.incidencia = incidencia;
    }

    /** Pendiente, Validado, Descartado o "Sin reporte". */
    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}