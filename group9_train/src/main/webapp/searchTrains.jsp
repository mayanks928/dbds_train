<%@ page session="true"%>
<%@ page import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ include file="navbar.jsp"%>
<%
String originId = request.getParameter("origin");
String destinationId = request.getParameter("destination");
String date = request.getParameter("date");
String sortOption = request.getParameter("sortOption") != null ? request.getParameter("sortOption") : "origin_arrival_time";
loggedInUser = (String) session.getAttribute("loggedInUser");


Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>
<div class="container my-5">
    <h1 class="text-center mb-4">Train Schedule</h1>
    <form method="GET" action="" class="mb-4 d-flex align-items-center gap-2">
        <label for="sortOption" class="form-label mb-0 me-2"><strong>Sort by:</strong></label>
        <select name="sortOption" id="sortOption" class="form-select w-auto">
            <option value="origin_arrival_time" <%= "origin_arrival_time".equals(sortOption) ? "selected" : ""%>>Departure from Origin</option>
            <option value="destination_arrival_time" <%= "destination_arrival_time".equals(sortOption) ? "selected" : ""%>>Arrival at Destination</option>
            <option value="fare_from_origin_to_destination" <%= "fare_from_origin_to_destination".equals(sortOption) ? "selected" : ""%>>Fare</option>
        </select>
        <input type="hidden" name="origin" value="<%=originId%>">
        <input type="hidden" name="destination" value="<%=destinationId%>">
        <input type="hidden" name="date" value="<%=date%>">
        <button type="submit" class="btn btn-primary">Sort</button>
    </form>

    <%
    if (originId != null && destinationId != null) {
        try {
            conn = DBConnectionUtil.getConnection();
            String query = "SELECT DISTINCT t.train_number, t.isExpress, t.directionToEnd,t.start_time, " +
                           "s1.station_name AS origin_name, s2.station_name AS destination_name,tl.transit_id,tl.transit_name, tl.fare," +
                           "(ABS(ts1.stop_number - ts2.stop_number) * tl.fare) AS fare_from_origin_to_destination," +
                           "TIMESTAMPADD(MINUTE, CASE WHEN t.directionToEnd = TRUE THEN ts1.local_time_offset ELSE " +
                           "(SELECT MAX(tsx.local_time_offset) FROM Transit_Stop tsx WHERE tsx.transit_id = ts1.transit_id)-ts1.local_time_offset END, t.start_time) AS origin_arrival_time,"+
                           "TIMESTAMPADD(MINUTE, CASE WHEN t.directionToEnd = TRUE THEN ts2.local_time_offset ELSE " +
                           "(SELECT MAX(tsy.local_time_offset) FROM Transit_Stop tsy WHERE tsy.transit_id = ts2.transit_id)-ts2.local_time_offset END, t.start_time) AS destination_arrival_time " +
                           "FROM Train t JOIN Transit_Stop ts1 ON t.transit_id = ts1.transit_id " +
                           "JOIN Transit_Stop ts2 ON t.transit_id = ts2.transit_id " +
                           "JOIN Station s1 ON ts1.station_id = s1.station_id " +
                           "JOIN Station s2 ON ts2.station_id = s2.station_id " +
                           "JOIN Transit_Line tl ON t.transit_id = tl.transit_id " +
                           "WHERE ts1.station_id = ? AND ts2.station_id = ? " +
                           "AND ((t.directionToEnd = TRUE AND ts1.stop_number < ts2.stop_number) OR (t.directionToEnd = FALSE AND ts1.stop_number > ts2.stop_number)) " +
                           "AND ((t.isExpress = 0) OR (t.isExpress = 1 AND ts1.isExpressStop = 1 AND ts2.isExpressStop = 1)) " +
                           "ORDER BY " + sortOption + ", origin_arrival_time";

            ps = conn.prepareStatement(query);
            ps.setInt(1, Integer.parseInt(originId));
            ps.setInt(2, Integer.parseInt(destinationId));
            rs = ps.executeQuery();

            boolean hasResults = false;
            out.println("<div class='accordion' id='trainAccordion'>");
            int count = 0;
            while (rs.next()) {
                hasResults = true;
                count++;
                int trainNumber = rs.getInt("train_number");
                String originArrivalTime = rs.getString("origin_arrival_time").substring(0, 5);
                String destinationTime = rs.getString("destination_arrival_time").substring(0, 5);
                String originName = rs.getString("origin_name");
                String destinationName = rs.getString("destination_name");
                String transitName = rs.getString("transit_name");
                String transitFare = rs.getString("fare");
                String transitId = rs.getString("transit_id");
                String fareFromOtoD = rs.getString("fare_from_origin_to_destination");

                out.println("<div class='card mb-3'>");
                out.println("<div class='card-body d-flex justify-content-between align-items-center'>");
                out.print("<div><p class='mb-1'><strong>" + transitName + ", #" + trainNumber + "</strong></p>");
                out.print("<p class='mb-1'>Fare: $" + transitFare + " every stop</p></div>");

                out.print("<div><p class='mb-1'>" + originArrivalTime + ": Depart from " + originName + "</p>");
                out.print("<p class='mb-1'>" + destinationTime + ": Arrive at " + destinationName + "</p></div>");

                out.print("<div><p class='mb-1'>Total Fare: $" + fareFromOtoD + "</p>");
                out.print("<form method='GET' action='bookTrain.jsp'>");
                out.print("<input type='hidden' name='originName' value='" + originName + "'>");
                out.print("<input type='hidden' name='destinationName' value='" + destinationName + "'>");
                out.print("<input type='hidden' name='transitName' value='" + transitName + "'>");
                out.print("<input type='hidden' name='transitId' value='" + transitId + "'>");
                out.print("<input type='hidden' name='originId' value='" + originId + "'>");
                out.print("<input type='hidden' name='destinationId' value='" + destinationId + "'>");
                out.print("<input type='hidden' name='date' value='" + date + "'>");
                out.print("<input type='hidden' name='fare' value='" + fareFromOtoD + "'>");
                if (loggedInUser == null) {
                    out.print("<button type='button' disabled class='btn btn-secondary btn-sm mt-2'>Log in to Book</button>");
                } else {
                    out.print("<button type='submit' class='btn btn-primary btn-sm mt-2'>Book</button>");
                }
                out.print("</form></div>");

                out.println("</div>");
                out.println("<button class='btn btn-link' type='button' data-bs-toggle='collapse' data-bs-target='#collapse"+count+"'>Click to see route</button>");
                out.println("<div id='collapse"+count+"' class='collapse' data-bs-parent='#trainAccordion'>");

                // Fetch route details
                String arrivalQuery = "SELECT ts.stop_number, s.station_name, " +
                                      "TIMESTAMPADD(MINUTE, CASE WHEN t.directionToEnd = TRUE THEN ts.local_time_offset ELSE " +
                                      "(SELECT MAX(ts2.local_time_offset) FROM Transit_Stop ts2 WHERE ts2.transit_id = ts.transit_id)-ts.local_time_offset END, t.start_time) AS arrival_time " +
                                      "FROM Transit_Stop ts JOIN Station s ON ts.station_id = s.station_id JOIN Train t ON ts.transit_id = t.transit_id " +
                                      "WHERE t.train_number = ? ORDER BY arrival_time";
                PreparedStatement arrivalPs = conn.prepareStatement(arrivalQuery);
                arrivalPs.setInt(1, trainNumber);
                ResultSet arrivalRs = arrivalPs.executeQuery();

                out.println("<div class='table-responsive p-3'>");
                out.println("<table class='table table-striped align-middle'><thead><tr><th>Stop Number</th><th>Station Name</th><th>Arrival Time</th></tr></thead><tbody>");
                while (arrivalRs.next()) {
                    int stopNumber = arrivalRs.getInt("stop_number");
                    String stationName = arrivalRs.getString("station_name");
                    String arrTime = arrivalRs.getString("arrival_time").substring(0, 5);
                    String highlightClass = "";
                    if (stationName.equals(originName)) highlightClass = "table-warning";
                    else if (stationName.equals(destinationName)) highlightClass = "table-success";

                    out.println("<tr class='"+highlightClass+"'><td>"+stopNumber+"</td><td>"+stationName+"</td><td>"+arrTime+"</td></tr>");
                }
                out.println("</tbody></table></div>");

                arrivalRs.close();
                arrivalPs.close();

                out.println("</div>");
                out.println("</div>");
            }
            out.println("</div>");

            if (!hasResults) {
                out.println("<div class='alert alert-secondary mt-3'>No results found.</div>");
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error fetching train schedule: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
    %>
</div>
