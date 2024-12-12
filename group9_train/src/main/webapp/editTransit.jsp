<%@ page
	import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ include file="navbar.jsp"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Transit Details</title>
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>



	<div class="container mt-5">
		<h2>Edit Transit Details</h2>

		<!-- Transit Selection Form -->
		<form action="editTransit.jsp" method="POST">
			<div class="form-group">
				<label for="transit_id">Select Transit Line</label> <select
					id="transit_id" name="transit_id" class="form-control" required>
					<option value="" disabled selected>Select a transit line</option>
					<%
					Connection conn = null;
					try {
						conn = DBConnectionUtil.getConnection();
						String query = "SELECT transit_id, transit_name FROM Transit_Line";
						PreparedStatement ps = conn.prepareStatement(query);
						ResultSet rs = ps.executeQuery();
						while (rs.next()) {
							int transitId = rs.getInt("transit_id");
							String transitName = rs.getString("transit_name");
							out.println("<option value='" + transitId + "'>" + transitId + " - " + transitName + "</option>");
						}
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						try {
							if (conn != null)
						conn.close();
						} catch (SQLException e) {
							e.printStackTrace();
						}
					}
					%>
				</select>
			</div>
			<button type="submit" class="btn btn-primary">Load Transit
				Details</button>
		</form>

		<hr>

		<!-- Transit Details Form -->

		<%
		String selectedTransitId = request.getParameter("transit_id");
		int size=0;
		if (selectedTransitId != null) {
			try {
				conn = DBConnectionUtil.getConnection();

				// Fetch transit details
				String transitQuery = "SELECT * FROM Transit_Line WHERE transit_id = ?";
				PreparedStatement psTransit = conn.prepareStatement(transitQuery);
				psTransit.setInt(1, Integer.parseInt(selectedTransitId));
				ResultSet rsTransit = psTransit.executeQuery();

				if (rsTransit.next()) {
			int transitId = rsTransit.getInt("transit_id");
			String transitName = rsTransit.getString("transit_name");
			double fare = rsTransit.getDouble("fare");
		%>
		<form action="updateTransitDetails.jsp" method="POST">

			<h3>Transit Details</h3>

			<div class="form-group">
				<label for="transit_id">Transit ID</label> <input type="text"
					class="form-control" id="transit_id" name="transit_id"
					value="<%=transitId%>" readonly>
			</div>
			<div class="form-group">
				<label for="transit_name">Transit Name</label> <input type="text"
					class="form-control" id="transit_name" name="transit_name"
					value="<%=transitName%>" readonly>
			</div>
			<div class="form-group">
				<label for="fare">Fare</label> <input type="number" step="0.01"
					class="form-control" id="fare" name="fare" value="<%=fare%>"
					required>
			</div>
			<button type="submit" class="btn btn-success">Update Transit</button>
		</form>
		<%
		}
		if (selectedTransitId != null) {
		%>

		<hr>

		<!-- Transit Stops Form -->


				
				
			<h3>Transit Stops</h3>
			<%
			String stopQuery = "SELECT ts.*, s.station_name FROM Transit_Stop ts "
					+ "JOIN Station s ON ts.station_id = s.station_id " + "WHERE ts.transit_id = ? ORDER BY ts.stop_number";
			PreparedStatement psStops = conn.prepareStatement(stopQuery,ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			psStops.setInt(1, Integer.parseInt(selectedTransitId));
			ResultSet rsStops = psStops.executeQuery();
			rsStops.last();
			size = rsStops.getRow();
			rsStops.beforeFirst();
			
			%>
					<form class="py-5" action="updateTransitStop.jsp" method="POST">
			<input type="hidden" class="form-control" id="transit_id"
				name="transit_id" value="<%=selectedTransitId%>">
				<input type="hidden" class="form-control" id="no_stops"
				name="no_stops" value="<%=size%>">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>Stop Number</th>
						<th>Station Name</th>
						<th>Local Time Offset</th>
						<th>Express Time Offset</th>
						<th>Is Express Stop</th>
					</tr>
				</thead>
				<tbody>
					<%
					while (rsStops.next()) {
						int stopNumber = rsStops.getInt("stop_number");
						String stationName = rsStops.getString("station_name");
						int localOffset = rsStops.getInt("local_time_offset");
						Integer expressOffset = rsStops.getObject("express_time_offset", Integer.class);
						boolean isExpressStop = rsStops.getBoolean("isExpressStop");
					%>
					<tr>
						<td><%=stopNumber%></td>
						<td><%=stationName%></td>
						<td><input type="number" class="form-control"
							name="local_offset_<%=stopNumber%>" value="<%=localOffset%>"
							required></td>
						<td><input type="number" class="form-control"
							name="express_offset_<%=stopNumber%>"
							value="<%=expressOffset != null ? expressOffset : ""%>">
						</td>
						<td><input type="checkbox"
							name="isExpressStop_<%=stopNumber%>"
							<%=isExpressStop ? "checked" : ""%>></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
			<button type="submit" class="btn btn-success">Update Transit
				Stops</button>

			<%
		}
			} catch (Exception e) {
			e.printStackTrace();
			} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			}
			}
			%>
		</form>
	</div>

</body>
</html>
