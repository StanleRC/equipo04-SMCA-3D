package com.example.integradora_smca.model;

/**
 * Clase Bitacora
 * @Autor: Erick Manuel
 * @Fecha: 25/08/2026
 * @Funcionalidad: Representa el registro de uso de equipos en los laboratorios.
 * Contiene información del alumno, aula, equipo utilizado y tiempos de sesión.
 * Se utiliza para auditar incidencias, generar reportes y validar el historial
 * de uso de los recursos.
 */
public class Bitacora {

    private int idBitacora;          // Identificador único de la bitácora
    private String nombreCompleto;   // Nombre completo del alumno
    private String matricula;        // Matrícula del alumno
    private String salon;            // Aula donde se registró la sesión
    private String numeroPc;         // Número de PC utilizada
    private String fecha;            // Fecha del registro
    private String horaInicio;       // Hora de inicio de la sesión
    private String horaFinal;        // Hora de finalización de la sesión

    /**
     * Constructor vacío
     * Permite crear un objeto Bitacora sin inicializar atributos.
     */
    public Bitacora() {
    }

    /**
     * Constructor completo
     * @param idBitacora identificador único de la bitácora
     * @param nombreCompleto nombre completo del alumno
     * @param matricula matrícula del alumno
     * @param salon aula donde se registró la sesión
     * @param numeroPc número de PC utilizada
     * @param fecha fecha del registro
     * @param horaInicio hora de inicio de la sesión
     * @param horaFinal hora de finalización de la sesión
     */
    public Bitacora(int idBitacora, String nombreCompleto, String matricula, String salon,
                    String numeroPc, String fecha, String horaInicio, String horaFinal) {
        this.idBitacora = idBitacora;
        this.nombreCompleto = nombreCompleto;
        this.matricula = matricula;
        this.salon = salon;
        this.numeroPc = numeroPc;
        this.fecha = fecha;
        this.horaInicio = horaInicio;
        this.horaFinal = horaFinal;
    }

    /**
     * @return identificador único de la bitácora
     */
    public int getIdBitacora() {
        return idBitacora;
    }

    /**
     * @param idBitacora establece el identificador de la bitácora
     */
    public void setIdBitacora(int idBitacora) {
        this.idBitacora = idBitacora;
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
     * @return aula donde se registró la sesión
     */
    public String getSalon() {
        return salon;
    }

    /**
     * @param salon establece el aula de la sesión
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
     * @return fecha del registro
     */
    public String getFecha() {
        return fecha;
    }

    /**
     * @param fecha establece la fecha del registro
     */
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    /**
     * @return hora de inicio de la sesión
     */
    public String getHoraInicio() {
        return horaInicio;
    }

    /**
     * @param horaInicio establece la hora de inicio de la sesión
     */
    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    /**
     * @return hora de finalización de la sesión
     */
    public String getHoraFinal() {
        return horaFinal;
    }

    /**
     * @param horaFinal establece la hora de finalización de la sesión
     */
    public void setHoraFinal(String horaFinal) {
        this.horaFinal = horaFinal;
    }
}
