package com.example.integradora_smca.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class HistorialAlumnoDtoTest {

    @Test
    void testGettersAndSetters() {
        HistorialAlumnoDto dto = new HistorialAlumnoDto();

        dto.setGrado("3");
        dto.setGrupo("A");
        dto.setNumeroPc("PC-12");
        dto.setMatricula("20263D001");
        dto.setNombreCompleto("Judith Aguilar");
        dto.setFecha("2026-08-06");
        dto.setIncidencia("Ninguna");
        dto.setEstado("Activo");

        assertEquals("3", dto.getGrado());
        assertEquals("A", dto.getGrupo());
        assertEquals("PC-12", dto.getNumeroPc());
        assertEquals("20263D001", dto.getMatricula());
        assertEquals("Judith Aguilar", dto.getNombreCompleto());
        assertEquals("2026-08-06", dto.getFecha());
        assertEquals("Ninguna", dto.getIncidencia());
        assertEquals("Activo", dto.getEstado());
    }
}