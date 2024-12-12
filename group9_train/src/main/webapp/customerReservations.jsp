<%@ page import="java.sql.*, java.text.SimpleDateFormat"%>
<%@ page import="com.example.util.DBConnectionUtil, java.util.*"%>
<%@ include file="navbar.jsp"%>
<div class="container my-5">
	<h1 class="text-center mb-4">Customer Reservations</h1>
	<div class="card p-4 shadow-sm">
		<form action="customerReservations.jsp" method="get">
			<div class="mb-3">
				<label for="transitLine" class="form-label">Transit Line:</label> <select
					id="transitLine" name="transitLine" class="form-select" required>
					<option value="" disabled selected>Select Transit Line</option>
					<%
					Connection conn = null;
					PreparedStatement ps = null;
					ResultSet rs = null;

					try {
						conn = DBConnectionUtil.getConnection();
						String query = "SELECT transit_id, transit_name FROM Transit_Line";
						ps = conn.prepareStatement(query);
						rs = ps.executeQuery();

						while (rs.next()) {
							int transitId = rs.getInt("transit_id");
							String transitName = rs.getString("transit_name");
					%>
					<option value="<%=transitId%>"><%=transitName%></option>
					<%
					}
					} catch (Exception e) {
					e.printStackTrace();
					} finally {
					if (rs != null)
					rs.close();
					if (ps != null)
					ps.close();
					if (conn != null)
					conn.close();
					}
					%>
				</select>
			</div>

			<div class="mb-3">
				<label for="reservationDate" class="form-label">Reservation
					Date:</label> <input type="date" id="reservationDate"
					name="reservationDate" class="form-control" required>
			</div>

			<button type="submit" class="btn btn-primary w-100">Search</button>
		</form>
	</div>

	<%
	if (request.getParameter("transitLine") != null && request.getParameter("reservationDate") != null) {
		int transitLine = Integer.parseInt(request.getParameter("transitLine"));
		String reservationDate = request.getParameter("reservationDate");
	%>
	<div class="mt-5">
		<h2 class="mb-4">Reservation Results</h2>
		<table class="table table-bordered table-striped">
			<thead class="table-dark">
				<tr>
					<th>Customer Name</th>
					<th>Email</th>
					<th>Reservation No</th>
					<th>Reserved At</th>
					<th>Departure Station</th>
					<th>Destination Station</th>
					<th>Total Fare</th>
				</tr>
			</thead>
			<tbody>
				<%
				conn = null;
				ps = null;
				rs = null;

				try {
					conn = DBConnectionUtil.getConnection();

					String query = " SELECT c.first_name, c.last_name, c.email, r.reservation_no, r.reservedAt,"
					+ "s1.station_name AS departure_station, s2.station_name AS destination_station,"
					+ "r.total_fare FROM Customer AS c " + "INNER JOIN Reservation r ON c.customer_id = r.customer_id "
					+ "INNER JOIN Station s1 ON r.departure_from = s1.station_id "
					+ "INNER JOIN Station s2 ON r.destination_at = s2.station_id "
					+ "WHERE r.reservedForTransit = ? AND DATE(r.reservedAt) = ?";

					ps = conn.prepareStatement(query);
					ps.setInt(1, transitLine);
					ps.setString(2, reservationDate);

					rs = ps.executeQuery();
					if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
						out.println(
						"<tr><td colspan='7' class='text-center text-danger'>No reservations found for the selected transit line and date.</td></tr>");
					} else {
						while (rs.next()) {
					String firstName = rs.getString("first_name");
					String lastName = rs.getString("last_name");
					String email = rs.getString("email");
					int reservationNo = rs.getInt("reservation_no");
					String reservedAt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(rs.getTimestamp("reservedAt"));
					String departureStation = rs.getString("departure_station");
					String destinationStation = rs.getString("destination_station");
					double totalFare = rs.getDouble("total_fare");
				%>
				<tr>
					<td><%=firstName + " " + lastName%></td>
					<td><%=email%></td>
					<td><%=reservationNo%></td>
					<td><%=reservedAt%></td>
					<td><%=departureStation%></td>
					<td><%=destinationStation%></td>
					<td><%=String.format("%.2f", totalFare)%></td>
				</tr>
				<%
				}
				}
				} catch (Exception e) {
				out.println("<tr><td colspan='7' class='text-center text-danger'>An error occurred. Please try again later.</td></tr>");
				e.printStackTrace();
				} finally {
				if (rs != null)
				rs.close();
				if (ps != null)
				ps.close();
				if (conn != null)
				conn.close();
				}
				%>
			</tbody>
		</table>
	</div>
	<%
	}
	%>
</div>
