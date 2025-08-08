import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class CreateAdminUserFixed {
    
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        StringBuilder sb = new StringBuilder();
        for (byte b : salt) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
    
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            String combined = password + salt;
            byte[] hashedBytes = md.digest(combined.getBytes());
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
                // Generate salt and hash the password
                String salt = generateSalt();
                String hashedPassword = hashPassword("admin", salt);
                System.out.println("Password hashed successfully with salt");
                
                // Insert admin user with correct column names
                String insertSql = "INSERT INTO tc_users (name, email, login, hashedpassword, salt, administrator, map, latitude, longitude, zoom, coordinateformat, disabled, expirationtime, devicelimit, userlimit, devicereadonly, readonly, limitcommands, disablereports, fixedemail, poilayer, attributes, phone, temporary) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setString(1, "Administrator");     // name
                insertStmt.setString(2, "admin@traccar.org"); // email
                insertStmt.setString(3, "admin");             // login
                insertStmt.setString(4, hashedPassword);      // hashedpassword
                insertStmt.setString(5, salt);                // salt
                insertStmt.setBoolean(6, true);               // administrator
                insertStmt.setString(7, "osm");               // map
                insertStmt.setDouble(8, 0.0);                 // latitude
                insertStmt.setDouble(9, 0.0);                 // longitude
                insertStmt.setInt(10, 2);                     // zoom
                insertStmt.setString(11, "dd");               // coordinateformat
                insertStmt.setBoolean(12, false);             // disabled
                insertStmt.setTimestamp(13, null);            // expirationtime
                insertStmt.setInt(14, -1);                    // devicelimit (-1 = unlimited)
                insertStmt.setInt(15, -1);                    // userlimit (-1 = unlimited)
                insertStmt.setBoolean(16, false);             // devicereadonly
                insertStmt.setBoolean(17, false);             // readonly
                insertStmt.setBoolean(18, false);             // limitcommands
                insertStmt.setBoolean(19, false);             // disablereports
                insertStmt.setBoolean(20, false);             // fixedemail
                insertStmt.setString(21, "");                 // poilayer
                insertStmt.setString(22, "{}");               // attributes (empty JSON)
                insertStmt.setString(23, "");                 // phone
                insertStmt.setBoolean(24, false);             // temporary
                
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
            System.out.println("\n=== ADMIN USER CREDENTIALS ===");
            System.out.println("Username: admin");
            System.out.println("Password: admin");
            System.out.println("==============================");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
