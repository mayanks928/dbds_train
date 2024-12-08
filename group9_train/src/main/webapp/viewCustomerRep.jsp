<%@ include file="checkAdmin.jsp"%>
<%@ include file="navbar.jsp"%>
<%@ page import="java.sql.*, java.util.*"%>
<%
List<Map<String, Object>> customerReps = new ArrayList<>();
try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
    String sql = "SELECT employee_id, ssn, username, first_name, last_name FROM Employee WHERE role = 'CustomerRepresentative'";
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    while (rs.next()) {
        Map<String, Object> rep = new HashMap<>();
        rep.put("employeeId", rs.getInt("employee_id"));
        rep.put("ssn", rs.getString("ssn"));
        rep.put("username", rs.getString("username"));
        rep.put("firstName", rs.getString("first_name"));
        rep.put("lastName", rs.getString("last_name"));
        customerReps.add(rep);
    }
} catch (Exception e) {
    e.printStackTrace();
}
%>
<div class="container my-5">
    <h1 class="text-center mb-4">Customer Representatives</h1>
    <div class="text-center mb-3">
        <a href="addCustomerRep.jsp" class="btn btn-primary">Add New Customer Representative</a>
    </div>
    <% if (!customerReps.isEmpty()) { %>
    <div class="table-responsive">
        <table class="table table-striped align-middle">
            <thead>
                <tr>
                    <th>Employee ID</th>
                    <th>SSN</th>
                    <th>Username</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, Object> rep : customerReps) { %>
                <tr>
                    <td><%=rep.get("employeeId")%></td>
                    <td><%=rep.get("ssn")%></td>
                    <td><%=rep.get("username")%></td>
                    <td><%=rep.get("firstName")%></td>
                    <td><%=rep.get("lastName")%></td>
                    <td>
                        <a href="editCustomerRep.jsp?employeeId=<%=rep.get("employeeId")%>" class="btn btn-success btn-sm">Edit</a>
                        <a href="deleteCustomerRep.jsp?employeeId=<%=rep.get("employeeId")%>" class="btn btn-danger btn-sm"
                           onclick="return confirm('Are you sure you want to remove this customer representative?')">Remove</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } else { %>
    <div class="alert alert-secondary text-center">No customer representatives found.</div>
    <% } %>
</div>
