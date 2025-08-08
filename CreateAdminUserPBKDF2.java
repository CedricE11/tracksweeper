import java.sql.*;
import java.security.SecureRandom;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

public class CreateAdminUserPBKDF2 {
    
    // TrackSweeper hashing constants (from Hashing.java)
    private static final int ITERATIONS = 1000;
    private static final int SALT_SIZE = 24;
    private static final int HASH_SIZE = 24;
    
    private static SecretKeyFactory factory;
    static {
        try {
            factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }
    
    // Hex encoding method (from DataConverter.java)
    private static String printHex(byte[] data) {
        StringBuilder sb = new StringBuilder();
        for (byte b : data) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
    
    // PBKDF2 hashing function (from Hashing.java)
    private static byte[] function(char[] password, byte[] salt) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, ITERATIONS, HASH_SIZE * Byte.SIZE);
            return factory.generateSecret(spec).getEncoded();
        } catch (InvalidKeySpecException e) {
            throw new SecurityException(e);
        }
    }
    
    // Create hash with salt (from Hashing.java)
    private static class HashingResult {
        private final String hash;
        private final String salt;
        
        public HashingResult(String hash, String salt) {
            this.hash = hash;
            this.salt = salt;
        }
        
        public String getHash() { return hash; }
        public String getSalt() { return salt; }
    }
    
    private static HashingResult createHash(String password) {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_SIZE];
        random.nextBytes(salt);
        byte[] hash = function(password.toCharArray(), salt);
        return new HashingResult(
            printHex(hash),
            printHex(salt));
    }

    public static void main(String[] args) {
        String dbUrl = "jdbc:h2:./target/database";
        String dbUser = "sa";
        String dbPassword = "";
        
        try {
            // Load H2 driver
            Class.forName("org.h2.Driver");
            
            // Connect to database
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            System.out.println("Connected to database successfully");
            
            // Check if admin user already exists
            String checkSql = "SELECT COUNT(*) FROM tc_users WHERE login = 'admin'";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int existingAdmins = rs.getInt(1);
            System.out.println("Existing admin users: " + existingAdmins);
            
            if (existingAdmins > 0) {
                // Delete existing admin user first
                String deleteSql = "DELETE FROM tc_users WHERE login = 'admin'";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                int deletedRows = deleteStmt.executeUpdate();
                System.out.println("Deleted existing admin user: " + deletedRows + " row(s)");
                deleteStmt.close();
            }
            
            // Create password hash using TrackSweeper's PBKDF2 algorithm
            String password = "admin";
            HashingResult hashResult = createHash(password);
            String hashedPassword = hashResult.getHash();
            String salt = hashResult.getSalt();
            
            System.out.println("Password hashed successfully with PBKDF2");
            System.out.println("Hash: " + hashedPassword);
            System.out.println("Salt: " + salt);
            
            // Insert admin user with correct column names and PBKDF2 hash
            String insertSql = "INSERT INTO tc_users (name, email, login, hashedpassword, salt, administrator, map, latitude, longitude, zoom, coordinateformat, disabled, expirationtime, devicelimit, userlimit, devicereadonly, readonly, limitcommands, disablereports, fixedemail, poilayer, attributes, phone, temporary) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            insertStmt.setString(1, "Administrator");     // name
            insertStmt.setString(2, "admin@traccar.org"); // email
            insertStmt.setString(3, "admin");             // login
            insertStmt.setString(4, hashedPassword);      // hashedpassword (PBKDF2)
            insertStmt.setString(5, salt);                // salt (hex encoded)
            insertStmt.setBoolean(6, true);               // administrator
            insertStmt.setString(7, "osm");               // map
            insertStmt.setDouble(8, 0.0);                 // latitude
            insertStmt.setDouble(9, 0.0);                 // longitude
            insertStmt.setInt(10, 0);                     // zoom
            insertStmt.setString(11, "dd");               // coordinateformat
            insertStmt.setBoolean(12, false);             // disabled
            insertStmt.setNull(13, Types.TIMESTAMP);      // expirationtime
            insertStmt.setInt(14, -1);                    // devicelimit
            insertStmt.setInt(15, -1);                    // userlimit
            insertStmt.setBoolean(16, false);             // devicereadonly
            insertStmt.setBoolean(17, false);             // readonly
            insertStmt.setBoolean(18, false);             // limitcommands
            insertStmt.setBoolean(19, false);             // disablereports
            insertStmt.setBoolean(20, false);             // fixedemail
            insertStmt.setString(21, "");                 // poilayer
            insertStmt.setString(22, "{}");               // attributes (JSON)
            insertStmt.setString(23, "");                 // phone
            insertStmt.setBoolean(24, false);             // temporary
            
            int rowsAffected = insertStmt.executeUpdate();
            System.out.println("Admin user created successfully: " + rowsAffected + " row(s) affected");
            
            // Get the generated user ID
            ResultSet generatedKeys = insertStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                long userId = generatedKeys.getLong(1);
                System.out.println("User ID: " + userId);
            }
            
            // Verify the user was created correctly
            String verifySql = "SELECT id, name, login, administrator FROM tc_users WHERE login = 'admin'";
            PreparedStatement verifyStmt = conn.prepareStatement(verifySql);
            ResultSet verifyRs = verifyStmt.executeQuery();
            if (verifyRs.next()) {
                System.out.println("Name: " + verifyRs.getString("name"));
                System.out.println("Login: " + verifyRs.getString("login"));
                System.out.println("Administrator: " + verifyRs.getBoolean("administrator"));
            }
            
            verifyStmt.close();
            insertStmt.close();
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
