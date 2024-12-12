<%@ page import="java.sql.*,java.util.*, java.io.IOException, com.example.util.DBConnectionUtil" %>
<%
    // Initialize variables
    int ticketNo = Integer.parseInt(request.getParameter("ticketNo"));
    int reservationNo = Integer.parseInt(request.getParameter("reservationNo"));
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        // Establish database connection
        conn = DBConnectionUtil.getConnection();

        // Update query to activate the ticket
        String activateQuery = "UPDATE Ticket SET activatedAt = NOW(), isExpired = FALSE WHERE ticket_no = ? AND reservation_no = ?";
        ps = conn.prepareStatement(activateQuery);
        ps.setInt(1, ticketNo);
        ps.setInt(2, reservationNo);

        // Execute update
        int rowsUpdated = ps.executeUpdate();


        // Prepare the redirect URL
        StringBuilder redirectURL = new StringBuilder("viewTickets.jsp?message=");
        if (rowsUpdated > 0) {
            redirectURL.append("Ticket%20activated%20successfully");
        } else {
            redirectURL.append("Error%20activating%20ticket");
        }

        // Append all request parameters to the URL
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if (!"ticketNo".equals(paramName)) {
                redirectURL.append("&").append(paramName).append("=").append(java.net.URLEncoder.encode(paramValue, "UTF-8"));
            }
        }

        // Redirect back to viewTickets.jsp
        response.sendRedirect(redirectURL.toString());

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("viewTickets.jsp?message=An%20unexpected%20error%20occurred");
    } finally {
        // Close resources
        if (ps != null) try { ps.close(); } catch (Exception e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
