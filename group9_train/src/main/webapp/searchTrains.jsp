<%@ page session="true"%>

<%@ page
	import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ include file="navbar.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Train Schedule Search</title>
<style>
form {
	margin-bottom: 20px;
	display: flex;
	align-items: center;
	justify-content: flex-start;
	gap: 10px;
}

label {
	font-weight: bold;
}

select, button {
	padding: 5px 10px;
	font-size: 1rem;
	border: 1px solid #ccc;
	border-radius: 4px;
	cursor: pointer;
}

select {
	width: 200px;
}

button {
	background-color: #4CAF50;
	color: white;
	border: none;
	cursor: pointer;
	transition: background-color 0.3s;
}

button:hover {
	background-color: #45a049;
}

body {
	font-family: Arial, sans-serif;
	background-color: #f4f4f9;
	margin: 0;
	padding: 20px;
}

h1 {
	text-align: center;
	color: #333;
	margin-bottom: 20px;
}

.accordion {
	margin: 20px auto;
	max-width: 800px;
}

.accordion-item {
	margin-bottom: 10px;
	padding: 15px;
	background-color: #007bff;
	color: white;
	border: 1px solid #ddd;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.accordion-button {
	width: 100%;
	background-color: #3295ff;
	color: white;
	padding: 15px;
	font-size: 16px;
	border: none;
	text-align: left;
	cursor: pointer;
	transition: background-color 0.3s ease;
	color: white;
	margin: 10px 0;
}

.accordion-button:hover {
	background-color: #0056b3;
}

.accordion-button.active {
	background-color: #0056b3;
}

.accordion-content {
	display: none;
	padding: 15px;
	background-color: #f9f9f9;
	color: black;
}

.accordion-content.show {
	display: block;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 15px;
}

table th, table td {
	text-align: left;
	padding: 10px;
	border: 1px solid #ddd;
}

table th {
	background-color: #007bff;
	color: white;
}

table tr:nth-child(even) {
	background-color: #f4f4f9;
}

table tr:nth-child(odd) {
	background-color: #fff;
}

table tr[style] {
	font-weight: bold;
}

table tr[style] td {
	font-weight: bold;
}

.highlight-origin {
	background-color: #ffd7d7 !important;
}

.highlight-destination {
	background-color: #d7ffd7 !important;
}
</style>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const buttons = document.querySelectorAll(".accordion-button");

        buttons.forEach(button => {
            button.addEventListener("click", function() {
                // Toggle active class on button
                button.classList.toggle("active");

                // Toggle the corresponding content
                const content = button.nextElementSibling;
                content.classList.toggle("show");
            });
        });
    });
</script>
</head>
<body>

	<h1>Train Schedule</h1>
	<form method="GET" action="">
		<label for="sortOption">Sort by:</label> <select name="sortOption"
			id="sortOption">
			<option value="origin_arrival_time"
				<%="origin_arrival_time".equals(request.getParameter("sortOption")) ? "selected" : ""%>>Departure
				from Origin</option>
			<option value="destination_arrival_time"
				<%="destination_arrival_time".equals(request.getParameter("sortOption")) ? "selected" : ""%>>Arrival
				at Destination</option>
			<option value="fare_from_origin_to_destination"
				<%="fare_from_origin_to_destination".equals(request.getParameter("sortOption")) ? "selected" : ""%>>Fare</option>
		</select> <input type="hidden" name="origin"
			value="<%=request.getParameter("origin")%>"> <input
			type="hidden" name="destination"
			value="<%=request.getParameter("destination")%>"> <input
			type="hidden" name="date" value="<%=request.getParameter("date")%>">

		<button type="submit">Sort</button>
	</form>
	<%
	String originId = request.getParameter("origin");
	String destinationId = request.getParameter("destination");
	String date = request.getParameter("date");
	String sortOption = request.getParameter("sortOption") != null ? request.getParameter("sortOption")
			: "origin_arrival_time"; // Default sort by origin arrival time
	loggedInUser = (String) session.getAttribute("loggedInUser");

	if (originId != null && destinationId != null) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			conn = DBConnectionUtil.getConnection();
			String query = "SELECT DISTINCT t.train_number, t.isExpress, t.directionToEnd,t.start_time, "
			+ "s1.station_name AS origin_name, s2.station_name AS destination_name,tl.transit_id,tl.transit_name, tl.fare,"
			+ "(ABS(ts1.stop_number - ts2.stop_number) * tl.fare) AS fare_from_origin_to_destination,"
			+ "TIMESTAMPADD(MINUTE, " + "  CASE WHEN t.directionToEnd = TRUE THEN ts1.local_time_offset "
			+ " ELSE (SELECT MAX(ts2.local_time_offset) " + " FROM Transit_Stop ts2 "
			+ " WHERE ts2.transit_id = ts1.transit_id) - ts1.local_time_offset END, "
			+ "  t.start_time) AS origin_arrival_time," + "TIMESTAMPADD(MINUTE, "
			+ "  CASE WHEN t.directionToEnd = TRUE THEN ts2.local_time_offset "
			+ " ELSE (SELECT MAX(ts1.local_time_offset) " + " FROM Transit_Stop ts1 "
			+ " WHERE ts1.transit_id = ts2.transit_id) - ts2.local_time_offset END, "
			+ "  t.start_time) AS destination_arrival_time " + "FROM Train t "
			+ "JOIN Transit_Stop ts1 ON t.transit_id = ts1.transit_id "
			+ "JOIN Transit_Stop ts2 ON t.transit_id = ts2.transit_id "
			+ "JOIN Station s1 ON ts1.station_id = s1.station_id "
			+ "JOIN Station s2 ON ts2.station_id = s2.station_id "
			+ "JOIN Transit_Line tl ON t.transit_id = tl.transit_id "
			+ "WHERE ts1.station_id = ? AND ts2.station_id = ? "
			+ "AND ((t.directionToEnd = TRUE AND ts1.stop_number < ts2.stop_number) "
			+ "OR (t.directionToEnd = FALSE AND ts1.stop_number > ts2.stop_number)) " + "AND ((t.isExpress = 0) "
			+ "OR (t.isExpress = 1 AND ts1.isExpressStop = 1 AND ts2.isExpressStop = 1)) " + "ORDER BY "
			+ sortOption + ",origin_arrival_time";

			ps = conn.prepareStatement(query);
			ps.setInt(1, Integer.parseInt(originId));
			ps.setInt(2, Integer.parseInt(destinationId));

			rs = ps.executeQuery();

			out.println("<div class='accordion'>");
			while (rs.next()) {
		int trainNumber = rs.getInt("train_number");
		String originArrivalTime = rs.getString("origin_arrival_time").substring(0, 5); // Remove seconds
		String destinationTime = rs.getString("destination_arrival_time").substring(0, 5); // Remove seconds
		String originName = rs.getString("origin_name");
		String destinationName = rs.getString("destination_name");
		String transitName = rs.getString("transit_name");
		String transitFare = rs.getString("fare");
		String transitId = rs.getString("transit_id");
		String fareFromOtoD = rs.getString("fare_from_origin_to_destination");

		out.println("<div class='accordion-item'>");
		out.println("<div style='display: flex; gap: 10px;justify-content: space-between; align-items: center;'>");

		out.print("<div><p>" + transitName + ",#" + trainNumber + "</p>");
		out.print("<p>" + "Fare:$" + transitFare + " every stop</p></div>");
		out.print("<div><p>" + originArrivalTime + ": Depart from " + originName + "</p>");
		out.print("<p>" + destinationTime + ": Arrive at " + destinationName + "</p></div>");
		out.print("<div><p>" + "Total Fare:$" + fareFromOtoD + "</p>");
		out.print("<div style='margin-top: 10px; text-align: right;'>");
		out.print("<form method='GET' action='bookTrain.jsp' style='display: inline;'>");
		out.print("<input type='hidden' name='originName' value='" + originName + "'>");
		out.print("<input type='hidden' name='destinationName' value='" + destinationName + "'>");
		out.print("<input type='hidden' name='transitName' value='" + transitName + "'>");
		out.print("<input type='hidden' name='transitId' value='" + transitId + "'>");
		out.print("<input type='hidden' name='originId' value='" + originId + "'>");
		out.print("<input type='hidden' name='destinationId' value='" + destinationId + "'>");
		out.print("<input type='hidden' name='date' value='" + date + "'>");
		out.print("<input type='hidden' name='fare' value='" + fareFromOtoD + "'>");
		if (loggedInUser == null) {
			// If user is not logged in, disable the button
			out.print(
					"<button type='button' disabled style='padding: 10px 15px; background-color: #ccc; color: #666; border: none; border-radius: 4px; cursor: not-allowed;'>Log in to Book</button>");
		} else {
			// If user is logged in, render the enabled button
			out.print(
					"<button type='submit' style='padding: 10px 15px; background-color: white; color: #007bff; border: none; border-radius: 4px; cursor: pointer;'>Book</button>");
		}
		out.print("</form>");
		out.print("</div>");
		out.print("</div>");
		out.println("</div>");
		/* out.println("<p>Departure from " + originName + ": " + originArrivalTime + "</p>"); */
		/* 		out.println("<button class='accordion-button'>Train Number: " + trainNumber + " | Departure from "
						+ originName + ": " + originArrivalTime + " | Arrival at " + destinationName + ": "
						+ destinationTime + " | Date: " + date + " | Fare for chosen origin to destination: "
						+ fareFromOtoD + "</button>"); */
		out.println("<button class='accordion-button'>Click to see route</button>");
		out.println("<div class='accordion-content'>");

		// Fetch arrival times
		String arrivalQuery = "SELECT ts.stop_number, s.station_name, " + "TIMESTAMPADD(MINUTE, "
				+ "CASE WHEN t.directionToEnd = TRUE THEN ts.local_time_offset "
				+ "ELSE (SELECT MAX(ts2.local_time_offset) FROM Transit_Stop ts2 WHERE ts2.transit_id = ts.transit_id) - ts.local_time_offset END, "
				+ "t.start_time) AS arrival_time " + "FROM Transit_Stop ts "
				+ "JOIN Station s ON ts.station_id = s.station_id "
				+ "JOIN Train t ON ts.transit_id = t.transit_id " + "WHERE t.train_number = ? "
				+ "ORDER BY arrival_time";

		PreparedStatement arrivalPs = conn.prepareStatement(arrivalQuery);
		arrivalPs.setInt(1, trainNumber);

		ResultSet arrivalRs = arrivalPs.executeQuery();

		out.println("<table>");
		out.println("<tr><th>Stop Number</th><th>Station Name</th><th>Arrival Time</th></tr>");
		while (arrivalRs.next()) {
			int stopNumber = arrivalRs.getInt("stop_number");
			String stationName = arrivalRs.getString("station_name");
			String arrivalTime = arrivalRs.getString("arrival_time").substring(0, 5); // Remove seconds

			String highlightClass = "";
			if (stationName.equals(originName)) {
				highlightClass = "class='highlight-origin'";
			} else if (stationName.equals(destinationName)) {
				highlightClass = "class='highlight-destination'";
			}

			out.println("<tr " + highlightClass + ">");
			out.println("<td>" + stopNumber + "</td>");
			out.println("<td>" + stationName + "</td>");
			out.println("<td>" + arrivalTime + "</td>");
			out.println("</tr>");
		}
		arrivalRs.close();
		arrivalPs.close();

		out.println("</table>");
		out.println("</div>"); // accordion-content
		out.println("</div>"); // accordion-item
			}
			out.println("</div>"); // accordion

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
