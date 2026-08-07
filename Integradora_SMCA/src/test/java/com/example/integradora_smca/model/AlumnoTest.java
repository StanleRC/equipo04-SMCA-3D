package com.example.integradora_smca.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AlumnoTest {

    @Test
    void testConstructorVacioYGettersSetters() {
        Alumno alumno = new Alumno();

        alumno.setMatricula("2026001");
        alumno.setNombre("Ana");
        alumno.setApellidos("García");
        alumno.setCorreo("ana@utez.edu.mx");
        alumno.setHashPassword("pass123");
        alumno.setGrupoIdGrupo("1B");
        alumno.setRolIdRol(2);
        alumno.setFotoPerfil("foto.jpg");

        assertEquals("2026001", alumno.getMatricula());
        assertEquals("Ana", alumno.getNombre());
        assertEquals("García", alumno.getApellidos());
        assertEquals("ana@utez.edu.mx", alumno.getCorreo());
        assertEquals("pass123", alumno.getHashPassword());
        assertEquals("1B", alumno.getGrupoIdGrupo());
        assertEquals(2, alumno.getRolIdRol());
        assertEquals("foto.jpg", alumno.getFotoPerfil());
    }

    @Test
    void testConstructorParametrizado() {
        Alumno alumno = new Alumno(
                "2026002",
                "Luis",
                "Martínez",
                "luis@utez.edu.mx",
                "hash456",
                "2A",
                1,
                "perfil.jpg"
        );

        assertEquals("2026002", alumno.getMatricula());
        assertEquals("Luis", alumno.getNombre());
        assertEquals("Martínez", alumno.getApellidos());
        assertEquals("luis@utez.edu.mx", alumno.getCorreo());
        assertEquals("hash456", alumno.getHashPassword());
        assertEquals("2A", alumno.getGrupoIdGrupo());
        assertEquals(1, alumno.getRolIdRol());
        assertEquals("perfil.jpg", alumno.getFotoPerfil());
    }
}