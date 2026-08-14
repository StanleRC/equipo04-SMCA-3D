package com.example.integradora_smca.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailSender {

    private static final String REMITENTE = "tubitacoradijital@gmail.com";
    private static final String PASSWORD = "zhzvqioxhvnsekcw";

    public static boolean sendMail(String correoDestino, String asunto, String cuerpoHtml) {
        Properties props = new Properties();

        // 1. Configuración usando Puerto 465 (SSL) en lugar de 587 (STARTTLS)
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true"); // Conexión SSL directa

        // Factory SSL para evitar bloqueos en el cambio de socket
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");

        // Configuración de TLS/SSL para Java 21
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // Timeouts para evitar que se quede congelado si la red es lenta
        props.put("mail.smtp.connectiontimeout", "10000"); // 10 segundos
        props.put("mail.smtp.timeout", "10000");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(REMITENTE, PASSWORD);
            }
        });

        session.setDebug(true);

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(REMITENTE, "Bitácora Digital UTEZ"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(correoDestino));
            message.setSubject(asunto);
            message.setContent(cuerpoHtml, "text/html; charset=utf-8");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            System.err.println("=== ERROR EN EMAIL SENDER ===");
            e.printStackTrace();
            return false;
        }
    }

    public static boolean enviarCodigoVerificacion(String correoDestino, String codigo) {
        String asunto = "Código de Validación - Bitácora Digital UTEZ";
        String html =
                "<div style='font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 12px; background-color: #f9f9f9;'>" +
                        "<h2 style='color: #0d8a72; text-align: center;'>Validación de Cuenta</h2>" +
                        "<p style='color: #333333; font-size: 15px;'>Tu código de verificación es:</p>" +
                        "<div style='background-color: #ffffff; border: 2px dashed #0d8a72; border-radius: 8px; padding: 15px; text-align: center; margin: 20px 0;'>" +
                        "<b style='font-size: 28px; color: #0d8a72; letter-spacing: 5px;'>" + codigo + "</b>" +
                        "</div>" +
                        "</div>";

        return sendMail(correoDestino, asunto, html);
    }
}