<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="com.example.util.DBConnectionUtil,java.util.*"%>
<%@ include file="navbar.jsp" %>
<div class="container my-5">
    <h1 class="text-center mb-4">Train Schedules</h1>
    <div class="card p-4 shadow-sm">
        <form action="trainSchedules.jsp" method="get">
            <div class="mb-3">
                <label for="station" class="form-label">Station:</label>
                <select id="station" name="station" class="form-select" required>
                    <option value="" disabled selected>Select Station</option>
                    <% 
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = DBConnectionUtil.getConnection();
                            String query = "SELECT station_id, station_name FROM Station";
                            ps = conn.prepareStatement(query);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                int stationId = rs.getInt("station_id");
                                String stationName = rs.getString("station_name");
                    %>
                                <option value="<%= stationId %>"><%= stationName %></option>
                    <%      }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </select>
            </div>

            <button type="submit" class="btn btn-primary w-100">Search</button>
        </form>
    </div>

    <% if (request.getParameter("station") != null) {
        int stationId = Integer.parseInt(request.getParameter("station"));
        String selectedStationName = "";
    %>
    <div class="mt-5">
        
        <% 
            conn = null;
            ps = null;
            rs = null;

            try {
                conn = DBConnectionUtil.getConnection();
                // Get the station name based on the stationId
                String stationQuery = "SELECT station_name FROM Station WHERE station_id = ?";
                ps = conn.prepareStatement(stationQuery);
                ps.setInt(1, stationId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    selectedStationName = rs.getString("station_name"); // Assign station name to the variable
                }
                String query = "SELECT DISTINCT t.train_number, t.isExpress, t.directionToEnd, t.start_time, " +
                               "s1.station_name AS origin_name, tl.transit_id, tl.transit_name, tl.fare, " +
                               "TIMESTAMPADD(MINUTE, CASE WHEN t.directionToEnd = TRUE THEN ts1.local_time_offset ELSE " +
                               "(SELECT MAX(tsx.local_time_offset) FROM Transit_Stop tsx WHERE tsx.transit_id = ts1.transit_id) - ts1.local_time_offset END, t.start_time) AS arrival_time " +
                               "FROM Train t JOIN Transit_Stop ts1 ON t.transit_id = ts1.transit_id " +
                               "JOIN Station s1 ON ts1.station_id = s1.station_id " +
                               "JOIN Transit_Line tl ON t.transit_id = tl.transit_id " +
                               "WHERE ts1.station_id = ? " +
                               "ORDER BY arrival_time";
				
                ps = conn.prepareStatement(query);
                ps.setInt(1, stationId);
                rs = ps.executeQuery();
                %>
                <h2 class="mb-4">Schedules for trains passing through <%= selectedStationName %></h2>
                <%

                while (rs.next()) {
                    int trainNumber = rs.getInt("train_number");
                    boolean isExpress = rs.getBoolean("isExpress");
                    String directionToEnd = rs.getBoolean("directionToEnd") ? "To End" : "To Start";
                    String startTime = new SimpleDateFormat("HH:mm").format(rs.getTime("start_time"));
                    String originName = rs.getString("origin_name");
                    String transitName = rs.getString("transit_name");
                    double fare = rs.getDouble("fare");
                    String arrivalTime = new SimpleDateFormat("HH:mm").format(rs.getTimestamp("arrival_time")); 


        %>
        <div class="accordion mb-3" id="accordionTrain<%= trainNumber %>">
            <div class="accordion-item">
                <h2 class="accordion-header" id="heading<%= trainNumber %>">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse<%= trainNumber %>" aria-expanded="false" aria-controls="collapse<%= trainNumber %>">
                        Train <%= trainNumber %> (<%= transitName %>) - Arrival at <%=originName %>: <%= arrivalTime %>
                    </button>
                </h2>
                <div id="collapse<%= trainNumber %>" class="accordion-collapse collapse" aria-labelledby="heading<%= trainNumber %>" data-bs-parent="#accordionTrain<%= trainNumber %>">
                    <div class="accordion-body">
                        <p><strong>Transit Name:</strong> <%= transitName %></p>
                        <p><strong>Fare:</strong> $<%= String.format("%.2f", fare) %></p>
                        <p><strong>Express:</strong> <%= isExpress ? "Yes" : "No" %></p>
                        <p><strong>Direction:</strong> <%= directionToEnd %></p>
                        <p><strong>Selected Station:</strong> <%= originName %></p>

                        <h5>Train Route:</h5>
                        <table class="table table-bordered table-striped">
                            <thead class="table-dark">
                                <tr>
                                    <th>Stop Number</th>
                                    <th>Station Name</th>
                                    <th>Arrival Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    PreparedStatement ps2 = null;
                                    ResultSet rs2 = null;

                                    try {
                                        String arrivalQuery = "SELECT ts.stop_number, s.station_name, " +
                                                              "DATE_FORMAT(TIMESTAMPADD(MINUTE, CASE WHEN t.directionToEnd = TRUE THEN ts.local_time_offset ELSE " +
                                                              "(SELECT MAX(ts2.local_time_offset) FROM Transit_Stop ts2 WHERE ts2.transit_id = ts.transit_id) - ts.local_time_offset END, t.start_time), '%H:%i') AS arrival_time " +
                                                              "FROM Transit_Stop ts JOIN Station s ON ts.station_id = s.station_id JOIN Train t ON ts.transit_id = t.transit_id " +
                                                              "WHERE t.train_number = ? ORDER BY arrival_time";

                                        ps2 = conn.prepareStatement(arrivalQuery);
                                        ps2.setInt(1, trainNumber);
                                        rs2 = ps2.executeQuery();
                                        
                                        while (rs2.next()) {
                                            int stopNumber = rs2.getInt("stop_number");
                                            String stopStationName = rs2.getString("station_name");
                                            String stopArrivalTime = rs2.getString("arrival_time");
                                %>
                                <tr>
                                    <td><%= stopNumber %></td>
                                    <td><%= stopStationName %></td>
                                    <td><%= stopArrivalTime %></td>
                                </tr>
                                <% 
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (rs2 != null) rs2.close();
                                        if (ps2 != null) ps2.close();
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <% 
                }
            } catch (Exception e) {
                out.println("<p class='text-danger'>An error occurred. Please try again later.</p>");
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
    <% } %>
</div>
