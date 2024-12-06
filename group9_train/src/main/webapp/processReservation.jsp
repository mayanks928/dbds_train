<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date"%>
<%@ page import="com.example.util.DBConnectionUtil" %>
<%@ page session="true"%>
<%
// Retrieve parameters from the form
    String transitId = request.getParameter("transitId");
    String originId = request.getParameter("originId");
    String destinationId = request.getParameter("destinationId");
    String date = request.getParameter("date");
    double totalFare = Double.parseDouble(request.getParameter("totalFare"));
    String paymentMode = request.getParameter("payment_mode");
    String customerId = request.getParameter("customerID");
    if (customerId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize database connection
    Connection conn = null;
    PreparedStatement reservationStmt = null;
    PreparedStatement ticketStmt = null;
    ResultSet generatedKeys = null;

    try {
        // Connect to the database
conn = DBConnectionUtil.getConnection();
conn.setAutoCommit(false); // Start transaction

// 1. Insert into Reservation table
String reservationSql = "INSERT INTO Reservation (customer_id, total_fare, payment_mode, reservedAt, departure_from, destination_at, reservedForTransit) "
		+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
reservationStmt = conn.prepareStatement(reservationSql, Statement.RETURN_GENERATED_KEYS);
reservationStmt.setInt(1, Integer.parseInt(customerId));
reservationStmt.setDouble(2, totalFare);
reservationStmt.setString(3, paymentMode);
reservationStmt.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis())); // reservedAt
reservationStmt.setInt(5, Integer.parseInt(originId)); // departure_from
reservationStmt.setInt(6, Integer.parseInt(destinationId)); // destination_at
reservationStmt.setInt(7, Integer.parseInt(transitId)); // reservedForTransit
int affectedRows = reservationStmt.executeUpdate();

// If the insertion was successful, get the generated reservation number
if (affectedRows > 0) {
	generatedKeys = reservationStmt.getGeneratedKeys();
	generatedKeys.next();
	int reservationNo = generatedKeys.getInt(1);

	// 2. Insert tickets into Ticket table
	int ticketCount = Integer.parseInt(request.getParameter("ticketCount"));

	for (int i = 1; i <= ticketCount; i++) {
		// Get ticket type and calculate fare for each ticket
		String ticketType = request.getParameter("ticketType" + i);
		double ticketFare = fare;
		if ("Child".equals(ticketType)) {
	ticketFare *= 0.3;
		} else if ("Senior".equals(ticketType)) {
	ticketFare *= 0.4;
		}

		String tripType = request.getParameter("tripType" + i);
		if ("RoundTrip".equals(tripType)) {
	// Add ticket for reverse trip (destination to origin)
	ticketStmt = conn.prepareStatement(
			"INSERT INTO Ticket (reservation_no, ticket_no, fare, ticketType, activatedAt, isExpired) VALUES (?, ?, ?, ?, NULL, ?)");
	ticketStmt.setInt(1, reservationNo);
	ticketStmt.setInt(2, i); // Generate ticket_no based on the loop
	ticketStmt.setDouble(3, ticketFare);
	ticketStmt.setString(4, ticketType);
	ticketStmt.setBoolean(5, false); // Not expired
	ticketStmt.executeUpdate();

	// Reverse ticket from destination to origin
	ticketStmt.setInt(2, i + ticketCount); // Reverse ticket_no
	ticketStmt.setInt(3, reservationNo); // reservation_no
	ticketStmt.setDouble(3, ticketFare);
	ticketStmt.setString(4, ticketType);
	ticketStmt.setBoolean(5, false); // Not expired
	ticketStmt.executeUpdate();
		} else {
	// Insert for one-way trip
	ticketStmt = conn.prepareStatement(
			"INSERT INTO Ticket (reservation_no, ticket_no, fare, ticketType, activatedAt, isExpired) VALUES (?, ?, ?, ?, NULL, ?)");
	ticketStmt.setInt(1, reservationNo);
	ticketStmt.setInt(2, i);
	ticketStmt.setDouble(3, ticketFare);
	ticketStmt.setString(4, ticketType);
	ticketStmt.setBoolean(5, false); // Not expired
	ticketStmt.executeUpdate();
		}
	}
}

// Commit the transaction
conn.commit();
out.println("Reservation confirmed!");
} catch (Exception e) {
if (conn != null) {
	try {
		conn.rollback(); // Rollback if an error occurs
	} catch (SQLException ex) {
		e.printStackTrace();
	}
}
out.println("Error: " + e.getMessage());
} finally {
// Clean up resources
try {
	if (generatedKeys != null) {
		generatedKeys.close();
	}
	if (ticketStmt != null) {
		ticketStmt.close();
	}
	if (reservationStmt != null) {
		reservationStmt.close();
	}
	if (conn != null) {
		conn.close();
	}
} catch (SQLException e) {
	e.printStackTrace();
}
}
%>
