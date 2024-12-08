<%@ include file="checkAdmin.jsp" %>
<%@ include file="navbar.jsp" %>
<%@ page import="java.sql.*, java.util.*"%>
<%
String filterType = request.getParameter("filterType");
String selectedTransit = request.getParameter("transitLine");
String customerInput = request.getParameter("customerName");

List<Map<String, Object>> reservations = new ArrayList<>();
double totalRevenue = 0.0;

try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
    PreparedStatement ps = null;
    ResultSet rs = null;

    if ("transit".equalsIgnoreCase(filterType) && selectedTransit != null) {
        String sqlTransit = "SELECT r.reservation_no, r.total_fare, r.reservedAt,r.isCancelled, CONCAT(c.first_name, ' ', c.last_name) AS customerName "
                          + "FROM Reservation r JOIN Customer c ON r.customer_id = c.customer_id "
                          + "JOIN Transit_Line t ON r.reservedForTransit = t.transit_id WHERE t.transit_id = ?";
        ps = conn.prepareStatement(sqlTransit);
        ps.setInt(1, Integer.parseInt(selectedTransit));
    } else if ("customer".equalsIgnoreCase(filterType) && customerInput != null) {
        String sqlCustomer = "SELECT r.reservation_no, r.total_fare, r.reservedAt, r.isCancelled, CONCAT(c.first_name, ' ', c.last_name) AS customerName "
                           + "FROM Reservation r JOIN Customer c ON r.customer_id = c.customer_id "
                           + "WHERE CONCAT(c.first_name, ' ', c.last_name) LIKE ? COLLATE utf8mb4_general_ci";
        ps = conn.prepareStatement(sqlCustomer);
        ps.setString(1, "%" + customerInput + "%");
    }

    if (ps != null) {
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> reservationData = new HashMap<>();
            reservationData.put("reservationNo", rs.getInt("reservation_no"));
            reservationData.put("totalFare", rs.getDouble("total_fare"));
            reservationData.put("reservedAt", rs.getTimestamp("reservedAt"));
            reservationData.put("customerName", rs.getString("customerName"));
            reservationData.put("isCancelled", rs.getBoolean("isCancelled"));
            reservations.add(reservationData);

            if (!rs.getBoolean("isCancelled")) {
                totalRevenue += rs.getDouble("total_fare");
            }
        }
    }
} catch (Exception e) {
    e.printStackTrace();
}
%>
<div class="container my-5">
    <h1 class="text-center mb-4">Reservations and Revenue</h1>
    <form method="GET" action="resrev.jsp" class="card p-4 shadow-sm mb-4">
        <div class="mb-3">
            <label for="filterType" class="form-label">Filter By:</label>
            <select id="filterType" name="filterType" class="form-select" onchange="toggleFilterOptions()">
                <option value="">-- Select --</option>
                <option value="transit" <%= "transit".equalsIgnoreCase(filterType) ? "selected" : "" %>>Transit Line</option>
                <option value="customer" <%= "customer".equalsIgnoreCase(filterType) ? "selected" : "" %>>Customer Name</option>
            </select>
        </div>

        <div id="transitOptions" style="display: <%= "transit".equalsIgnoreCase(filterType) ? "block" : "none" %>;" class="mb-3">
            <label for="transitLine" class="form-label">Select Transit Line:</label>
            <select id="transitLine" name="transitLine" class="form-select">
                <option value="">-- Select Transit Line --</option>
                <%
                try (Connection conn = com.example.util.DBConnectionUtil.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT transit_id, transit_name FROM Transit_Line")) {
                    while (rs.next()) {
                %>
                <option value="<%=rs.getInt("transit_id")%>" <%= (selectedTransit != null && selectedTransit.equals(String.valueOf(rs.getInt("transit_id")))) ? "selected" : "" %>>
                    <%=rs.getString("transit_name")%>
                </option>
                <%
                    }
                } catch (Exception e) { e.printStackTrace(); }
                %>
            </select>
        </div>

        <div id="customerOptions" style="display: <%= "customer".equalsIgnoreCase(filterType) ? "block" : "none" %>;" class="mb-3">
            <label for="customerName" class="form-label">Enter Customer Name:</label>
            <input type="text" id="customerName" name="customerName" class="form-control" value="<%=customerInput != null ? customerInput : ""%>">
        </div>

        <button type="submit" class="btn btn-primary w-100">Submit</button>
    </form>

    <div class="results">
        <%
        if (filterType != null && reservations.isEmpty()) {
        %>
        <div class="alert alert-secondary">No results found for the selected criteria.</div>
        <%
        } else if (!reservations.isEmpty()) {
        %>
        <h2 class="mb-3">Reservations</h2>
        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead>
                    <tr>
                        <th>Reservation No</th>
                        <th>Total Fare</th>
                        <th>Reserved At</th>
                        <th>Customer Name</th>
                        <th>Cancelled</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    for (Map<String, Object> reservation : reservations) {
                        boolean isCancelled = (Boolean) reservation.get("isCancelled");
                    %>
                    <tr>
                        <td><%=reservation.get("reservationNo")%></td>
                        <td>$<%=String.format("%.2f", reservation.get("totalFare"))%></td>
                        <td><%=reservation.get("reservedAt")%></td>
                        <td><%=reservation.get("customerName")%></td>
                        <td><%= isCancelled ? "Yes" : "No" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <h2 class="mt-5 mb-3">Total Revenue</h2>
        <p>$<%=String.format("%.2f", totalRevenue)%></p>
        <%
        }
        %>
    </div>
</div>

<script>
function toggleFilterOptions() {
    const filterType = document.getElementById("filterType").value;
    document.getElementById("transitOptions").style.display = filterType === "transit" ? "block" : "none";
    document.getElementById("customerOptions").style.display = filterType === "customer" ? "block" : "none";
}
</script>
