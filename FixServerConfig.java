import java.sql.*;

public class FixServerConfig {
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
            
            // Check if server record exists
            String checkSql = "SELECT COUNT(*) FROM tc_servers";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);
            System.out.println("Current server records: " + count);
            
            if (count == 0) {
                // Insert server configuration record
                String insertSql = "INSERT INTO tc_servers (id, registration, readonly, deviceReadonly, limitCommands, disableReports, fixedEmail, forceSettings, coordinateFormat, attributes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, 1);
                insertStmt.setBoolean(2, true);  // registration
                insertStmt.setBoolean(3, false); // readonly
                insertStmt.setBoolean(4, false); // deviceReadonly
                insertStmt.setBoolean(5, false); // limitCommands
                insertStmt.setBoolean(6, false); // disableReports
                insertStmt.setBoolean(7, false); // fixedEmail
                insertStmt.setBoolean(8, false); // forceSettings
                insertStmt.setString(9, "dd");   // coordinateFormat
                insertStmt.setString(10, "{}");  // attributes (empty JSON)
                
                int result = insertStmt.executeUpdate();
                System.out.println("Server configuration inserted successfully: " + result + " row(s) affected");
                insertStmt.close();
            } else {
                System.out.println("Server configuration already exists");
            }
            
            // Verify the record
            String selectSql = "SELECT * FROM tc_servers";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            ResultSet selectRs = selectStmt.executeQuery();
            while (selectRs.next()) {
                System.out.println("Server ID: " + selectRs.getInt("id"));
                System.out.println("Registration: " + selectRs.getBoolean("registration"));
                System.out.println("Coordinate Format: " + selectRs.getString("coordinateFormat"));
            }
            selectStmt.close();
            
            checkStmt.close();
            conn.close();
            System.out.println("Database connection closed");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
