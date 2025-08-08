import java.sql.*;

public class CheckSchema {
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
            
            // Get table schema for tc_users
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet columns = metaData.getColumns(null, null, "TC_USERS", null);
            
            System.out.println("TC_USERS table columns:");
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String dataType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                String isNullable = columns.getString("IS_NULLABLE");
                
                System.out.println("Column: " + columnName + 
                                 ", Type: " + dataType + 
                                 ", Size: " + columnSize + 
                                 ", Nullable: " + isNullable);
            }
            
            columns.close();
            conn.close();
            System.out.println("Database connection closed");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
