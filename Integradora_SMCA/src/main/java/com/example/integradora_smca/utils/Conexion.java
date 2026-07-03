package com.example.integradora_smca.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class Conexion {

    private static HikariDataSource dataSource;

    static {
        try {
            ClassLoader classLoader = Conexion.class.getClassLoader();

            // 1. Localizar la carpeta wallet
            URL walletUrl = classLoader.getResource("wallet/");
            if (walletUrl == null) {
                throw new RuntimeException("Error: No se encontró la carpeta 'wallet/' en los recursos (src/main/resources).");
            }

            // 2. Obtener la ruta absoluta y sanitizarla para evitar errores de sintaxis en Windows
            File walletFile = new File(walletUrl.toURI());
            String walletPath = walletFile.getAbsolutePath().replace("\\", "/");

            // Si la ruta en Windows inicia con algo como /C:/... debido a la conversión URI, limpiamos la barra inicial
            if (walletPath.startsWith("/") && walletPath.contains(":")) {
                walletPath = walletPath.substring(1);
            }

            // Configurar propiedades globales del sistema para el driver de Oracle
            System.setProperty("oracle.net.tns_admin", walletPath);
            System.setProperty("oracle.jdbc.fanEnabled", "false"); // Deshabilita FAN para conexiones rápidas Cloud

            // 3. Cargar credenciales desde variables de entorno o archivo properties
            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASS");
            String dbName = System.getenv("DB_NAME");

            if (dbUser == null || dbPass == null || dbName == null) {
                System.out.println("Advertencia: Faltan variables de entorno de la BD. Buscando en credentials.properties...");
                Properties creds = new Properties();

                try (InputStream is = classLoader.getResourceAsStream("credentials.properties")) {
                    if (is == null) {
                        throw new RuntimeException("No se encontró el archivo credentials.properties en src/main/resources ni las variables de entorno.");
                    }
                    creds.load(is);

                    if (dbUser == null) dbUser = creds.getProperty("db.user");
                    if (dbPass == null) dbPass = creds.getProperty("db.pass");
                    if (dbName == null) dbName = creds.getProperty("db.name");
                }
            }

            if (dbName == null || dbUser == null || dbPass == null) {
                throw new RuntimeException("Configuración incompleta: db.user, db.pass o db.name no definidos.");
            }

            // 4. Configurar el Pool de Conexiones HikariCP
            HikariConfig config = new HikariConfig();
            config.setDriverClassName("oracle.jdbc.OracleDriver");

            // Se deja la URL limpia de EZConnect, el driver detectará TNS_ADMIN desde la propiedad del sistema automáticamente
            config.setJdbcUrl("jdbc:oracle:thin:@" + dbName);
            config.setUsername(dbUser);
            config.setPassword(dbPass);

            // Configuraciones de rendimiento del Pool
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setConnectionTimeout(20000);
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
            System.out.println("¡Pool de conexiones a Oracle Cloud inicializado con éxito!");

        } catch (Exception e) {
            System.err.println("Error crítico al inicializar la base de datos");
            e.printStackTrace();
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConexion() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("El DataSource no está inicializado.");
        }
        return dataSource.getConnection();
    }

    public static void closeConexion() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}