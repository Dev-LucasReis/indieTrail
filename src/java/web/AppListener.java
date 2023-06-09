package web;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import model.User;
import model.GamesIndie;
import org.json.JSONArray;
import org.json.JSONObject;
import java.time.Duration;
import java.time.Instant;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.Date;
import java.sql.*;
import java.security.*;
import java.math.*;


@WebListener
public class AppListener implements ServletContextListener {
    public static final String CLASS_NAME = "org.sqlite.JDBC";
    public static final String URL = "jdbc:sqlite:gamesindieapp.db";
    public static String initializeLog = "";
    public static Exception exception = null;

    @Override
    public void contextDestroyed(ServletContextEvent sce) {

    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Connection c = AppListener.getConnection();
            Statement s = c.createStatement();
            initializeLog += new Date() + ": Initializing database creation; ";
            // USERS
            initializeLog += "Creating Users table if not exists...";
            s.execute(User.getCreateStatement());
            initializeLog += "done; ";
            if (User.getUsers().isEmpty()) {
                initializeLog += "Adding default users...";
                User.insertUser("admin", "Administrador", "ADMIN", "1234");
                initializeLog += "Admin added; ";
                User.insertUser("fulano", "Fulano da Silva", "USER", "1234");
                initializeLog += "Fulano added; ";
            }
            // GAMES
            initializeLog += "Creating GamesIndie table if not exists...";
            s.execute(GamesIndie.getCreateStatement());
            initializeLog += "done.";
            s.close();
            c.close();
        } catch (Exception ex) {
            initializeLog += "Error: " + ex.getMessage();
        }
    }

    public static String getMd5Hash(String text) throws NoSuchAlgorithmException {
        MessageDigest m = MessageDigest.getInstance("MD5");
        m.update(text.getBytes(), 0, text.length());
        return new BigInteger(1, m.digest()).toString();
    }

    public static Connection getConnection() throws Exception {
        Class.forName(CLASS_NAME);
        return DriverManager.getConnection(URL);
    }
}

