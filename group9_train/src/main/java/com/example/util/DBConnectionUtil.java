package com.example.util;

import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;

public class DBConnectionUtil {
    private static DataSource dataSource;

    static {
        try {
            InitialContext ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/TrainDB");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize DataSource.");
        }
    }

    public static Connection getConnection() throws Exception {
        return dataSource.getConnection();
    }
}
