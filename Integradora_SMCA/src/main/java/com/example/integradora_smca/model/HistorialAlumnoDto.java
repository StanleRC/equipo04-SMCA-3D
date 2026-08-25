package com.example.integradora_smca.model;

/**
 * Clase HistorialAlumnoDto
 * @Autor: Naomy Sayuri
 * @Fecha: 25/08/2026
 * @Funcionalidad: Representa una fila del historial de un alumno.
 * Contiene la información de una sesión de uso de equipo en laboratorio,
 * incluyendo datos de aula, equipo, horarios y reporte de incidencias.
 * Se utiliza en consultas de historial y vistas como historial_alumno.jsp.
 */
public class HistorialAlumnoDto {

    private String grado;           // Grado académico del alumno
    private String grupo;           // Grupo al que pertenece
    private String salon;           // Aula del laboratorio (ej. CC10, CA1)
    private String numeroPc;        // Número de PC utilizada
    private String matricula;       // Matrícula del alumno
    private String nombreCompleto;  // Nombre completo del alumno
    private String fecha;           // Fecha de la sesión
    private String horaInicial;     // Hora de inicio de la sesión
    private String horaFinal;       // Hora de finalización (puede ser null si sigue en curso)
    private String incidencia;      // Descripción de falla reportada o "Ninguna"
    private String estado;          // Estado de la incidencia (Pendiente, Validado, Descartado, Sin reporte)

    /**
     * Constructor vacío
     * Permite crear un objeto HistorialAlumnoDto sin inicializar atributos.
     */
    public HistorialAlumnoDto() {
    }

    /**
     * @return grado académico del alumno
     */
    public String getGrado() {
        return grado;
    }

    /**
     * @param grado establece el grado académico
     */
    public void setGrado(String grado) {
        this.grado = grado;
    }

    /**
     * @return grupo del alumno
     */
    public String getGrupo() {
        return grupo;
    }

    /**
     * @param grupo establece el grupo del alumno
     */
    public void setGrupo(String grupo) {
        this.grupo = grupo;
    }

    /**
     * @return aula del laboratorio
     */
    public String getSalon() {
        return salon;
    }

    /**
     * @param salon establece el aula del laboratorio
     */
    public void setSalon(String salon) {
        this.salon = salon;
    }

    /**
     * @return número de PC utilizada
     */
    public String getNumeroPc() {
        return numeroPc;
    }

    /**
     * @param numeroPc establece el número de PC utilizada
     */
    public void setNumeroPc(String numeroPc) {
        this.numeroPc = numeroPc;
    }

    /**
     * @return matrícula del alumno
     */
    public String getMatricula() {
        return matricula;
    }

    /**
     * @param matricula establece la matrícula del alumno
     */
    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    /**
     * @return nombre completo del alumno
     */
    public String getNombreCompleto() {
        return nombreCompleto;
    }

    /**
     * @param nombreCompleto establece el nombre completo del alumno
     */
    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    /**
     * @return fecha de la sesión
     */
    public String getFecha() {
        return fecha;
    }

    /**
     * @param fecha establece la fecha de la sesión
     */
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    /**
     * @return hora de inicio de la sesión
     */
    public String getHoraInicial() {
        return horaInicial;
    }

    /**
     * @param horaInicial establece la hora de inicio
     */
    public void setHoraInicial(String horaInicial) {
        this.horaInicial = horaInicial;
    }

    /**
     * @return hora de finalización de la sesión (puede ser null si sigue en curso)
     */
    public String getHoraFinal() {
        return horaFinal;
    }

    /**
     * @param horaFinal establece la hora de finalización
     */
    public void setHoraFinal(String horaFinal) {
        this.horaFinal = horaFinal;
    }

    /**
     * @return descripción de la incidencia reportada
     */
    public String getIncidencia() {
        return incidencia;
    }

    /**
     * @param incidencia establece la descripción de la incidencia
     */
    public void setIncidencia(String incidencia) {
        this.incidencia = incidencia;
    }

    /**
     * @return estado de la incidencia (Pendiente, Validado, Descartado, Sin reporte)
     */
    public String getEstado() {
        return estado;
    }

    /**
     * @param estado establece el estado de la incidencia
     */
    public void setEstado(String estado) {
        this.estado = estado;
    }
}
