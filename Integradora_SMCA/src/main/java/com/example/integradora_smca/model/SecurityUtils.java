package com.example.integradora_smca.model;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Clase SecurityUtils
 * @Autor: Maria Fernanda
 * @Fecha: 25/08/2026
 * @Funcionalidad: Proporciona utilidades de seguridad para el sistema.
 * Actualmente implementa el método de cifrado de contraseñas utilizando
 * el algoritmo SHA-256, garantizando que las credenciales se almacenen
 * de forma segura en la base de datos.
 */
public class SecurityUtils {

    /**
     * Genera un hash seguro de la contraseña utilizando SHA-256.
     * @param password contraseña en texto plano
     * @return cadena en formato hexadecimal con el hash de la contraseña,
     *         o null si la contraseña es nula o vacía
     * @throws RuntimeException si ocurre un error al aplicar el algoritmo
     */
    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) return null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] encodedhash = digest.digest(password.trim().getBytes(StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder(2 * encodedhash.length);
            for (byte b : encodedhash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString().toLowerCase();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al cifrar contraseña", e);
        }
    }
}
