<%@ page import="java.sql.*, java.util.*, com.example.util.DBConnectionUtil"%>
<%@ include file="navbar.jsp"%>
<%
Integer customerId = (Integer) session.getAttribute("customerId");
if (customerId == null) {
    response.sendRedirect("login.jsp");
    return;
}

Connection conn = null;
PreparedStatement psReservations = null;
ResultSet rsReservations = null;
boolean hasReservations = false;
String message = (String) session.getAttribute("message");

try {
    conn = DBConnectionUtil.getConnection();
    String sql = "SELECT r.reservation_no, r.total_fare, r.payment_mode, r.reservedAt, " +
                 "s1.station_name AS departure_station, s2.station_name AS destination_station, " +
                 "t.transit_name, r.isCancelled " +
                 "FROM Reservation r " +
                 "JOIN Station s1 ON r.departure_from = s1.station_id " +
                 "JOIN Station s2 ON r.destination_at = s2.station_id " +
                 "JOIN Transit_Line t ON r.reservedForTransit = t.transit_id " +
                 "WHERE r.customer_id = ? ORDER BY r.reservedAt DESC";
    psReservations = conn.prepareStatement(sql);
    psReservations.setInt(1, customerId);
    rsReservations = psReservations.executeQuery();
%>
<div class="container my-5">
    <h1 class="text-center mb-4">My Reservations</h1>

    <% if (message != null) { %>
    <div class="alert <%= message.startsWith("Error") ? "alert-danger" : "alert-success" %>">
        <%= message %>
    </div>
    <%
       session.removeAttribute("message");
    }
    %>

    <%
    List<Map<String, Object>> reservationsList = new ArrayList<>();
    while (rsReservations.next()) {
        hasReservations = true;
        Map<String, Object> resv = new HashMap<>();
        resv.put("reservationNo", rsReservations.getInt("reservation_no"));
        resv.put("totalFare", rsReservations.getDouble("total_fare"));
        resv.put("paymentMode", rsReservations.getString("payment_mode"));
        resv.put("reservedAt", rsReservations.getTimestamp("reservedAt"));
        resv.put("departureStation", rsReservations.getString("departure_station"));
        resv.put("destinationStation", rsReservations.getString("destination_station"));
        resv.put("transitName", rsReservations.getString("transit_name"));
        resv.put("isCancelled", rsReservations.getBoolean("isCancelled"));
        reservationsList.add(resv);
    }
    %>

    <% if (!hasReservations) { %>
    <div class="alert alert-secondary text-center">No reservations found.</div>
    <% } else { %>
    <div class="table-responsive">
        <table class="table table-striped align-middle">
            <thead>
                <tr>
                    <th>Reservation #</th>
                    <th>Transit</th>
                    <th>Departure</th>
                    <th>Destination</th>
                    <th>Total Fare</th>
                    <th>Payment Mode</th>
                    <th>Reserved At</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> resv : reservationsList) {
                    int reservationNo = (int) resv.get("reservationNo");
                    String departureStation = (String) resv.get("departureStation");
                    String destinationStation = (String) resv.get("destinationStation");
                    String transitName = (String) resv.get("transitName");
                    double totalFare = (double) resv.get("totalFare");
                    String paymentMode = (String) resv.get("paymentMode");
                    Timestamp reservedAt = (Timestamp) resv.get("reservedAt");
                    boolean isCancelled = (boolean) resv.get("isCancelled");
                %>
                <tr>
                    <td><%=reservationNo%></td>
                    <td><%=transitName%></td>
                    <td><%=departureStation%></td>
                    <td><%=destinationStation%></td>
                    <td>$<%=String.format("%.2f", totalFare)%></td>
                    <td><%=paymentMode%></td>
                    <td><%=reservedAt.toString().substring(0,16)%></td>
                    <td><%= isCancelled ? "Cancelled" : "Active" %></td>
                    <td>
                        <% if (!isCancelled) { %>
                        <form action="cancelReservation.jsp" method="post" class="d-inline" onsubmit="return confirm('Are you sure you want to cancel this reservation?')">
                            <input type="hidden" name="reservationNo" value="<%=reservationNo%>">
                            <button type="submit" class="btn btn-danger btn-sm">Cancel</button>
                        </form>
                        <% } %>
                        <form action="viewTickets.jsp" method="get" class="d-inline">
                            <input type="hidden" name="reservationNo" value="<%=reservationNo%>">
                            <input type="hidden" name="departureStation" value="<%=departureStation%>">
                            <input type="hidden" name="destinationStation" value="<%=destinationStation%>">
                            <input type="hidden" name="transitName" value="<%=transitName%>">
                            <input type="hidden" name="totalFare" value="<%=totalFare%>">
                            <input type="hidden" name="reservedAt" value="<%=reservedAt%>">
                            <button type="submit" class="btn btn-secondary btn-sm">View Tickets</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
    out.println("<div class='container my-5'><div class='alert alert-danger'>Error retrieving reservations. Please try again later.</div></div>");
} finally {
    if (rsReservations != null) rsReservations.close();
    if (psReservations != null) psReservations.close();
    if (conn != null) conn.close();
}
%>
