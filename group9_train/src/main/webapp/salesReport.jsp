<%@ include file="checkAdmin.jsp"%>
<%@ include file="navbar.jsp"%>
<%@ page import="java.sql.*" %>
<%
String selectedMonth = request.getParameter("month");
String selectedYear = request.getParameter("year");

int numCustomers = 0;
int numTickets = 0;
int numReservations = 0;
int numCancelledReservations = 0;
double totalFare = 0.0;

if (selectedMonth != null && selectedYear != null) {
    try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
        String sql = "SELECT COUNT(DISTINCT r.customer_id) AS numCustomers, SUM(CASE WHEN r.isCancelled = FALSE THEN 1 ELSE 0 END) AS numTickets, " +
                     "COUNT(DISTINCT r.reservation_no) AS numReservations, SUM(CASE WHEN r.isCancelled = FALSE THEN t.fare ELSE 0 END) AS totalFare, " +
                     "SUM(CASE WHEN r.isCancelled = TRUE THEN 1 ELSE 0 END) AS numCancelledReservations " +
                     "FROM Reservation r JOIN Ticket t ON r.reservation_no = t.reservation_no " +
                     "WHERE MONTH(r.reservedAt) = ? AND YEAR(r.reservedAt) = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(selectedMonth));
        ps.setInt(2, Integer.parseInt(selectedYear));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            numCustomers = rs.getInt("numCustomers");
            numTickets = rs.getInt("numTickets");
            numReservations = rs.getInt("numReservations");
            totalFare = rs.getDouble("totalFare");
            numCancelledReservations = rs.getInt("numCancelledReservations");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>
<div class="container my-5">
    <h1 class="text-center mb-4">Sales Report</h1>

    <form method="GET" action="salesReport.jsp" class="card p-4 shadow-sm mb-4" style="max-width:400px; margin:0 auto;">
        <div class="mb-3">
            <label for="month" class="form-label">Month:</label>
            <select id="month" name="month" class="form-select">
                <option value="">-- Select Month --</option>
                <option value="1" <%= "1".equals(selectedMonth) ? "selected" : "" %>>January</option>
                <option value="2" <%= "2".equals(selectedMonth) ? "selected" : "" %>>February</option>
                <option value="3" <%= "3".equals(selectedMonth) ? "selected" : "" %>>March</option>
                <option value="4" <%= "4".equals(selectedMonth) ? "selected" : "" %>>April</option>
                <option value="5" <%= "5".equals(selectedMonth) ? "selected" : "" %>>May</option>
                <option value="6" <%= "6".equals(selectedMonth) ? "selected" : "" %>>June</option>
                <option value="7" <%= "7".equals(selectedMonth) ? "selected" : "" %>>July</option>
                <option value="8" <%= "8".equals(selectedMonth) ? "selected" : "" %>>August</option>
                <option value="9" <%= "9".equals(selectedMonth) ? "selected" : "" %>>September</option>
                <option value="10" <%= "10".equals(selectedMonth) ? "selected" : "" %>>October</option>
                <option value="11" <%= "11".equals(selectedMonth) ? "selected" : "" %>>November</option>
                <option value="12" <%= "12".equals(selectedMonth) ? "selected" : "" %>>December</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="year" class="form-label">Year:</label>
            <input type="number" id="year" name="year" class="form-control" value="<%= selectedYear != null ? selectedYear : "" %>" min="2024" required>
        </div>

        <button type="submit" class="btn btn-success w-100">Generate Report</button>
    </form>

    <%
    if (selectedMonth != null && selectedYear != null) {
    %>
    <h2 class="mb-3 text-center">Sales Report for <%=selectedMonth%>/<%=selectedYear%></h2>
    <div class="table-responsive">
        <table class="table table-striped align-middle">
            <tr>
                <th>Number of Different Customers</th>
                <td><%=numCustomers%></td>
            </tr>
            <tr>
                <th>Total Number of Tickets</th>
                <td><%=numTickets%></td>
            </tr>
            <tr>
                <th>Number of Reservations</th>
                <td><%=numReservations%></td>
            </tr>
            <tr>
                <th>Number of Cancelled Reservations</th>
                <td><%=numCancelledReservations%></td>
            </tr>
            <tr>
                <th>Total Fare (excluding cancelled)</th>
                <td>$<%=String.format("%.2f", totalFare)%></td>
            </tr>
        </table>
    </div>
    <%
    } else {
    %>
    <p class="text-center text-muted mt-4">Please select a month and year to generate the sales report.</p>
    <%
    }
    %>
</div>
