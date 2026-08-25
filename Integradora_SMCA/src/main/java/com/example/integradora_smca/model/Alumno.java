package com.example.integradora_smca.model;

/**
 * Clase Alumno
 * @Autor: Luis Uriel
 * @Fecha: 25/08/2026
 * @Funcionalidad: Representa la entidad Alumno dentro del sistema.
 * Contiene atributos básicos de identificación, credenciales y datos de perfil.
 * Se utiliza en operaciones de registro, autenticación y gestión de grupos.
 */
public class Alumno {

    private String matricula;       // Identificador único del alumno
    private String nombre;          // Nombre del alumno
    private String apellidoPaterno; // Apellido paterno
    private String apellidoMaterno; // Apellido materno
    private String correo;          // Correo institucional o personal
    private String hashPassword;    // Contraseña en formato hash para seguridad
    private String grupoIdGrupo;    // Relación con el grupo al que pertenece
    private int rolIdRol;           // Rol asignado (ej. alumno, docente, admin)
    private String fotoPerfil;      // Ruta o referencia a la foto de perfil

    /**
     * Constructor vacío
     * Permite crear un objeto Alumno sin inicializar atributos.
     */
    public Alumno() {
    }

    /**
     * Constructor completo
     * @param matricula Identificador único del alumno
     * @param nombre Nombre del alumno
     * @param apellidoPaterno Apellido paterno
     * @param apellidoMaterno Apellido materno
     * @param correo Correo electrónico
     * @param hashPassword Contraseña en formato hash
     * @param grupoIdGrupo Identificador del grupo
     * @param rolIdRol Rol asignado al alumno
     * @param fotoPerfil Foto de perfil del alumno
     */
    public Alumno(String matricula, String nombre, String apellidoPaterno, String apellidoMaterno,
                  String correo, String hashPassword, String grupoIdGrupo, int rolIdRol, String fotoPerfil) {
        this.matricula = matricula;
        this.nombre = nombre;
        this.apellidoPaterno = apellidoPaterno;
        this.apellidoMaterno = apellidoMaterno;
        this.correo = correo;
        this.hashPassword = hashPassword;
        this.grupoIdGrupo = grupoIdGrupo;
        this.rolIdRol = rolIdRol;
        this.fotoPerfil = fotoPerfil;
    }

    // Métodos Getters y Setters documentados

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
     * @return nombre del alumno
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre establece el nombre del alumno
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return apellido paterno del alumno
     */
    public String getApellidoPaterno() {
        return apellidoPaterno;
    }

    /**
     * @param apellidoPaterno establece el apellido paterno
     */
    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }

    /**
     * @return apellido materno del alumno
     */
    public String getApellidoMaterno() {
        return apellidoMaterno;
    }

    /**
     * @param apellidoMaterno establece el apellido materno
     */
    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
    }

    /**
     * @return correo electrónico del alumno
     */
    public String getCorreo() {
        return correo;
    }

    /**
     * @param correo establece el correo electrónico
     */
    public void setCorreo(String correo) {
        this.correo = correo;
    }

    /**
     * @return contraseña en formato hash
     */
    public String getHashPassword() {
        return hashPassword;
    }

    /**
     * @param hashPassword establece la contraseña en formato hash
     */
    public void setHashPassword(String hashPassword) {
        this.hashPassword = hashPassword;
    }

    /**
     * @return identificador del grupo al que pertenece
     */
    public String getGrupoIdGrupo() {
        return grupoIdGrupo;
    }

    /**
     * @param grupoIdGrupo establece el grupo del alumno
     */
    public void setGrupoIdGrupo(String grupoIdGrupo) {
        this.grupoIdGrupo = grupoIdGrupo;
    }

    /**
     * @return rol asignado al alumno
     */
    public int getRolIdRol() {
        return rolIdRol;
    }

    /**
     * @param rolIdRol establece el rol del alumno
     */
    public void setRolIdRol(int rolIdRol) {
        this.rolIdRol = rolIdRol;
    }

    /**
     * @return foto de perfil del alumno
     */
    public String getFotoPerfil() {
        return fotoPerfil;
    }

    /**
     * @param fotoPerfil establece la foto de perfil
     */
    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }
}
