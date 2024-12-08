<%@ include file="checkAdmin.jsp"%>
<%@ include file="navbar.jsp"%>
<%@ page import="java.sql.*, java.util.*"%>
<%
// Fetch the selected month and year
String selectedMonth = request.getParameter("month");
String selectedYear = request.getParameter("year");

// Variables to hold results
int numCustomers = 0;
int numTickets = 0;
int numReservations = 0;
int numCancelledReservations = 0;
double totalFare = 0.0;

// Query and calculate results only if month and year are provided
if (selectedMonth != null && selectedYear != null) {
	try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
		// Prepare the query to calculate the sales report
		String sql = "SELECT COUNT(DISTINCT r.customer_id) AS numCustomers, "
		+ "SUM(CASE WHEN r.isCancelled = FALSE THEN 1 ELSE 0 END) AS numTickets, "
		+ "COUNT(DISTINCT r.reservation_no) AS numReservations, "
		+ "SUM(CASE WHEN r.isCancelled = FALSE THEN t.fare ELSE 0 END) AS totalFare, "
		+ "SUM(CASE WHEN r.isCancelled = TRUE THEN 1 ELSE 0 END) AS numCancelledReservations "
		+ "FROM Reservation r " + "JOIN Ticket t ON r.reservation_no = t.reservation_no "
		+ "WHERE MONTH(r.reservedAt) = ? AND YEAR(r.reservedAt) = ?";

		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setInt(1, Integer.parseInt(selectedMonth)); // Set the month
		ps.setInt(2, Integer.parseInt(selectedYear)); // Set the year

		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
	// Set the result variables
	numCustomers = rs.getInt("numCustomers");
	numTickets = rs.getInt("numTickets");
	numReservations = rs.getInt("numReservations");
	totalFare = rs.getDouble("totalFare");
	numCancelledReservations = rs.getInt("numCancelledReservations");
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sales Report</title>
<link rel="stylesheet" href="salesreport_styles.css">
</head>
<body>
	<div class="container">
		<h1>Sales Report</h1>

		<!-- Form for selecting month and year -->
		<form method="GET" action="salesReport.jsp">
			<label for="month">Month:</label> <select id="month" name="month">
				<option value="">-- Select Month --</option>
				<option value="1"
					<%=selectedMonth != null && selectedMonth.equals("1") ? "selected" : ""%>>January</option>
				<option value="2"
					<%=selectedMonth != null && selectedMonth.equals("2") ? "selected" : ""%>>February</option>
				<option value="3"
					<%=selectedMonth != null && selectedMonth.equals("3") ? "selected" : ""%>>March</option>
				<option value="4"
					<%=selectedMonth != null && selectedMonth.equals("4") ? "selected" : ""%>>April</option>
				<option value="5"
					<%=selectedMonth != null && selectedMonth.equals("5") ? "selected" : ""%>>May</option>
				<option value="6"
					<%=selectedMonth != null && selectedMonth.equals("6") ? "selected" : ""%>>June</option>
				<option value="7"
					<%=selectedMonth != null && selectedMonth.equals("7") ? "selected" : ""%>>July</option>
				<option value="8"
					<%=selectedMonth != null && selectedMonth.equals("8") ? "selected" : ""%>>August</option>
				<option value="9"
					<%=selectedMonth != null && selectedMonth.equals("9") ? "selected" : ""%>>September</option>
				<option value="10"
					<%=selectedMonth != null && selectedMonth.equals("10") ? "selected" : ""%>>October</option>
				<option value="11"
					<%=selectedMonth != null && selectedMonth.equals("11") ? "selected" : ""%>>November</option>
				<option value="12"
					<%=selectedMonth != null && selectedMonth.equals("12") ? "selected" : ""%>>December</option>
			</select> <label for="year">Year:</label> <input type="number" id="year"
				name="year" value="<%=selectedYear != null ? selectedYear : ""%>"
				min=2024 required>

			<button type="submit">Generate Report</button>
		</form>

		<!-- Display Results -->
		<div class="results">
			<%
			if (selectedMonth != null && selectedYear != null) {
			%>
			<h2>
				Sales Report for
				<%=selectedMonth%>
				/
				<%=selectedYear%></h2>
			<table>
				<tr>
					<th>Number of Different Customers</th>
					<td><%=numCustomers%></td>
				</tr>
				<tr>
					<th>Total Number of Tickets</th>
					<td><%=numTickets%></td>
				</tr>
				<tr>
					<th>Number of Reservations</th>
					<td><%=numReservations%></td>
				</tr>
				<tr>
					<th>Number of Cancelled Reservations</th>
					<td><%=numCancelledReservations%></td>
				</tr>
				<tr>
					<th>Total Fare (excluding cancelled)</th>
					<td>$<%=String.format("%.2f", totalFare)%></td>
				</tr>
			</table>
			<%
			} else {
			%>
			<p>Please select a month and year to generate the sales report.</p>
			<%
			}
			%>
		</div>
	</div>
</body>
</html>
