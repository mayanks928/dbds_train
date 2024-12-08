<%@ include file="checkAdmin.jsp" %>
<%@ include file="navbar.jsp" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection conn = null;
    PreparedStatement psBestCustomer = null, psTopTransit = null;
    ResultSet rsBestCustomer = null, rsTopTransit = null;

    // Initialize variables to store stats
    String bestCustomerName = "";
    double bestCustomerRevenue = 0;
    int bestCustomerTickets = 0;
    List<Map<String, Object>> topTransitLines = new ArrayList<>();

    try {
        conn = com.example.util.DBConnectionUtil.getConnection();

        // Query to find the best customer (highest ticket count and revenue)
        String sqlBestCustomer = "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customerName, " +
                                  "SUM(t.fare) AS totalRevenue, COUNT(t.ticket_no) AS totalTickets " +
                                  "FROM Customer c " +
                                  "JOIN Reservation r ON c.customer_id = r.customer_id " +
                                  "JOIN Ticket t ON r.reservation_no = t.reservation_no " +
                                  "WHERE r.isCancelled = FALSE AND t.isExpired = FALSE " +
                                  "GROUP BY c.customer_id " +
                                  "ORDER BY totalRevenue DESC " +
                                  "LIMIT 1";
        psBestCustomer = conn.prepareStatement(sqlBestCustomer);
        rsBestCustomer = psBestCustomer.executeQuery();
        if (rsBestCustomer.next()) {
            bestCustomerName = rsBestCustomer.getString("customerName");
            bestCustomerRevenue = rsBestCustomer.getDouble("totalRevenue");
            bestCustomerTickets = rsBestCustomer.getInt("totalTickets");
        }

        // Query to find the top 5 most active transit lines
        String sqlTopTransit = "SELECT t.transit_name, COUNT(tc.ticket_no) AS totalTickets, SUM(tc.fare) AS totalRevenue " +
                               "FROM Transit_Line t " +
                               "JOIN Reservation r ON t.transit_id = r.reservedForTransit " +
                               "JOIN Ticket tc ON r.reservation_no = tc.reservation_no " +
                               "WHERE r.isCancelled = FALSE AND tc.isExpired = FALSE " +
                               "GROUP BY t.transit_id " +
                               "ORDER BY totalTickets DESC " +
                               "LIMIT 5";
        psTopTransit = conn.prepareStatement(sqlTopTransit);
        rsTopTransit = psTopTransit.executeQuery();
        while (rsTopTransit.next()) {
            Map<String, Object> transitData = new HashMap<>();
            transitData.put("transitName", rsTopTransit.getString("transit_name"));
            transitData.put("tickets", rsTopTransit.getInt("totalTickets"));
            transitData.put("revenue", rsTopTransit.getDouble("totalRevenue"));
            topTransitLines.add(transitData);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsBestCustomer != null) rsBestCustomer.close();
        if (psBestCustomer != null) psBestCustomer.close();
        if (rsTopTransit != null) rsTopTransit.close();
        if (psTopTransit != null) psTopTransit.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="admin_styles.css">
</head>
<body>
    <div class="container">
        <h1>Admin Dashboard</h1>
        <div class="links">
            <h2>Manage Customer Representatives</h2>
            <ul>
                <li><a href="viewCustomerRep.jsp">View/Edit/Add Customer Representatives</a></li>
            </ul>

            <h2>Reports</h2>
            <ul>
                <li><a href="salesReport.jsp">View Monthly Sales Report</a></li>
                <li><a href="resrev.jsp">View Reservations and Revenues for Transit Lines and Customers</a></li>
            </ul>
        </div>

        <div class="stats">
            <h2>Best Customer</h2>
            <% if (!bestCustomerName.isEmpty()) { %>
                <p><strong>Name:</strong> <%= bestCustomerName %></p>
                <p><strong>Total Revenue:</strong> $<%= String.format("%.2f", bestCustomerRevenue) %></p>
                <p><strong>Total Tickets:</strong> <%= bestCustomerTickets %></p>
            <% } else { %>
                <p>No data available.</p>
            <% } %>

            <h2>Top 5 Most Active Transit Lines</h2>
            <% if (!topTransitLines.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Transit Line</th>
                            <th>Total Tickets</th>
                            <th>Total Revenue</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, Object> line : topTransitLines) { %>
                            <tr>
                                <td><%= line.get("transitName") %></td>
                                <td><%= line.get("tickets") %></td>
                                <td>$<%= String.format("%.2f", line.get("revenue")) %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p>No data available.</p>
            <% } %>
        </div>
    </div>
</body>
</html>
