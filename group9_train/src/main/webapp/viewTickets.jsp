<%@ page import="java.sql.*, java.util.*, com.example.util.DBConnectionUtil" %>
<%@ include file="navbar.jsp" %>
<%
    // Get reservation details from request parameters
    int reservationNo = Integer.parseInt(request.getParameter("reservationNo"));
    String departureStation = request.getParameter("departureStation");
    String destinationStation = request.getParameter("destinationStation");
    String transitName = request.getParameter("transitName");
    double totalFare = Double.parseDouble(request.getParameter("totalFare"));
    String reservedAt = request.getParameter("reservedAt");

    Connection conn = null;
    PreparedStatement psTickets = null;
    PreparedStatement psReservation = null;
    ResultSet rsTickets = null;
    boolean isCancelled = false;

    try {
        conn = DBConnectionUtil.getConnection();

        // Check if the reservation is canceled
        String sqlReservation = "SELECT isCancelled FROM Reservation WHERE reservation_no = ?";
        psReservation = conn.prepareStatement(sqlReservation);
        psReservation.setInt(1, reservationNo);
        ResultSet rsReservation = psReservation.executeQuery();
        if (rsReservation.next()) {
            isCancelled = rsReservation.getBoolean("isCancelled");
        }

        // Fetch tickets for the reservation
        String sqlTickets = "SELECT * FROM Ticket WHERE reservation_no = ?";
        psTickets = conn.prepareStatement(sqlTickets);
        psTickets.setInt(1, reservationNo);

        rsTickets = psTickets.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Tickets</title>
    <link rel="stylesheet" href="viewtickets_styles.css">
</head>
<body>
    <div class="container">
        <h1>Tickets for Reservation #<%= reservationNo %></h1>

        <!-- Display Reservation Details -->
        <div class="reservation-details card <%= isCancelled ? "cancelled-reservation" : "" %>">
            <h2>Reservation Details</h2>
            <p><strong>Departure:</strong> <%= departureStation %></p>
            <p><strong>Destination:</strong> <%= destinationStation %></p>
            <p><strong>Transit:</strong> <%= transitName %></p>
            <p><strong>Total Fare:</strong> $<%= String.format("%.2f", totalFare) %></p>
            <p><strong>Reserved At:</strong> <%= reservedAt %></p>
            <% if (isCancelled) { %>
                <p class="cancelled-warning">This reservation has been canceled. Ticket activation is not allowed.</p>
            <% } %>
        </div>

        <!-- Display Tickets -->
        <h2>Tickets</h2>
        <% 
        boolean hasTickets = false;
        while (rsTickets.next()) {
            hasTickets = true;

            int ticketNo = rsTickets.getInt("ticket_no");
            double fare = rsTickets.getDouble("fare");
            String ticketType = rsTickets.getString("ticketType");
            Timestamp activatedAt = rsTickets.getTimestamp("activatedAt");
            boolean isExpired = rsTickets.getBoolean("isExpired");
            boolean isReturn = rsTickets.getBoolean("isReturn");
        %>

        <div class="ticket-card <%= isExpired ? "expired-ticket" : "" %>">
            <p><strong>Ticket #:</strong> <%= ticketNo %></p>
            <p><strong>Fare:</strong> $<%= String.format("%.2f", fare) %></p>
            <p><strong>Type:</strong> <%= ticketType %></p>

            <% if (isReturn) { %>
                <p><strong>Return Ticket:</strong> <%= destinationStation %> -> <%= departureStation %></p>
            <% } else { %>
                <p><strong>Outbound Ticket:</strong> <%= departureStation %> -> <%= destinationStation %></p>
            <% } %>

            <% if (isCancelled) { %>
                <p class="ticket-status">Activation not allowed: Reservation canceled</p>
            <% } else if (activatedAt == null) { %>
                <p class="ticket-status">Status: Not Activated</p>
                <form action="activateTicket.jsp" method="post">
                    <input type="hidden" name="ticketNo" value="<%= ticketNo %>">
                    <input type="hidden" name="reservationNo" value="<%= reservationNo %>">
                    <button type="submit" class="btn-activate">Activate Ticket</button>
                </form>
            <% } else { %>
                <p><strong>Activated At:</strong> <%= activatedAt.toString() %></p>
            <% } %>
        </div>

        <% } %>

        <% if (!hasTickets) { %>
            <p class="no-tickets">No tickets found for this reservation.</p>
        <% } %>

        <!-- Ticket Expiry Note -->
        <p class="ticket-expiry-note">Note: Tickets expire 3 hours after activation.</p>
    </div>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error retrieving tickets. Please try again later.</p>");
    } finally {
        if (rsTickets != null) rsTickets.close();
        if (psTickets != null) psTickets.close();
        if (psReservation != null) psReservation.close();
        if (conn != null) conn.close();
    }
%>
