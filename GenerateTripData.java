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
            
            // Create a test device first
            long deviceId = createTestDevice(conn);
            System.out.println("Created test device with ID: " + deviceId);
            
            // Generate Trip 1: San Francisco to Oakland (morning commute)
            System.out.println("\nGenerating Trip 1: San Francisco to Oakland");
            List<Position> trip1 = generateTrip1();
            long trip1StartPosId = insertPositions(conn, deviceId, trip1);
            createTripEvents(conn, deviceId, trip1StartPosId, trip1StartPosId + trip1.size() - 1, trip1.get(0).timestamp, trip1.get(trip1.size()-1).timestamp);
            
            // Generate Trip 2: Oakland to San Jose (afternoon trip)
            System.out.println("Generating Trip 2: Oakland to San Jose");
            List<Position> trip2 = generateTrip2();
            long trip2StartPosId = insertPositions(conn, deviceId, trip2);
            createTripEvents(conn, deviceId, trip2StartPosId, trip2StartPosId + trip2.size() - 1, trip2.get(0).timestamp, trip2.get(trip2.size()-1).timestamp);
            
            // Update device with last position
            updateDeviceLastPosition(conn, deviceId, trip2StartPosId + trip2.size() - 1);
            
            conn.close();
            System.out.println("\nTrip data generation completed successfully!");
            System.out.println("You can now view the trips in the TrackSweeper Reports > Trips section.");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static long createTestDevice(Connection conn) throws SQLException {
        String sql = "INSERT INTO tc_devices (name, uniqueid, attributes, disabled, status) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, "Demo Vehicle");
        stmt.setString(2, "demo123");
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
        LocalDateTime startTime = LocalDateTime.now().minusDays(1).withHour(8).withMinute(0).withSecond(0);
        
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
        LocalDateTime startTime = LocalDateTime.now().minusDays(1).withHour(14).withMinute(30).withSecond(0);
        
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
