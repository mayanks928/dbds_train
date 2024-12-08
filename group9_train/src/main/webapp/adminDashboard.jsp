<%@ include file="checkAdmin.jsp" %>
<%@ include file="navbar.jsp" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection conn = null;
    PreparedStatement psBestCustomer = null, psTopTransit = null;
    ResultSet rsBestCustomer = null, rsTopTransit = null;

    String bestCustomerName = "";
    double bestCustomerRevenue = 0;
    int bestCustomerTickets = 0;
    List<Map<String, Object>> topTransitLines = new ArrayList<>();

    try {
        conn = com.example.util.DBConnectionUtil.getConnection();

        String sqlBestCustomer = "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customerName, SUM(t.fare) AS totalRevenue, COUNT(t.ticket_no) AS totalTickets " +
                                 "FROM Customer c " +
                                 "JOIN Reservation r ON c.customer_id = r.customer_id " +
                                 "JOIN Ticket t ON r.reservation_no = t.reservation_no " +
                                 "WHERE r.isCancelled = FALSE AND t.isExpired = FALSE " +
                                 "GROUP BY c.customer_id ORDER BY totalRevenue DESC LIMIT 1";
        psBestCustomer = conn.prepareStatement(sqlBestCustomer);
        rsBestCustomer = psBestCustomer.executeQuery();
        if (rsBestCustomer.next()) {
            bestCustomerName = rsBestCustomer.getString("customerName");
            bestCustomerRevenue = rsBestCustomer.getDouble("totalRevenue");
            bestCustomerTickets = rsBestCustomer.getInt("totalTickets");
        }

        String sqlTopTransit = "SELECT t.transit_name, COUNT(tc.ticket_no) AS totalTickets, SUM(tc.fare) AS totalRevenue " +
                               "FROM Transit_Line t " +
                               "JOIN Reservation r ON t.transit_id = r.reservedForTransit " +
                               "JOIN Ticket tc ON r.reservation_no = tc.reservation_no " +
                               "WHERE r.isCancelled = FALSE AND tc.isExpired = FALSE " +
                               "GROUP BY t.transit_id ORDER BY totalTickets DESC LIMIT 5";
        psTopTransit = conn.prepareStatement(sqlTopTransit);
        rsTopTransit = psTopTransit.executeQuery();
        while (rsTopTransit.next()) {
            Map<String, Object> line = new HashMap<>();
            line.put("transitName", rsTopTransit.getString("transit_name"));
            line.put("tickets", rsTopTransit.getInt("totalTickets"));
            line.put("revenue", rsTopTransit.getDouble("totalRevenue"));
            topTransitLines.add(line);
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

<div class="container my-5">
    <h1 class="text-center mb-4">Admin Dashboard</h1>
    <div class="card p-4 shadow-sm mb-4">
        <h2>Manage Customer Representatives</h2>
        <ul class="list-group list-group-flush mt-3">
            <li class="list-group-item"><a href="viewCustomerRep.jsp" class="text-decoration-none">View/Edit/Add Customer Representatives</a></li>
        </ul>
    </div>

    <div class="card p-4 shadow-sm">
        <h2>Reports</h2>
        <ul class="list-group list-group-flush mt-3">
            <li class="list-group-item"><a href="salesReport.jsp" class="text-decoration-none">View Monthly Sales Report</a></li>
            <li class="list-group-item"><a href="resrev.jsp" class="text-decoration-none">View Reservations and Revenues</a></li>
        </ul>
    </div>

    <div class="my-5">
        <h2 class="mb-3">Best Customer</h2>
        <% if (!bestCustomerName.isEmpty()) { %>
        <div class="alert alert-info">
            <p><strong>Name:</strong> <%= bestCustomerName %></p>
            <p><strong>Total Revenue:</strong> $<%= String.format("%.2f", bestCustomerRevenue) %></p>
            <p><strong>Total Tickets:</strong> <%= bestCustomerTickets %></p>
        </div>
        <% } else { %>
        <div class="alert alert-secondary">No data available.</div>
        <% } %>

        <h2 class="mt-5 mb-3">Top 5 Most Active Transit Lines</h2>
        <% if (!topTransitLines.isEmpty()) { %>
        <div class="table-responsive">
            <table class="table table-striped align-middle">
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
        </div>
        <% } else { %>
        <div class="alert alert-secondary">No data available.</div>
        <% } %>
    </div>
</div>
