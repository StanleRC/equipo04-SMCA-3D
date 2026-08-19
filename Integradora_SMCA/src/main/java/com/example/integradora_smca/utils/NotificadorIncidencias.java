package com.example.integradora_smca.utils;

import jakarta.mail.Message;
import jakarta.mail.Multipart;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;

import java.io.File;
import java.util.Map;
import java.util.Properties;

/**
 * Avisa por correo al administrador cuando un docente revisa una incidencia.
 *
 * IMPORTANTE: las constantes de abajo deben tener los MISMOS valores que ya usa
 * tu EmailSender. Cópialos de ahí tal cual. Si tu EmailSender los lee de un
 * archivo de propiedades, haz lo mismo aquí: una contraseña dentro del código
 * termina publicada en el repositorio.
 */
public final class NotificadorIncidencias {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String CORREO_REMITENTE = "tubitacoradijital@gmail.com";

    /** Contraseña de aplicación de Gmail, NO la contraseña normal de la cuenta. */
    private static final String PASSWORD_APP = "zhzvqioxhvnsekcw";

    /** Destinatario provisional mientras se define la cuenta oficial. */
    private static final String CORREO_ADMIN = "20253ds035@utez.edu.mx";

    private NotificadorIncidencias() {
    }

    /**
     * Envía el aviso. Nunca lanza excepción: si el correo falla, la revisión de
     * la incidencia ya quedó guardada en la base y no debe perderse por eso.
     *
     * @param reporte     datos del reporte tal como los devuelve IncidenciaDao
     * @param quienValida nombre completo de quien pulsó el botón
     * @param decision    "Validado" o "Descartado"
     * @param evidencia   imagen a adjuntar, o null si no se subió ninguna
     * @param comentario  la breve descripción que escribió el docente en el
     *                    modal, o null si la dejó vacía
     * @return true si el correo salió
     */
    public static boolean avisarIncidenciaRevisada(Map<String, Object> reporte,
                                                   String quienValida,
                                                   String decision,
                                                   File evidencia,
                                                   String comentario) {
        try {
            Session sesion = crearSesion();

            MimeMessage mensaje = new MimeMessage(sesion);
            mensaje.setFrom(new InternetAddress(CORREO_REMITENTE, "Bitácora Digital UTEZ"));
            mensaje.setRecipients(Message.RecipientType.TO, InternetAddress.parse(CORREO_ADMIN));
            mensaje.setSubject("Incidencia " + decision.toLowerCase()
                    + " en " + texto(reporte.get("salon"))
                    + " (PC " + texto(reporte.get("numeroPc")) + ")");

            Multipart contenido = new MimeMultipart();

            MimeBodyPart cuerpo = new MimeBodyPart();
            cuerpo.setContent(
                    construirHtml(reporte, quienValida, decision, comentario, evidencia != null),
                    "text/html; charset=UTF-8");
            contenido.addBodyPart(cuerpo);

            if (evidencia != null && evidencia.isFile() && evidencia.canRead()) {
                MimeBodyPart adjunto = new MimeBodyPart();
                // attachFile evita depender del artefacto jakarta.activation.
                adjunto.attachFile(evidencia);
                adjunto.setFileName("evidencia_" + texto(reporte.get("idReporte"))
                        + extension(evidencia));
                contenido.addBodyPart(adjunto);
            }

            mensaje.setContent(contenido);
            Transport.send(mensaje);

            System.out.println(">>> [Notificador] Correo enviado a " + CORREO_ADMIN);
            return true;

        } catch (Exception e) {
            // Se registra y se sigue: el reporte ya está revisado en la base.
            System.err.println(">>> [Notificador] No se pudo enviar el correo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /** Versión sin comentario, por si alguna pantalla vieja la sigue llamando. */
    public static boolean avisarIncidenciaRevisada(Map<String, Object> reporte,
                                                   String quienValida,
                                                   String decision,
                                                   File evidencia) {
        return avisarIncidenciaRevisada(reporte, quienValida, decision, evidencia, null);
    }

    private static Session crearSesion() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        return Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(CORREO_REMITENTE, PASSWORD_APP);
            }
        });
    }

    private static String construirHtml(Map<String, Object> r, String quienValida,
                                        String decision, String comentario, boolean llevaFoto) {

        String colorEstado = "Validado".equalsIgnoreCase(decision) ? "#1e7e4a" : "#8a6100";

        boolean hayComentario = comentario != null && !comentario.trim().isEmpty();

        return "<div style=\"font-family:Arial,Helvetica,sans-serif;max-width:560px;"
                + "margin:0 auto;color:#333;\">"

                + "<div style=\"background:#1c3862;color:#fff;padding:18px 22px;"
                + "border-radius:10px 10px 0 0;\">"
                + "<h2 style=\"margin:0;font-size:19px;\">Bitácora Digital UTEZ</h2>"
                + "<p style=\"margin:4px 0 0;font-size:13px;opacity:.85;\">"
                + "Aviso de incidencia revisada</p>"
                + "</div>"

                + "<div style=\"border:1px solid #e2e6ee;border-top:none;"
                + "border-radius:0 0 10px 10px;padding:22px;\">"

                + "<p style=\"font-size:15px;margin:0 0 14px;\">Hola, estimado administrador:</p>"

                + "<p style=\"font-size:14px;line-height:1.55;margin:0 0 18px;\">"
                + "<strong>" + escapar(quienValida) + "</strong> acaba de revisar una incidencia "
                + "reportada en el laboratorio <strong>" + escapar(texto(r.get("salon")))
                + "</strong>. El detalle es el siguiente:</p>"

                + "<table style=\"width:100%;border-collapse:collapse;font-size:14px;\">"
                + fila("Estado", "<span style=\"color:" + colorEstado + ";font-weight:bold;\">"
                + escapar(decision) + "</span>")
                + fila("Laboratorio", escapar(texto(r.get("salon"))) + " ("
                + escapar(texto(r.get("edificio"))) + ")")
                + fila("Número de PC", escapar(texto(r.get("numeroPc"))))
                + fila("Alumno", escapar(texto(r.get("nombreCompleto"))))
                + fila("Matrícula", escapar(texto(r.get("matricula"))))
                + fila("Grado y grupo", escapar(texto(r.get("grado"))) + "° "
                + escapar(texto(r.get("grupo"))))
                + fila("Fecha del reporte", escapar(texto(r.get("fecha"))))
                + fila("Prioridad", escapar(texto(r.get("prioridad"))))
                + "</table>"

                + "<p style=\"font-size:13px;font-weight:bold;margin:20px 0 6px;\">"
                + "Falla reportada por el alumno</p>"
                + "<div style=\"background:#f7f8fa;border-left:3px solid #1c3862;"
                + "padding:12px 14px;font-size:14px;line-height:1.5;\">"
                + escapar(texto(r.get("incidencia")))
                + "</div>"

                /*
                 * La breve descripción que escribe el docente en el modal.
                 * Va en bloque aparte para que no se confunda con lo que
                 * reportó el alumno: son dos voces distintas.
                 */
                + (hayComentario
                ? "<p style=\"font-size:13px;font-weight:bold;margin:20px 0 6px;\">"
                + "Comentario de " + escapar(quienValida) + "</p>"
                + "<div style=\"background:#f2fbf8;border-left:3px solid #0d8a72;"
                + "padding:12px 14px;font-size:14px;line-height:1.5;\">"
                + escapar(comentario.trim())
                + "</div>"
                : "<p style=\"font-size:13px;color:#8a8a8a;margin:18px 0 0;\">"
                + "No se agregó ningún comentario a la revisión.</p>")

                + (llevaFoto
                ? "<p style=\"font-size:13px;color:#5a6b85;margin:18px 0 0;\">"
                + "Se adjunta la fotografía de evidencia a este correo.</p>"
                : "<p style=\"font-size:13px;color:#8a8a8a;margin:12px 0 0;\">"
                + "No se adjuntó fotografía de evidencia.</p>")

                + "<hr style=\"border:none;border-top:1px solid #e2e6ee;margin:22px 0 12px;\">"
                + "<p style=\"font-size:11px;color:#9aa3ad;margin:0;\">"
                + "Mensaje automático del sistema de Bitácora Digital. No respondas a este correo.</p>"

                + "</div></div>";
    }

    private static String fila(String etiqueta, String valor) {
        return "<tr>"
                + "<td style=\"padding:7px 0;color:#5a6b85;width:40%;"
                + "border-bottom:1px solid #eef1f6;\">" + etiqueta + "</td>"
                + "<td style=\"padding:7px 0;font-weight:bold;"
                + "border-bottom:1px solid #eef1f6;\">" + valor + "</td>"
                + "</tr>";
    }

    private static String texto(Object valor) {
        return valor == null ? "No especificado" : String.valueOf(valor);
    }

    /**
     * Escapa el HTML. Tanto la descripción del alumno como el comentario del
     * docente son texto libre: sin esto, alguien podría inyectar etiquetas
     * en el correo que recibe el administrador.
     */
    private static String escapar(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                // Los saltos de línea del textarea se respetan en el correo.
                .replace("\n", "<br>");
    }

    private static String extension(File archivo) {
        String nombre = archivo.getName();
        int punto = nombre.lastIndexOf('.');
        return (punto >= 0) ? nombre.substring(punto) : ".jpg";
    }
}