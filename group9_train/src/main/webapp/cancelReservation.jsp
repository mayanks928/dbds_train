<%@ page import="com.example.util.DBConnectionUtil, java.sql.*" %>
<%
    // Database connection
    Connection conn = null;
    PreparedStatement psCheckTickets = null;
    PreparedStatement psUpdateReservation = null;
    ResultSet rsTickets = null;

    try {
        // Retrieve reservation_no from the request
        int reservationNo = Integer.parseInt(request.getParameter("reservationNo"));

        // Database connection setup
        conn = DBConnectionUtil.getConnection();

        // Check if any ticket for this reservation is activated
        String sqlCheckTickets = "SELECT COUNT(*) AS activatedCount FROM Ticket WHERE reservation_no = ? AND activatedAt IS NOT NULL";
        psCheckTickets = conn.prepareStatement(sqlCheckTickets);
        psCheckTickets.setInt(1, reservationNo);

        rsTickets = psCheckTickets.executeQuery();
        int activatedCount = 0;
        if (rsTickets.next()) {
            activatedCount = rsTickets.getInt("activatedCount");
        }

        if (activatedCount > 0) {
            // If any ticket is activated, disallow cancellation
            session.setAttribute("message", "Cancellation failed: Reservation #" + reservationNo + " has activated tickets.");
        } else {
            // If all tickets are unactivated, proceed with cancellation
            String sqlUpdate = "UPDATE Reservation SET isCancelled = TRUE WHERE reservation_no = ?";
            psUpdateReservation = conn.prepareStatement(sqlUpdate);
            psUpdateReservation.setInt(1, reservationNo);

            int rowsAffected = psUpdateReservation.executeUpdate();

            if (rowsAffected > 0) {
                // Successful cancellation message
                session.setAttribute("message", "Reservation #" + reservationNo + " was successfully cancelled.");
            } else {
                session.setAttribute("message", "Error: Unable to cancel reservation. Please try again.");
            }
        }

        // Redirect back to reservations.jsp
        response.sendRedirect("reservations.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("message", "An error occurred while cancelling the reservation. Please try again.");
        response.sendRedirect("reservations.jsp");
    } finally {
        // Close resources
        try {
            if (rsTickets != null) rsTickets.close();
            if (psCheckTickets != null) psCheckTickets.close();
            if (psUpdateReservation != null) psUpdateReservation.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>
