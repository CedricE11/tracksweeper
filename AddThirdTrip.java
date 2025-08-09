import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AddThirdTrip {
    
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
            
            // Find the existing device
            long deviceId = findDemoDevice(conn);
            if (deviceId == -1) {
                System.err.println("Demo device not found!");
                return;
            }
            System.out.println("Found demo device with ID: " + deviceId);
            
            // Generate Trip 3: Oakland to Berkeley (evening trip)
            System.out.println("\nGenerating Trip 3: Oakland to Berkeley");
            List<Position> trip3 = generateTrip3();
            long trip3StartPosId = insertPositions(conn, deviceId, trip3);
            createTripEvents(conn, deviceId, trip3StartPosId, trip3StartPosId + trip3.size() - 1, trip3.get(0).timestamp, trip3.get(trip3.size()-1).timestamp);
            
            // Update device with last position
            updateDeviceLastPosition(conn, deviceId, trip3StartPosId + trip3.size() - 1);
            
            conn.close();
            System.out.println("\nThird trip (Oakland to Berkeley) added successfully!");
            System.out.println("You now have three distinct trips for testing multi-select functionality.");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static long findDemoDevice(Connection conn) throws SQLException {
        String sql = "SELECT id FROM tc_devices WHERE uniqueid = 'demo123'";
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            long deviceId = rs.getLong("id");
            stmt.close();
            return deviceId;
        }
        stmt.close();
        return -1;
    }
    
    private static List<Position> generateTrip3() {
        List<Position> positions = new ArrayList<>();
        LocalDateTime startTime = LocalDateTime.now().minusDays(1).withHour(18).withMinute(15).withSecond(0);
        
        // Trip 3: Oakland to Berkeley (Bay Bridge and University Ave route)
        // This route goes north/northeast, distinct from the previous south/southeast routes
        double[][] route = {
            {37.8044, -122.2711, 0},    // Oakland start (downtown)
            {37.8144, -122.2811, 15},   // Leaving downtown
            {37.8244, -122.2911, 25},   // City streets
            {37.8344, -122.3011, 35},   // Approaching freeway
            {37.8444, -122.3111, 45},   // On freeway (I-80 West)
            {37.8544, -122.3211, 50},   // Bay Bridge approach
            {37.8644, -122.3311, 40},   // Bridge traffic
            {37.8744, -122.3411, 35},   // Crossing bay
            {37.8844, -122.3511, 45},   // Exiting bridge
            {37.8944, -122.3611, 40},   // Berkeley approach
            {37.9044, -122.3711, 30},   // University Ave
            {37.9144, -122.3811, 25},   // Campus area
            {37.9244, -122.3911, 15},   // Residential streets
            {37.9344, -122.4011, 10},   // Approaching destination
            {37.9444, -122.4111, 5},    // Parking area
            {37.9544, -122.4211, 0}     // Berkeley destination (near UC Berkeley)
        };
        
        for (int i = 0; i < route.length; i++) {
            double course = i < route.length - 1 ? calculateCourse(route[i], route[i+1]) : 0;
            positions.add(new Position(
                route[i][0], 
                route[i][1], 
                route[i][2], 
                course,
                startTime.plusMinutes(i * 2) // 2-minute intervals for a shorter trip
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
            stmt.setDouble(9, 150.0); // altitude (slightly higher for Berkeley hills)
            stmt.setDouble(10, pos.speed);
            stmt.setDouble(11, pos.course);
            stmt.setString(12, "{}");
            stmt.setDouble(13, 8.0); // accuracy
            
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
