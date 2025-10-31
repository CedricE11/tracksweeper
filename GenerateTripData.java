import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class GenerateTripData {
    
    static class Position {
        double latitude;
        double longitude;
        double speed;
        double course;
        LocalDateTime timestamp;
        
        Position(double lat, double lon, double speed, double course, LocalDateTime timestamp) {
            this.latitude = lat;
            this.longitude = lon;
            this.speed = speed;
            this.course = course;
            this.timestamp = timestamp;
        }
    }
    
    public static void main(String[] args) {
        String dbUrl = "jdbc:h2:./target/database";
        String dbUser = "sa";
        String dbPassword = "";
        
        try {
            Class.forName("org.h2.Driver");
            Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            System.out.println("Connected to database successfully");
            
            // Get or create admin user
            long userId = getOrCreateAdminUser(conn);
            System.out.println("Using user ID: " + userId);
            
            // Create first test device
            long deviceId1 = createTestDevice(conn, "Demo Vehicle", "demo123");
            System.out.println("Created test device 1 with ID: " + deviceId1);
            
            // Create second test device
            long deviceId2 = createTestDevice(conn, "Demo Vehicle 2", "demo456");
            System.out.println("Created test device 2 with ID: " + deviceId2);
            
            // Assign devices to user
            assignDeviceToUser(conn, userId, deviceId1);
            assignDeviceToUser(conn, userId, deviceId2);
            System.out.println("Assigned devices to user");
            
            // Generate Trip 1: San Francisco to Oakland (morning commute)
            System.out.println("\nGenerating Trip 1: San Francisco to Oakland (Device 1)");
            List<Position> trip1 = generateTrip1();
            long trip1StartPosId = insertPositions(conn, deviceId1, trip1);
            createTripEvents(conn, deviceId1, trip1StartPosId, trip1StartPosId + trip1.size() - 1, trip1.get(0).timestamp, trip1.get(trip1.size()-1).timestamp);
            
            // Generate Trip 2: Oakland to San Jose (afternoon trip)
            System.out.println("Generating Trip 2: Oakland to San Jose (Device 1)");
            List<Position> trip2 = generateTrip2();
            long trip2StartPosId = insertPositions(conn, deviceId1, trip2);
            createTripEvents(conn, deviceId1, trip2StartPosId, trip2StartPosId + trip2.size() - 1, trip2.get(0).timestamp, trip2.get(trip2.size()-1).timestamp);
            
            // Generate Trip 3: Los Angeles to Santa Monica (Device 2)
            System.out.println("Generating Trip 3: Los Angeles to Santa Monica (Device 2)");
            List<Position> trip3 = generateTrip3();
            long trip3StartPosId = insertPositions(conn, deviceId2, trip3);
            createTripEvents(conn, deviceId2, trip3StartPosId, trip3StartPosId + trip3.size() - 1, trip3.get(0).timestamp, trip3.get(trip3.size()-1).timestamp);
            
            // Generate Trip 4: Santa Monica to Beverly Hills (Device 2)
            System.out.println("Generating Trip 4: Santa Monica to Beverly Hills (Device 2)");
            List<Position> trip4 = generateTrip4();
            long trip4StartPosId = insertPositions(conn, deviceId2, trip4);
            createTripEvents(conn, deviceId2, trip4StartPosId, trip4StartPosId + trip4.size() - 1, trip4.get(0).timestamp, trip4.get(trip4.size()-1).timestamp);
            
            // Update devices with last positions
            updateDeviceLastPosition(conn, deviceId1, trip2StartPosId + trip2.size() - 1);
            updateDeviceLastPosition(conn, deviceId2, trip4StartPosId + trip4.size() - 1);
            
            conn.close();
            System.out.println("\nTrip data generation completed successfully!");
            System.out.println("You can now view the trips in the TrackSweeper Reports > Trips section.");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static long getOrCreateAdminUser(Connection conn) throws SQLException {
        // Check if admin user exists
        String selectSql = "SELECT id FROM tc_users WHERE administrator = true LIMIT 1";
        PreparedStatement selectStmt = conn.prepareStatement(selectSql);
        ResultSet rs = selectStmt.executeQuery();
        
        if (rs.next()) {
            long userId = rs.getLong(1);
            selectStmt.close();
            return userId;
        }
        selectStmt.close();
        
        // Create admin user if doesn't exist
        String insertSql = "INSERT INTO tc_users (name, email, hashedpassword, salt, administrator, attributes) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement insertStmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
        insertStmt.setString(1, "admin");
        insertStmt.setString(2, "admin");
        insertStmt.setString(3, "D33E22AE348AEB5660FC2140AEC35850C4DA997"); // Placeholder hash
        insertStmt.setString(4, "000000000000000000000000000000000000000000000000000000000000"); // Placeholder salt
        insertStmt.setBoolean(5, true);
        insertStmt.setString(6, "{}");
        
        insertStmt.executeUpdate();
        ResultSet keys = insertStmt.getGeneratedKeys();
        keys.next();
        long userId = keys.getLong(1);
        insertStmt.close();
        return userId;
    }
    
    private static void assignDeviceToUser(Connection conn, long userId, long deviceId) throws SQLException {
        String sql = "INSERT INTO tc_user_device (userid, deviceid) VALUES (?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setLong(1, userId);
        stmt.setLong(2, deviceId);
        stmt.executeUpdate();
        stmt.close();
    }
    
    private static long createTestDevice(Connection conn, String name, String uniqueId) throws SQLException {
        String sql = "INSERT INTO tc_devices (name, uniqueid, attributes, disabled, status) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, name);
        stmt.setString(2, uniqueId);
        stmt.setString(3, "{}");
        stmt.setBoolean(4, false);
        stmt.setString(5, "online");
        
        stmt.executeUpdate();
        ResultSet keys = stmt.getGeneratedKeys();
        keys.next();
        long deviceId = keys.getLong(1);
        stmt.close();
        return deviceId;
    }
    
    private static List<Position> generateTrip1() {
        List<Position> positions = new ArrayList<>();
        LocalDateTime startTime = LocalDateTime.now().minusDays(5).withHour(8).withMinute(0).withSecond(0);
        
        // Trip 1: San Francisco to Oakland (Golden Gate Bridge route)
        double[][] route = {
            {37.7749, -122.4194, 0},    // San Francisco start
            {37.7849, -122.4094, 25},   // Moving north
            {37.7949, -122.3994, 35},   // Accelerating
            {37.8049, -122.3894, 45},   // Highway speed
            {37.8149, -122.3794, 50},   // Crossing bridge
            {37.8249, -122.3694, 45},   // Bridge traffic
            {37.8349, -122.3594, 40},   // Exiting bridge
            {37.8449, -122.3494, 35},   // City streets
            {37.8549, -122.3394, 30},   // Slowing down
            {37.8649, -122.3294, 20},   // Approaching destination
            {37.8749, -122.3194, 10},   // Parking
            {37.8849, -122.3094, 0}     // Oakland destination
        };
        
        for (int i = 0; i < route.length; i++) {
            double course = i < route.length - 1 ? calculateCourse(route[i], route[i+1]) : 0;
            positions.add(new Position(
                route[i][0], 
                route[i][1], 
                route[i][2], 
                course,
                startTime.plusMinutes(i * 3)
            ));
        }
        
        return positions;
    }
    
    private static List<Position> generateTrip2() {
        List<Position> positions = new ArrayList<>();
        LocalDateTime startTime = LocalDateTime.now().minusDays(5).withHour(14).withMinute(30).withSecond(0);
        
        // Trip 2: Oakland to San Jose (Highway 880 route)
        double[][] route = {
            {37.8849, -122.3094, 0},    // Oakland start
            {37.8749, -122.3194, 20},   // Leaving parking
            {37.8649, -122.3294, 35},   // City streets
            {37.8549, -122.3394, 45},   // Entering highway
            {37.8449, -122.3494, 60},   // Highway speed
            {37.8349, -122.3594, 65},   // Cruising
            {37.8249, -122.3694, 70},   // Fast section
            {37.8149, -122.3794, 65},   // Traffic
            {37.8049, -122.3894, 55},   // Slowing
            {37.7949, -122.3994, 45},   // City approach
            {37.7849, -122.4094, 35},   // Surface streets
            {37.7749, -122.4194, 25},   // Neighborhood
            {37.7649, -122.4294, 15},   // Approaching destination
            {37.7549, -122.4394, 5},    // Parking
            {37.7449, -122.4494, 0}     // San Jose destination
        };
        
        for (int i = 0; i < route.length; i++) {
            double course = i < route.length - 1 ? calculateCourse(route[i], route[i+1]) : 0;
            positions.add(new Position(
                route[i][0], 
                route[i][1], 
                route[i][2], 
                course,
                startTime.plusMinutes(i * 4)
            ));
        }
        
        return positions;
    }
    
    private static List<Position> generateTrip3() {
        List<Position> positions = new ArrayList<>();
        LocalDateTime startTime = LocalDateTime.now().minusDays(10).withHour(9).withMinute(15).withSecond(0);
        
        // Trip 3: Los Angeles to Santa Monica (Pacific Coast Highway route)
        double[][] route = {
            {34.0522, -118.2437, 0},    // Los Angeles start
            {34.0622, -118.2537, 20},   // Moving west
            {34.0722, -118.2637, 35},   // City streets
            {34.0822, -118.2737, 45},   // Highway approach
            {34.0922, -118.2837, 55},   // Highway speed
            {34.1022, -118.2937, 60},   // Cruising
            {34.1122, -118.3037, 55},   // Traffic
            {34.1222, -118.3137, 45},   // Approaching coast
            {34.1322, -118.3237, 35},   // Coastal roads
            {34.1422, -118.3337, 25},   // Santa Monica approach
            {34.1522, -118.3437, 15},   // City streets
            {34.1622, -118.3537, 5},    // Parking
            {34.1722, -118.3637, 0}     // Santa Monica destination
        };
        
        for (int i = 0; i < route.length; i++) {
            double course = i < route.length - 1 ? calculateCourse(route[i], route[i+1]) : 0;
            positions.add(new Position(
                route[i][0], 
                route[i][1], 
                route[i][2], 
                course,
                startTime.plusMinutes(i * 4)
            ));
        }
        
        return positions;
    }
    
    private static List<Position> generateTrip4() {
        List<Position> positions = new ArrayList<>();
        LocalDateTime startTime = LocalDateTime.now().minusDays(10).withHour(16).withMinute(45).withSecond(0);
        
        // Trip 4: Santa Monica to Beverly Hills (Sunset Boulevard route)
        double[][] route = {
            {34.1722, -118.3637, 0},    // Santa Monica start
            {34.1622, -118.3537, 15},   // Leaving parking
            {34.1522, -118.3437, 25},   // City streets
            {34.1422, -118.3337, 35},   // Sunset Boulevard
            {34.1322, -118.3237, 40},   // Main road
            {34.1222, -118.3137, 35},   // Traffic
            {34.1122, -118.3037, 30},   // Approaching Beverly Hills
            {34.1022, -118.2937, 25},   // Rodeo Drive area
            {34.0922, -118.2837, 20},   // Beverly Hills streets
            {34.0822, -118.2737, 15},   // Residential area
            {34.0722, -118.2637, 10},   // Approaching destination
            {34.0622, -118.2537, 5},    // Parking
            {34.0522, -118.2437, 0}     // Beverly Hills destination
        };
        
        for (int i = 0; i < route.length; i++) {
            double course = i < route.length - 1 ? calculateCourse(route[i], route[i+1]) : 0;
            positions.add(new Position(
                route[i][0], 
                route[i][1], 
                route[i][2], 
                course,
                startTime.plusMinutes(i * 3)
            ));
        }
        
        return positions;
    }
    
    private static double calculateCourse(double[] from, double[] to) {
        double deltaLon = to[1] - from[1];
        double deltaLat = to[0] - from[0];
        double bearing = Math.atan2(deltaLon, deltaLat);
        return (Math.toDegrees(bearing) + 360) % 360;
    }
    
    private static long insertPositions(Connection conn, long deviceId, List<Position> positions) throws SQLException {
        String sql = "INSERT INTO tc_positions (protocol, deviceid, servertime, devicetime, fixtime, valid, latitude, longitude, altitude, speed, course, attributes, accuracy) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        
        long firstPositionId = -1;
        
        for (Position pos : positions) {
            Timestamp timestamp = Timestamp.valueOf(pos.timestamp);
            
            stmt.setString(1, "demo");
            stmt.setLong(2, deviceId);
            stmt.setTimestamp(3, timestamp);
            stmt.setTimestamp(4, timestamp);
            stmt.setTimestamp(5, timestamp);
            stmt.setBoolean(6, true);
            stmt.setDouble(7, pos.latitude);
            stmt.setDouble(8, pos.longitude);
            stmt.setDouble(9, 100.0); // altitude
            stmt.setDouble(10, pos.speed);
            stmt.setDouble(11, pos.course);
            stmt.setString(12, "{}");
            stmt.setDouble(13, 10.0); // accuracy
            
            stmt.executeUpdate();
            
            if (firstPositionId == -1) {
                ResultSet keys = stmt.getGeneratedKeys();
                if (keys.next()) {
                    firstPositionId = keys.getLong(1);
                }
            }
        }
        
        stmt.close();
        System.out.println("Inserted " + positions.size() + " positions");
        return firstPositionId;
    }
    
    private static void createTripEvents(Connection conn, long deviceId, long startPosId, long endPosId, LocalDateTime startTime, LocalDateTime endTime) throws SQLException {
        // Create trip start event
        String sql = "INSERT INTO tc_events (type, eventtime, deviceid, positionid, attributes) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        
        stmt.setString(1, "deviceMoving");
        stmt.setTimestamp(2, Timestamp.valueOf(startTime));
        stmt.setLong(3, deviceId);
        stmt.setLong(4, startPosId);
        stmt.setString(5, "{}");
        stmt.executeUpdate();
        
        // Create trip end event
        stmt.setString(1, "deviceStopped");
        stmt.setTimestamp(2, Timestamp.valueOf(endTime));
        stmt.setLong(3, deviceId);
        stmt.setLong(4, endPosId);
        stmt.setString(5, "{}");
        stmt.executeUpdate();
        
        stmt.close();
        System.out.println("Created trip events (start/stop)");
    }
    
    private static void updateDeviceLastPosition(Connection conn, long deviceId, long lastPositionId) throws SQLException {
        String sql = "UPDATE tc_devices SET positionid = ?, lastupdate = ? WHERE id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setLong(1, lastPositionId);
        stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
        stmt.setLong(3, deviceId);
        stmt.executeUpdate();
        stmt.close();
        System.out.println("Updated device last position");
    }
}
