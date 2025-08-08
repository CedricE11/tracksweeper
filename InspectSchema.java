import java.sql.*;

public class InspectSchema {
    public static void main(String[] args) {
        String dbUrl = "jdbc:h2:./target/database";
        String dbUser = "sa";
        String dbPassword = "";
        
        try {
            Class.forName("org.h2.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            System.out.println("Connected to database successfully");
            
            // Check devices table structure
            System.out.println("\n=== TC_DEVICES TABLE STRUCTURE ===");
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(null, null, "TC_DEVICES", null);
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                boolean nullable = columns.getBoolean("NULLABLE");
                System.out.println(columnName + " - " + dataType + "(" + columnSize + ") " + (nullable ? "NULL" : "NOT NULL"));
            }
            
            // Check positions table structure
            System.out.println("\n=== TC_POSITIONS TABLE STRUCTURE ===");
            columns = metaData.getColumns(null, null, "TC_POSITIONS", null);
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                boolean nullable = columns.getBoolean("NULLABLE");
                System.out.println(columnName + " - " + dataType + "(" + columnSize + ") " + (nullable ? "NULL" : "NOT NULL"));
            }
            
            // Check events table structure
            System.out.println("\n=== TC_EVENTS TABLE STRUCTURE ===");
            columns = metaData.getColumns(null, null, "TC_EVENTS", null);
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                boolean nullable = columns.getBoolean("NULLABLE");
                System.out.println(columnName + " - " + dataType + "(" + columnSize + ") " + (nullable ? "NULL" : "NOT NULL"));
            }
            
            // Check existing devices
            System.out.println("\n=== EXISTING DEVICES ===");
            String devicesSql = "SELECT id, name, uniqueid FROM tc_devices";
            PreparedStatement devicesStmt = conn.prepareStatement(devicesSql);
            ResultSet devicesRs = devicesStmt.executeQuery();
            while (devicesRs.next()) {
                System.out.println("ID: " + devicesRs.getLong("id") + ", Name: " + devicesRs.getString("name") + ", UniqueID: " + devicesRs.getString("uniqueid"));
            }
            
            // Check existing positions count
            System.out.println("\n=== EXISTING POSITIONS COUNT ===");
            String positionsSql = "SELECT COUNT(*) as count FROM tc_positions";
            PreparedStatement positionsStmt = conn.prepareStatement(positionsSql);
            ResultSet positionsRs = positionsStmt.executeQuery();
            if (positionsRs.next()) {
                System.out.println("Total positions: " + positionsRs.getInt("count"));
            }
            
            conn.close();
            System.out.println("\nDatabase connection closed");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
