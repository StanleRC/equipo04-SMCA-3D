package com.example.integradora_smca.model;

/**
 * Clase Grupo
 * @Autor: Maria Fernanda
 * @Fecha: 25/08/2026
 * @Funcionalidad: Representa la entidad Grupo dentro del sistema académico.
 * Contiene información sobre el identificador del grupo, número, grado y
 * relación con la carrera correspondiente. Se utiliza para organizar alumnos
 * y docentes dentro de un plan de estudios.
 */
public class Grupo {
    private String idGrupo;          // Identificador único del grupo
    private int numeroGrupo;         // Número del grupo dentro del grado
    private int grado;               // Grado académico al que pertenece
    private String carreraIdCarrera; // Relación con la carrera correspondiente

    /**
     * Constructor vacío
     * Permite crear un objeto Grupo sin inicializar atributos.
     */
    public Grupo() {
    }

    /**
     * Constructor completo
     * @param idGrupo identificador único del grupo
     * @param numeroGrupo número del grupo dentro del grado
     * @param grado grado académico al que pertenece
     * @param carreraIdCarrera identificador de la carrera asociada
     */
    public Grupo(String idGrupo, int numeroGrupo, int grado, String carreraIdCarrera) {
        this.idGrupo = idGrupo;
        this.numeroGrupo = numeroGrupo;
        this.grado = grado;
        this.carreraIdCarrera = carreraIdCarrera;
    }

    /**
     * @return identificador único del grupo
     */
    public String getIdGrupo() {
        return idGrupo;
    }

    /**
     * @param idGrupo establece el identificador del grupo
     */
    public void setIdGrupo(String idGrupo) {
        this.idGrupo = idGrupo;
    }

    /**
     * @return número del grupo dentro del grado
     */
    public int getNumeroGrupo() {
        return numeroGrupo;
    }

    /**
     * @param numeroGrupo establece el número del grupo
     */
    public void setNumeroGrupo(int numeroGrupo) {
        this.numeroGrupo = numeroGrupo;
    }

    /**
     * @return grado académico al que pertenece el grupo
     */
    public int getGrado() {
        return grado;
    }

    /**
     * @param grado establece el grado académico
     */
    public void setGrado(int grado) {
        this.grado = grado;
    }

    /**
     * @return identificador de la carrera asociada
     */
    public String getCarreraIdCarrera() {
        return carreraIdCarrera;
    }

    /**
     * @param carreraIdCarrera establece la carrera asociada al grupo
     */
    public void setCarreraIdCarrera(String carreraIdCarrera) {
        this.carreraIdCarrera = carreraIdCarrera;
    }
}
