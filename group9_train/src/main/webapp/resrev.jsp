<%@ include file="checkAdmin.jsp" %>
<%@ include file="navbar.jsp" %>
<%@ page import="java.sql.*, java.util.*"%>
<%
// Fetch request parameters
String filterType = request.getParameter("filterType");
String selectedTransit = request.getParameter("transitLine");
String customerInput = request.getParameter("customerName");

// Variables to hold results
List<Map<String, Object>> reservations = new ArrayList<>();
double totalRevenue = 0.0;

try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
	PreparedStatement ps = null;
	ResultSet rs = null;

	if ("transit".equalsIgnoreCase(filterType) && selectedTransit != null) {
		
		// Query reservations and revenue by transit line using transit_id
		String sqlTransit = "SELECT r.reservation_no, r.total_fare, r.reservedAt,r.isCancelled, CONCAT(c.first_name, ' ', c.last_name) AS customerName "
		+ "FROM Reservation r " + "JOIN Customer c ON r.customer_id = c.customer_id "
		+ "JOIN Transit_Line t ON r.reservedForTransit = t.transit_id "
		+ "WHERE t.transit_id = ?";
		ps = conn.prepareStatement(sqlTransit);
		ps.setInt(1, Integer.parseInt(selectedTransit)); // Set the transit_id as an integer
		
	} else if ("customer".equalsIgnoreCase(filterType) && customerInput != null) {
		// Query reservations by customer name, including cancelled
		String sqlCustomer = "SELECT r.reservation_no, r.total_fare, r.reservedAt, r.isCancelled, CONCAT(c.first_name, ' ', c.last_name) AS customerName "
		+ "FROM Reservation r " + "JOIN Customer c ON r.customer_id = c.customer_id "
		+ "WHERE CONCAT(c.first_name, ' ', c.last_name) LIKE ? COLLATE utf8mb4_general_ci";
		ps = conn.prepareStatement(sqlCustomer);
		ps.setString(1, "%" + customerInput + "%");
	}

	if (ps != null) {
		
		rs = ps.executeQuery();
		
		while (rs.next()) {
	Map<String, Object> reservationData = new HashMap<>();
	reservationData.put("reservationNo", rs.getInt("reservation_no"));
	reservationData.put("totalFare", rs.getDouble("total_fare"));
	reservationData.put("reservedAt", rs.getTimestamp("reservedAt"));
	reservationData.put("customerName", rs.getString("customerName"));
	reservationData.put("isCancelled", rs.getBoolean("isCancelled"));

	reservations.add(reservationData);

	// Add to revenue only if not cancelled
	if (!rs.getBoolean("isCancelled")) {
		totalRevenue += rs.getDouble("total_fare");
	}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reservations and Revenue</title>
<link rel="stylesheet" href="resrev_styles.css">
</head>
<body>
	<div class="container">
		<h1>Reservations and Revenue</h1>

		<!-- Form for selecting filter type -->
		<form method="GET" action="resrev.jsp">
			<label for="filterType">Filter By:</label> <select id="filterType"
				name="filterType" onchange="toggleFilterOptions()">
				<option value="">-- Select --</option>
				<option value="transit"
					<%if ("transit".equalsIgnoreCase(filterType)) {%> selected
					<%}%>>Transit Line</option>
				<option value="customer"
					<%if ("customer".equalsIgnoreCase(filterType)) {%> selected
					<%}%>>Customer Name</option>
			</select>

			<div id="transitOptions"
				style="display: <%if ("transit".equalsIgnoreCase(filterType)) {%>block<%} else {%>none<%}%>;">
				<label for="transitLine">Select Transit Line:</label> <select
					id="transitLine" name="transitLine">
					<option value="">-- Select Transit Line --</option>
					<%
					try (Connection conn = com.example.util.DBConnectionUtil.getConnection();
							Statement stmt = conn.createStatement();
							ResultSet rs = stmt.executeQuery("SELECT transit_id, transit_name FROM Transit_Line")) {
						while (rs.next()) {
					%>
					<option value="<%=rs.getInt("transit_id")%>"
						<%if (selectedTransit != null && selectedTransit.equals(String.valueOf(rs.getInt("transit_id")))) {%>
						selected <%}%>>
						<%=rs.getString("transit_name")%>
					</option>
					<%
					}
					} catch (Exception e) {
					e.printStackTrace();
					}
					%>
				</select>
			</div>


			<div id="customerOptions"
				style="display: <%if ("customer".equalsIgnoreCase(filterType)) {%>block<%} else {%>none<%}%>;">
				<label for="customerName">Enter Customer Name:</label> <input
					type="text" id="customerName" name="customerName"
					value="<%=customerInput != null ? customerInput : ""%>">
			</div>

			<button type="submit">Submit</button>
		</form>


		<!-- Display Results -->
		<div class="results">
			<%
			if (reservations.isEmpty()){
				
			}
			if (!reservations.isEmpty()) {
				
			%>
			<h2>Reservations</h2>
			<table>
				<thead>
					<tr>
						<th>Reservation No</th>
						<th>Total Fare</th>
						<th>Reserved At</th>
						<th>Customer Name</th>
						<th>Cancelled</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (Map<String, Object> reservation : reservations) {
					%>
					<tr>
						<td><%=reservation.get("reservationNo")%></td>
						<td>$<%=String.format("%.2f", reservation.get("totalFare"))%></td>
						<td><%=reservation.get("reservedAt")%></td>
						<td><%=reservation.get("customerName")%></td>
						<td
							class="<%=(Boolean) reservation.get("isCancelled") ? "cancelled" : "not-cancelled"%>">
							<%
							Boolean isCancelled = (Boolean) reservation.get("isCancelled");
							if (isCancelled != null && isCancelled) {
							%> Yes <%
							} else {
							%> No <%
							}
							%>
						</td>
					</tr>
					<%
					}
					%>

				</tbody>
			</table>

			<h2>Total Revenue</h2>
			<p>
				$<%=String.format("%.2f", totalRevenue)%></p>
			<%
			} else if (filterType != null) {
			%>
			<p>No results found for the selected criteria.</p>
			<%
			}
			%>
		</div>
	</div>

	<script>
		function toggleFilterOptions() {
			const filterType = document.getElementById("filterType").value;
			document.getElementById("transitOptions").style.display = filterType === "transit" ? "block"
					: "none";
			document.getElementById("customerOptions").style.display = filterType === "customer" ? "block"
					: "none";
		}
	</script>
</body>
</html>
