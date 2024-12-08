<%@ page import="java.sql.*, java.util.*, com.example.util.DBConnectionUtil" %>
<%@ include file="navbar.jsp" %>
<%
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

    String sqlReservation = "SELECT isCancelled FROM Reservation WHERE reservation_no = ?";
    psReservation = conn.prepareStatement(sqlReservation);
    psReservation.setInt(1, reservationNo);
    ResultSet rsReservation = psReservation.executeQuery();
    if (rsReservation.next()) {
        isCancelled = rsReservation.getBoolean("isCancelled");
    }

    String sqlTickets = "SELECT * FROM Ticket WHERE reservation_no = ?";
    psTickets = conn.prepareStatement(sqlTickets);
    psTickets.setInt(1, reservationNo);
    rsTickets = psTickets.executeQuery();

    List<Map<String,Object>> tickets = new ArrayList<>();
    while (rsTickets.next()) {
        Map<String,Object> ticketData = new HashMap<>();
        ticketData.put("ticketNo", rsTickets.getInt("ticket_no"));
        ticketData.put("fare", rsTickets.getDouble("fare"));
        ticketData.put("ticketType", rsTickets.getString("ticketType"));
        ticketData.put("activatedAt", rsTickets.getTimestamp("activatedAt"));
        ticketData.put("isExpired", rsTickets.getBoolean("isExpired"));
        ticketData.put("isReturn", rsTickets.getBoolean("isReturn"));
        tickets.add(ticketData);
    }
%>
<div class="container my-5">
    <h1 class="text-center mb-4">Tickets for Reservation #<%= reservationNo %></h1>

    <div class="card p-4 shadow-sm mb-4 <%= isCancelled ? "border-danger" : "" %>">
        <h2>Reservation Details</h2>
        <p><strong>Departure:</strong> <%= departureStation %></p>
        <p><strong>Destination:</strong> <%= destinationStation %></p>
        <p><strong>Transit:</strong> <%= transitName %></p>
        <p><strong>Total Fare:</strong> $<%= String.format("%.2f", totalFare) %></p>
        <p><strong>Reserved At:</strong> <%= reservedAt %></p>
        <% if (isCancelled) { %>
        <p class="text-danger fw-bold">This reservation has been canceled. Ticket activation is not allowed.</p>
        <% } %>
    </div>

    <h2 class="mb-4">Tickets</h2>
    <%
    if (tickets.isEmpty()) {
    %>
    <div class="alert alert-secondary text-center">No tickets found for this reservation.</div>
    <%
    } else {
        for (Map<String,Object> ticket : tickets) {
            int ticketNo = (int) ticket.get("ticketNo");
            double fare = (double) ticket.get("fare");
            String ticketType = (String) ticket.get("ticketType");
            Timestamp activatedAt = (Timestamp) ticket.get("activatedAt");
            boolean isExpired = (boolean) ticket.get("isExpired");
            boolean isReturn = (boolean) ticket.get("isReturn");
    %>
    <div class="card p-3 mb-3 shadow-sm <%= isExpired ? "bg-light text-muted" : "" %>">
        <p><strong>Ticket #:</strong> <%= ticketNo %></p>
        <p><strong>Fare:</strong> $<%= String.format("%.2f", fare) %></p>
        <p><strong>Type:</strong> <%= ticketType %></p>
        <% if (isReturn) { %>
        <p><strong>Return Ticket:</strong> <%= destinationStation %> -> <%= departureStation %></p>
        <% } else { %>
        <p><strong>Outbound Ticket:</strong> <%= departureStation %> -> <%= destinationStation %></p>
        <% } %>

        <% if (isCancelled) { %>
        <p class="text-danger fw-bold">Activation not allowed: Reservation canceled</p>
        <% } else if (activatedAt == null) { %>
        <p><strong>Status:</strong> Not Activated</p>
        <form action="activateTicket.jsp" method="post">
            <input type="hidden" name="ticketNo" value="<%= ticketNo %>">
            <input type="hidden" name="reservationNo" value="<%= reservationNo %>">
            <button type="submit" class="btn btn-primary btn-sm">Activate Ticket</button>
        </form>
        <% } else { %>
        <p><strong>Activated At:</strong> <%= activatedAt.toString() %></p>
        <% if (isExpired) { %>
        <p class="text-danger fw-bold">This ticket is expired.</p>
        <% } else { %>
        <p><strong>Status:</strong> Active</p>
        <% } } %>
    </div>
    <% } } %>

    <p class="text-center text-muted mt-3" style="font-size:13px;">Note: Tickets expire 3 hours after activation.</p>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
    out.println("<div class='container my-5'><div class='alert alert-danger'>Error retrieving tickets. Please try again later.</div></div>");
} finally {
    if (rsTickets != null) rsTickets.close();
    if (psTickets != null) psTickets.close();
    if (psReservation != null) psReservation.close();
    if (conn != null) conn.close();
}
%>
