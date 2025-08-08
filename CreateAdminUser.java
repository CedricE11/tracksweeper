import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class CreateAdminUser {
    
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
    
    public static void main(String[] args) {
        String url = "jdbc:h2:./target/database";
        String user = "sa";
        String password = "";
        
        try {
            // Load H2 driver
            Class.forName("org.h2.Driver");
            
            // Connect to database
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to database successfully");
            
            // Check if admin user already exists
            String checkSql = "SELECT COUNT(*) FROM tc_users WHERE login = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, "admin");
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);
            System.out.println("Existing admin users: " + count);
            
            if (count == 0) {
                // Hash the password
                String hashedPassword = hashPassword("admin");
                System.out.println("Password hashed successfully");
                
                // Insert admin user
                String insertSql = "INSERT INTO tc_users (name, email, login, password, administrator, map, latitude, longitude, zoom, twelveHourFormat, coordinateFormat, disabled, expirationTime, deviceLimit, userLimit, deviceReadonly, readonly, limitCommands, disableReports, fixedEmail, poiLayer, attributes, phone, token) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setString(1, "Administrator");     // name
                insertStmt.setString(2, "admin@traccar.org"); // email
                insertStmt.setString(3, "admin");             // login
                insertStmt.setString(4, hashedPassword);      // password (hashed)
                insertStmt.setBoolean(5, true);               // administrator
                insertStmt.setString(6, "osm");               // map
                insertStmt.setDouble(7, 0.0);                 // latitude
                insertStmt.setDouble(8, 0.0);                 // longitude
                insertStmt.setInt(9, 2);                      // zoom
                insertStmt.setBoolean(10, false);             // twelveHourFormat
                insertStmt.setString(11, "dd");               // coordinateFormat
                insertStmt.setBoolean(12, false);             // disabled
                insertStmt.setTimestamp(13, null);            // expirationTime
                insertStmt.setInt(14, -1);                    // deviceLimit (-1 = unlimited)
                insertStmt.setInt(15, -1);                    // userLimit (-1 = unlimited)
                insertStmt.setBoolean(16, false);             // deviceReadonly
                insertStmt.setBoolean(17, false);             // readonly
                insertStmt.setBoolean(18, false);             // limitCommands
                insertStmt.setBoolean(19, false);             // disableReports
                insertStmt.setBoolean(20, false);             // fixedEmail
                insertStmt.setString(21, "");                 // poiLayer
                insertStmt.setString(22, "{}");               // attributes (empty JSON)
                insertStmt.setString(23, "");                 // phone
                insertStmt.setString(24, null);               // token
                
                int result = insertStmt.executeUpdate();
                System.out.println("Admin user created successfully: " + result + " row(s) affected");
                insertStmt.close();
            } else {
                System.out.println("Admin user already exists");
            }
            
            // Verify the user was created
            String selectSql = "SELECT id, name, login, administrator FROM tc_users WHERE login = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setString(1, "admin");
            ResultSet selectRs = selectStmt.executeQuery();
            while (selectRs.next()) {
                System.out.println("User ID: " + selectRs.getInt("id"));
                System.out.println("Name: " + selectRs.getString("name"));
                System.out.println("Login: " + selectRs.getString("login"));
                System.out.println("Administrator: " + selectRs.getBoolean("administrator"));
            }
            selectStmt.close();
            
            checkStmt.close();
            conn.close();
            System.out.println("Database connection closed");
            System.out.println("\nAdmin user credentials:");
            System.out.println("Username: admin");
            System.out.println("Password: admin");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
