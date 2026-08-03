package com.example.integradora_smca.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class SQLConnector {

    private static HikariDataSource dataSource;

    static {
        try {
            ClassLoader classLoader = SQLConnector.class.getClassLoader();

            URL walletUrl = classLoader.getResource("wallet/");
            if (walletUrl == null) {
                throw new RuntimeException("Error: No se encontró la carpeta 'wallet/' en recursos.");
            }

            File walletFile = new File(walletUrl.toURI());
            String walletPath = walletFile.getAbsolutePath().replace("\\", "/");

            if (walletPath.startsWith("/") && walletPath.contains(":")) {
                walletPath = walletPath.substring(1);
            }

            System.setProperty("oracle.net.tns_admin", walletPath);
            System.setProperty("oracle.jdbc.fanEnabled", "false");

            String dbUser = System.getenv("DB_USER");
            String dbPass = System.getenv("DB_PASS");
            String dbName = System.getenv("DB_NAME");

            if (dbUser == null || dbPass == null || dbName == null) {
                Properties creds = new Properties();
                try (InputStream is = classLoader.getResourceAsStream("credentials.properties")) {
                    if (is != null) {
                        creds.load(is);
                        if (dbUser == null) dbUser = creds.getProperty("db.user");
                        if (dbPass == null) dbPass = creds.getProperty("db.pass");
                        if (dbName == null) dbName = creds.getProperty("db.name");
                    }
                }
            }

            HikariConfig config = new HikariConfig();
            config.setDriverClassName("oracle.jdbc.OracleDriver");
            config.setJdbcUrl("jdbc:oracle:thin:@" + dbName);
            config.setUsername(dbUser);
            config.setPassword(dbPass);

            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);

            dataSource = new HikariDataSource(config);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("El DataSource no está inicializado.");
        }
        return dataSource.getConnection();
    }
}