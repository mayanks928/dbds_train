<%@ page import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*, org.json.*" %>
<%@ page session="true"%>
<%@ include file="navbar.jsp" %>
<%
    Connection conn = null;
    PreparedStatement psReservation = null;
    PreparedStatement psTicket = null;

    try {
        conn = DBConnectionUtil.getConnection();
        conn.setAutoCommit(false);

        int customerId = Integer.parseInt(request.getParameter("customerId"));
        double totalFare = Double.parseDouble(request.getParameter("totalFare"));
        String paymentMode = request.getParameter("payment_mode");
        int originId = Integer.parseInt(request.getParameter("originId"));
        int destinationId = Integer.parseInt(request.getParameter("destinationId"));
        int transitId = Integer.parseInt(request.getParameter("transitId"));
        String ticketsDataJson = request.getParameter("ticketsData");
        JSONArray ticketsData = new JSONArray(ticketsDataJson);

        String sqlReservation = "INSERT INTO Reservation (customer_id, total_fare, payment_mode, reservedAt, departure_from, destination_at, reservedForTransit) VALUES (?, ?, ?, NOW(), ?, ?, ?)";
        psReservation = conn.prepareStatement(sqlReservation, Statement.RETURN_GENERATED_KEYS);
        psReservation.setInt(1, customerId);
        psReservation.setDouble(2, totalFare);
        psReservation.setString(3, paymentMode);
        psReservation.setInt(4, originId);
        psReservation.setInt(5, destinationId);
        psReservation.setInt(6, transitId);
        psReservation.executeUpdate();

        ResultSet rsReservation = psReservation.getGeneratedKeys();
        rsReservation.next();
        int reservationNo = rsReservation.getInt(1);

        String sqlTicket = "INSERT INTO Ticket (reservation_no, ticket_no, fare, ticketType, activatedAt, isExpired, isReturn) VALUES (?, ?, ?, ?, NULL, 0, ?)";
        psTicket = conn.prepareStatement(sqlTicket);

        int ticketNo = 1;
        for (int i = 0; i < ticketsData.length(); i++) {
            JSONObject ticket = ticketsData.getJSONObject(i);
            String ticketType = ticket.getString("ticketType");
            double fare = ticket.getDouble("fare");
            String tripType = ticket.getString("tripType");

            if ("RoundTrip".equals(tripType)) {
                // Outbound
                psTicket.setInt(1, reservationNo);
                psTicket.setInt(2, ticketNo++);
                psTicket.setDouble(3, fare / 2);
                psTicket.setString(4, ticketType);
                psTicket.setBoolean(5, false);
                psTicket.addBatch();

                // Return
                psTicket.setInt(1, reservationNo);
                psTicket.setInt(2, ticketNo++);
                psTicket.setDouble(3, fare / 2);
                psTicket.setString(4, ticketType);
                psTicket.setBoolean(5, true);
                psTicket.addBatch();
            } else {
                psTicket.setInt(1, reservationNo);
                psTicket.setInt(2, ticketNo++);
                psTicket.setDouble(3, fare);
                psTicket.setString(4, ticketType);
                psTicket.setBoolean(5, false);
                psTicket.addBatch();
            }
        }

        psTicket.executeBatch();
        conn.commit();

        session.setAttribute("reservationNo", reservationNo);
        session.setAttribute("errorMessage", null);
        response.sendRedirect("confirmation.jsp");
    } catch (Exception e) {
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException se) { se.printStackTrace(); }

        session.setAttribute("errorMessage", "An error occurred while processing your reservation. Please try again.");
        e.printStackTrace();
        response.sendRedirect("confirmation.jsp");
    } finally {
        if (psReservation != null) psReservation.close();
        if (psTicket != null) psTicket.close();
        if (conn != null) {
            conn.setAutoCommit(true);
            conn.close();
        }
    }
%>
