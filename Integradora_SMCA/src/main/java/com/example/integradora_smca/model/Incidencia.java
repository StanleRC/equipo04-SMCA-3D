package com.example.integradora_smca.model;

import java.sql.Timestamp;

/**
 * Clase Incidencia
 * @Autor: Maria Fernanda
 * @Fecha: 25/08/2026
 * @Funcionalidad: Representa un reporte de falla/incidencia dentro del sistema.
 * Contiene información sobre el equipo afectado, descripción de la falla,
 * prioridad, estado del reporte, laboratorio asociado y datos del alumno que
 * realizó el registro. Se utiliza en la gestión y validación de incidencias.
 */
public class Incidencia {
    private int idReporte;             // Identificador único del reporte
    private String descripcionFalla;   // Descripción de la falla reportada
    private String prioridad;          // Nivel de prioridad (Alta, Media, Baja)
    private Timestamp fechaReporte;    // Fecha y hora en que se registró la incidencia
    private String numeroPc;           // Número de PC afectada
    private String estadoReporte;      // Estado del reporte (Pendiente, Validado, Descartado)
    private String idLaboratorio;      // Identificador del laboratorio
    private String nombreLab;          // Nombre del laboratorio
    private String matricula;          // Matrícula del alumno que reportó
    private String alumnoNombre;       // Nombre del alumno que reportó

    /**
     * Constructor vacío
     * Permite crear un objeto Incidencia sin inicializar atributos.
     */
    public Incidencia() {
    }

    /**
     * Constructor completo
     * @param idReporte identificador único del reporte
     * @param descripcionFalla descripción de la falla reportada
     * @param prioridad nivel de prioridad
     * @param fechaReporte fecha y hora del reporte
     * @param numeroPc número de PC afectada
     * @param estadoReporte estado actual del reporte
     * @param idLaboratorio identificador del laboratorio
     * @param nombreLab nombre del laboratorio
     * @param matricula matrícula del alumno que reportó
     * @param alumnoNombre nombre del alumno que reportó
     */
    public Incidencia(int idReporte, String descripcionFalla, String prioridad, Timestamp fechaReporte,
                      String numeroPc, String estadoReporte, String idLaboratorio,
                      String nombreLab, String matricula, String alumnoNombre) {
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

    /**
     * @return identificador único del reporte
     */
    public int getIdReporte() { return idReporte; }

    /**
     * @param idReporte establece el identificador del reporte
     */
    public void setIdReporte(int idReporte) { this.idReporte = idReporte; }

    /**
     * @return descripción de la falla reportada
     */
    public String getDescripcionFalla() { return descripcionFalla; }

    /**
     * @param descripcionFalla establece la descripción de la falla
     */
    public void setDescripcionFalla(String descripcionFalla) { this.descripcionFalla = descripcionFalla; }

    /**
     * @return nivel de prioridad del reporte
     */
    public String getPrioridad() { return prioridad; }

    /**
     * @param prioridad establece el nivel de prioridad
     */
    public void setPrioridad(String prioridad) { this.prioridad = prioridad; }

    /**
     * @return fecha y hora del reporte
     */
    public Timestamp getFechaReporte() { return fechaReporte; }

    /**
     * @param fechaReporte establece la fecha y hora del reporte
     */
    public void setFechaReporte(Timestamp fechaReporte) { this.fechaReporte = fechaReporte; }

    /**
     * @return número de PC afectada
     */
    public String getNumeroPc() { return numeroPc; }

    /**
     * @param numeroPc establece el número de PC afectada
     */
    public void setNumeroPc(String numeroPc) { this.numeroPc = numeroPc; }

    /**
     * @return estado actual del reporte
     */
    public String getEstadoReporte() { return estadoReporte; }

    /**
     * @param estadoReporte establece el estado del reporte
     */
    public void setEstadoReporte(String estadoReporte) { this.estadoReporte = estadoReporte; }

    /**
     * @return identificador del laboratorio
     */
    public String getIdLaboratorio() { return idLaboratorio; }

    /**
     * @param idLaboratorio establece el identificador del laboratorio
     */
    public void setIdLaboratorio(String idLaboratorio) { this.idLaboratorio = idLaboratorio; }

    /**
     * @return nombre del laboratorio
     */
    public String getNombreLab() { return nombreLab; }

    /**
     * @param nombreLab establece el nombre del laboratorio
     */
    public void setNombreLab(String nombreLab) { this.nombreLab = nombreLab; }

    /**
     * @return matrícula del alumno que reportó
     */
    public String getMatricula() { return matricula; }

    /**
     * @param matricula establece la matrícula del alumno
     */
    public void setMatricula(String matricula) { this.matricula = matricula; }

    /**
     * @return nombre del alumno que reportó
     */
    public String getAlumnoNombre() { return alumnoNombre; }

    /**
     * @param alumnoNombre establece el nombre del alumno
     */
    public void setAlumnoNombre(String alumnoNombre) { this.alumnoNombre = alumnoNombre; }
}
