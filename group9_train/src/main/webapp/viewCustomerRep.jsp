<%@ include file="checkAdmin.jsp"%>
<%@ include file="navbar.jsp"%>
<%@ page import="java.sql.*, java.util.*"%>
<%
// List to store customer representative details
List<Map<String, Object>> customerReps = new ArrayList<>();

try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
	// Query to fetch customer representatives
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

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Customer Representatives</title>
<link rel="stylesheet" href="viewCustomerRep_styles.css">
</head>
<body>


	<div class="container">
		<h1>Customer Representatives</h1>

		<!-- Add New Customer Representative Button -->
		<div class="add-rep">
			<a href="addCustomerRep.jsp" class="btn">Add New Customer
				Representative</a>
		</div>

		<!-- List of Customer Representatives -->
		<%
		if (!customerReps.isEmpty()) {
		%>
		<table>
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
				<%
				for (Map<String, Object> rep : customerReps) {
				%>
				<tr>
					<td><%=rep.get("employeeId")%></td>
					<td><%=rep.get("ssn")%></td>
					<td><%=rep.get("username")%></td>
					<td><%=rep.get("firstName")%></td>
					<td><%=rep.get("lastName")%></td>
					<td><a
						href="editCustomerRep.jsp?employeeId=<%=rep.get("employeeId")%>"
						class="btn edit">Edit</a> <a
						href="deleteCustomerRep.jsp?employeeId=<%=rep.get("employeeId")%>"
						class="btn delete"
						onclick="return confirm('Are you sure you want to remove this customer representative?')">Remove</a>
					</td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
		<%
		} else {
		%>
		<p>No customer representatives found.</p>
		<%
		}
		%>
	</div>
</body>
</html>
