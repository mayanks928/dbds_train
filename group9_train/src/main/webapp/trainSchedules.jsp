<%@ page session="true"%>
<%@ page
	import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ include file="navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Train Schedule at Selected Station</title>
<link rel="stylesheet" href="styles.css">
<script>
        document.addEventListener("DOMContentLoaded", function() {
            const buttons = document.querySelectorAll(".accordion-button");
            buttons.forEach(button => {
                button.addEventListener("click", function() {
                    button.classList.toggle("active");
                    const content = button.nextElementSibling;
                    content.classList.toggle("show");
                });
            });
        });
    </script>
</head>
<body>

	<h1>Train Schedule at Selected Station</h1>

	<form method="GET" action="">
		<label for="station">Select Station:</label> <select name="station"
			id="station">
			<%
			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				conn = DBConnectionUtil.getConnection();
				ps = conn.prepareStatement("SELECT station_id, station_name FROM Station");
				rs = ps.executeQuery();
				while (rs.next()) {
					int stationId = rs.getInt("station_id");
					String stationName = rs.getString("station_name");
			%>
			<option value="<%=stationId%>"><%=stationName%></option>
			<%
			}
			} catch (Exception e) {
			e.printStackTrace();
			} finally {
			try {
			if (rs != null)
				rs.close();
			if (ps != null)
				ps.close();
			if (conn != null)
				conn.close();
			} catch (Exception e) {
			e.printStackTrace();
			}
			}
			%>
		</select>

		<button type="submit">Search Schedule</button>
	</form>
	<%
	String selectedStation = request.getParameter("station");

	if (selectedStation != null) {
		conn = null;
		ps = null;
		rs = null;

		try {
			conn = DBConnectionUtil.getConnection();
			String query = "SELECT DISTINCT t.train_number, t.isExpress, t.directionToEnd, t.start_time, "
			+ "s1.station_name AS origin_name, s2.station_name AS destination_name, tl.transit_id, tl.transit_name, tl.fare, "
			+ "(ABS(ts1.stop_number - ts2.stop_number) * tl.fare) AS fare_from_origin_to_destination, "
			+ "TIMESTAMPADD(MINUTE, " + "CASE WHEN t.directionToEnd = TRUE THEN ts1.local_time_offset "
			+ "ELSE (SELECT MAX(ts2.local_time_offset) "
			+ "FROM Transit_Stop ts2 WHERE ts2.transit_id = ts1.transit_id) - ts1.local_time_offset END, "
			+ "t.start_time) AS origin_arrival_time, " + "TIMESTAMPADD(MINUTE, "
			+ "CASE WHEN t.directionToEnd = TRUE THEN ts2.local_time_offset "
			+ "ELSE (SELECT MAX(ts1.local_time_offset) "
			+ "FROM Transit_Stop ts1 WHERE ts1.transit_id = ts2.transit_id) - ts2.local_time_offset END, "
			+ "t.start_time) AS destination_arrival_time " + "FROM Train t "
			+ "JOIN Transit_Stop ts1 ON t.transit_id = ts1.transit_id "
			+ "JOIN Transit_Stop ts2 ON t.transit_id = ts2.transit_id "
			+ "JOIN Station s1 ON ts1.station_id = s1.station_id "
			+ "JOIN Station s2 ON ts2.station_id = s2.station_id "
			+ "JOIN Transit_Line tl ON t.transit_id = tl.transit_id "
			+ "WHERE (ts1.station_id = ? OR ts2.station_id = ?) "
			+ "AND ((t.directionToEnd = TRUE AND ts1.stop_number < ts2.stop_number) "
			+ "OR (t.directionToEnd = FALSE AND ts1.stop_number > ts2.stop_number)) "
			+ "AND ((t.isExpress = 0) OR (t.isExpress = 1 AND ts1.isExpressStop = 1 AND ts2.isExpressStop = 1)) "
			+ "ORDER BY origin_arrival_time";

			ps = conn.prepareStatement(query);
			ps.setInt(1, Integer.parseInt(selectedStation));
			ps.setInt(2, Integer.parseInt(selectedStation));

			rs = ps.executeQuery();

			if (rs != null) {
		out.println("<div class='accordion'>");
		while (rs.next()) {
			int trainNumber = rs.getInt("train_number");
			String transitName = rs.getString("transit_name");
			String originName = rs.getString("origin_name");
			String destinationName = rs.getString("destination_name");
			String startTime = rs.getString("start_time").substring(0, 5); // removing seconds
			String fare = String.format("%.2f", rs.getDouble("fare"));
			String originArrivalTime = rs.getString("origin_arrival_time").substring(0, 5);
			String destinationArrivalTime = rs.getString("destination_arrival_time").substring(0, 5);

			out.println("<div class='accordion-item'>");
			out.println(
					"<div style='display: flex; gap: 10px; justify-content: space-between; align-items: center;'>");
			out.print("<div><p>" + transitName + " (Train #" + trainNumber + ")</p>");
			out.print("<p>Fare: $" + fare + " from origin to destination</p></div>");
			out.print("<div><p>Departure from " + originName + ": " + startTime + "</p>");
			out.print("<p>Arrival at " + originName + ": " + originArrivalTime + "</p></div>");
			out.print("<div><p>Arrival at " + destinationName + ": " + destinationArrivalTime + "</p></div>");
			out.print("</div>");
			out.println("<button class='accordion-button'>Click to see detailed route</button>");
			out.println("<div class='accordion-content'>");

			// Fetch and display detailed route (for origin and destination)
			String routeQuery = "SELECT ts.stop_number, s.station_name, " + "TIMESTAMPADD(MINUTE, "
					+ "CASE WHEN t.directionToEnd = TRUE THEN ts.local_time_offset "
					+ "ELSE (SELECT MAX(ts2.local_time_offset) FROM Transit_Stop ts2 WHERE ts2.transit_id = ts.transit_id) - ts.local_time_offset END, "
					+ "t.start_time) AS arrival_time " + "FROM Transit_Stop ts "
					+ "JOIN Station s ON ts.station_id = s.station_id "
					+ "JOIN Train t ON ts.transit_id = t.transit_id " + "WHERE t.train_number = ? "
					+ "ORDER BY ts.stop_number";
			PreparedStatement routePs = conn.prepareStatement(routeQuery);
			routePs.setInt(1, trainNumber);
			ResultSet routeRs = routePs.executeQuery();

			out.println("<table>");
			out.println("<tr><th>Stop Number</th><th>Station Name</th><th>Arrival Time</th></tr>");
			while (routeRs.next()) {
				int stopNumber = routeRs.getInt("stop_number");
				String station = routeRs.getString("station_name");
				String arrivalTime = routeRs.getString("arrival_time").substring(0, 5);

				out.println("<tr>");
				out.println("<td>" + stopNumber + "</td>");
				out.println("<td>" + station + "</td>");
				out.println("<td>" + arrivalTime + "</td>");
				out.println("</tr>");
			}
			routeRs.close();
			routePs.close();

			out.println("</table>");
			out.println("</div>"); // accordion-content
			out.println("</div>"); // accordion-item
		}
		out.println("</div>"); // accordion
			}
		} catch (Exception e) {
			out.println("<p>Error fetching train schedule: " + e.getMessage() + "</p>");
		} finally {
			try {
		if (rs != null)
			rs.close();
		if (ps != null)
			ps.close();
		if (conn != null)
			conn.close();
			} catch (Exception e) {
		e.printStackTrace();
			}
		}
	}
	%>

</body>
</html>
