<%@ page
	import="java.sql.*, java.util.*, com.example.util.DBConnectionUtil"%>
<%@ include file="navbar.jsp"%>

<%
// Get customer_id from session
Integer customerId = (Integer) session.getAttribute("customerId");
if (customerId == null) {
	response.sendRedirect("login.jsp"); // Redirect to login if not logged in
	return;
}

Connection conn = null;
PreparedStatement psReservations = null;
ResultSet rsReservations = null;

try {
	conn = DBConnectionUtil.getConnection();

	// SQL to fetch reservations for the logged-in customer
	String sql = "SELECT r.reservation_no, r.total_fare, r.payment_mode, r.reservedAt, "
	+ "s1.station_name AS departure_station, s2.station_name AS destination_station, "
	+ "t.transit_name, r.isCancelled " + "FROM Reservation r "
	+ "JOIN Station s1 ON r.departure_from = s1.station_id "
	+ "JOIN Station s2 ON r.destination_at = s2.station_id "
	+ "JOIN Transit_Line t ON r.reservedForTransit = t.transit_id "
	+ "WHERE r.customer_id = ? ORDER BY r.reservedAt DESC";

	psReservations = conn.prepareStatement(sql);
	psReservations.setInt(1, customerId);

	rsReservations = psReservations.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Reservations</title>
<link rel="stylesheet" href="reservations_styles.css">
</head>
<%
    String message = (String) session.getAttribute("message");
    if (message != null) {
%>
    <div class="<%= message.startsWith("Error") ? "error-message" : "success-message" %>">
        <%= message %>
    </div>
<%
        session.removeAttribute("message"); // Clear the message after displaying
    }
%>
<body>
	<div class="container">
		<h1>My Reservations</h1>

		<%
		boolean hasReservations = false;
		while (rsReservations.next()) {
			hasReservations = true;

			int reservationNo = rsReservations.getInt("reservation_no");
			String departureStation = rsReservations.getString("departure_station");
			String destinationStation = rsReservations.getString("destination_station");
			String transitName = rsReservations.getString("transit_name");
			double totalFare = rsReservations.getDouble("total_fare");
			String paymentMode = rsReservations.getString("payment_mode");
			Timestamp reservedAt = rsReservations.getTimestamp("reservedAt");
			boolean isCancelled = rsReservations.getBoolean("isCancelled");
		%>

		<div class="card">
			<div class="card-header">
				<h2>
					Reservation #<%=reservationNo%></h2>
				<p class="status">
					<strong>Status:</strong>
					<%=isCancelled ? "Cancelled" : "Active"%></p>
			</div>
			<div class="card-body">
				<p>
					<strong>Departure:</strong>
					<%=departureStation%></p>
				<p>
					<strong>Destination:</strong>
					<%=destinationStation%></p>
				<p>
					<strong>Transit:</strong>
					<%=transitName%></p>
				<p>
					<strong>Total Fare:</strong> $<%=String.format("%.2f", totalFare)%></p>
				<p>
					<strong>Payment Mode:</strong>
					<%=paymentMode%></p>
				<p>
					<strong>Reserved At:</strong>
					<%=reservedAt.toString().substring(0, 16)%></p>
			</div>
			<div class="card-footer">
				<%
				if (!isCancelled) {
				%>
				<form action="cancelReservation.jsp" method="post" onsubmit="return confirm('Are you sure you want to cancel this reservation?')"
					style="display: inline;">
					<input type="hidden" name="reservationNo"
						value="<%=reservationNo%>">
					<button type="submit" class="btn-cancel">Cancel
						Reservation</button>
				</form>
				<%
				}
				%>
				<form action="viewTickets.jsp" method="get" style="display: inline;">
					<input type="hidden" name="reservationNo"
						value="<%=reservationNo%>"> <input type="hidden"
						name="departureStation" value="<%=departureStation%>"> <input
						type="hidden" name="destinationStation"
						value="<%=destinationStation%>"> <input type="hidden"
						name="transitName" value="<%=transitName%>"> <input
						type="hidden" name="totalFare" value="<%=totalFare%>"> <input
						type="hidden" name="reservedAt" value="<%=reservedAt%>">
					<button type="submit" class="btn-view">View Tickets</button>
				</form>
			</div>
		</div>

		<%
		}
		if (!hasReservations) {
		%>
		<p class="no-reservations">No reservations found.</p>
		<%
		}
		%>
	</div>
</body>
</html>

<%
} catch (Exception e) {
e.printStackTrace();
out.println("<p>Error retrieving reservations. Please try again later.</p>");
} finally {
if (rsReservations != null)
	rsReservations.close();
if (psReservations != null)
	psReservations.close();
if (conn != null)
	conn.close();
}
%>
