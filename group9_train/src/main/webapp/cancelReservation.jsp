<%@ page import="com.example.util.DBConnectionUtil, java.sql.*" %>
<%
int reservationNo = Integer.parseInt(request.getParameter("reservationNo"));
Connection conn = null;
PreparedStatement psCheckTickets = null, psUpdateReservation = null;
ResultSet rsTickets = null;

try {
    conn = DBConnectionUtil.getConnection();
    String sqlCheckTickets = "SELECT COUNT(*) AS activatedCount FROM Ticket WHERE reservation_no = ? AND activatedAt IS NOT NULL";
    psCheckTickets = conn.prepareStatement(sqlCheckTickets);
    psCheckTickets.setInt(1, reservationNo);
    rsTickets = psCheckTickets.executeQuery();
    int activatedCount = 0;
    if (rsTickets.next()) {
        activatedCount = rsTickets.getInt("activatedCount");
    }

    if (activatedCount > 0) {
        session.setAttribute("message", "Cancellation failed: Reservation #" + reservationNo + " has activated tickets.");
    } else {
        String sqlUpdate = "UPDATE Reservation SET isCancelled = TRUE WHERE reservation_no = ?";
        psUpdateReservation = conn.prepareStatement(sqlUpdate);
        psUpdateReservation.setInt(1, reservationNo);
        int rowsAffected = psUpdateReservation.executeUpdate();
        if (rowsAffected > 0) {
            session.setAttribute("message", "Reservation #" + reservationNo + " was successfully cancelled.");
        } else {
            session.setAttribute("message", "Error: Unable to cancel reservation. Please try again.");
        }
    }

    response.sendRedirect("reservations.jsp");
} catch (Exception e) {
    e.printStackTrace();
    session.setAttribute("message", "An error occurred while cancelling the reservation. Please try again.");
    response.sendRedirect("reservations.jsp");
} finally {
    if (rsTickets != null) rsTickets.close();
    if (psCheckTickets != null) psCheckTickets.close();
    if (psUpdateReservation != null) psUpdateReservation.close();
    if (conn != null) conn.close();
}
%>
