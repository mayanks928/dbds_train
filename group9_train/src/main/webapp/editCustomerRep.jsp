<%@ page import="java.sql.*"%>
<%@ include file="checkAdmin.jsp"%>
<%@ include file="navbar.jsp"%>
<%
    // Initialize variables
    String employeeId = request.getParameter("employeeId");
    String errorMessage = null;
    String successMessage = null;

    // Declare employee details variables
    String ssn = "";
    String username = "";
    String password = "";
    String firstName = "";
    String lastName = "";
    String role = "";

    if (employeeId != null) {
        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
            // Fetch existing employee details
            String sql = "SELECT ssn, username,password, first_name, last_name, role FROM Employee WHERE employee_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(employeeId));
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    ssn = rs.getString("ssn");
                    username = rs.getString("username");
                    password=rs.getString("password");
                    firstName = rs.getString("first_name");
                    lastName = rs.getString("last_name");
                    role = rs.getString("role");
                } else {
                    errorMessage = "No Customer Representative found with the provided ID.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "An error occurred while fetching employee details.";
        }
    }

    // Handle form submission
    if (request.getMethod().equalsIgnoreCase("POST")) {
        ssn = request.getParameter("ssn");
        username = request.getParameter("username");
        password = request.getParameter("password");
        firstName = request.getParameter("first_name");
        lastName = request.getParameter("last_name");
        role = request.getParameter("role");

        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
            String updateSql = "UPDATE Employee SET ssn = ?, username = ?, password = ?, first_name = ?, last_name = ?, role = ? WHERE employee_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, ssn);
                ps.setString(2, username);
                ps.setString(3, password);
                ps.setString(4, firstName);
                ps.setString(5, lastName);
                ps.setString(6, role);
                ps.setInt(7, Integer.parseInt(employeeId));

                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    successMessage = "Customer Representative details updated successfully!";
                    response.sendRedirect("viewCustomerRep.jsp");
                    return;
                } else {
                    errorMessage = "Failed to update Customer Representative details.";
                }
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            if (e.getMessage().contains("ssn")) {
                errorMessage = "SSN must be unique. This SSN is already in use.";
            } else if (e.getMessage().contains("username")) {
                errorMessage = "Username must be unique. This username is already in use.";
            } else {
                errorMessage = "A database error occurred.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "An error occurred while updating employee details.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Customer Representative</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f4f4f4;
}

.container {
	max-width: 600px;
	margin: 50px auto;
	background: #fff;
	padding: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h1 {
	font-size: 24px;
	text-align: center;
}

form {
	margin-top: 20px;
}

label {
	display: block;
	font-weight: bold;
	margin-bottom: 5px;
}

input, select {
	width: 100%;
	padding: 10px;
	margin-bottom: 15px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

button {
	width: 100%;
	padding: 10px;
	background: #007bff;
	color: #fff;
	border: none;
	border-radius: 4px;
	font-size: 16px;
	cursor: pointer;
}

button:hover {
	background: #0056b3;
}

.error-message {
	color: #d9534f;
	margin-bottom: 15px;
}

.success-message {
	color: #5cb85c;
	margin-bottom: 15px;
}
</style>
</head>
<body>
	<div class="container">
		<h1>Edit Customer Representative</h1>

		<% if (errorMessage != null) { %>
		<div class="error-message"><%= errorMessage %></div>
		<% } else if (successMessage != null) { %>
		<div class="success-message"><%= successMessage %></div>
		<% } %>

		<% 
        
		if (employeeId != null && errorMessage == null) { 
        
        %>
		<form method="POST"
			action="editCustomerRep.jsp?employee_id=<%= employeeId %>">
			<label for="ssn">SSN:</label> <input type="text" id="ssn" name="ssn"
				value="<%= ssn %>" required> <label for="username">Username:</label>
			<input type="text" id="username" name="username"
				value="<%= username %>" required> <label for="password">Password:</label>
			<input type="password" id="password" name="password" 
			value=<%= password %> required>

			<label for="first_name">First Name:</label> <input type="text"
				id="first_name" name="first_name" value="<%= firstName %>" required>

			<label for="last_name">Last Name:</label> <input type="text"
				id="last_name" name="last_name" value="<%= lastName %>"> <label
				for="role">Role:</label> <select id="role" name="role" required>
				<option value="CustomerRepresentative"
					<%= "CustomerRepresentative".equals(role) ? "selected" : "" %>>Customer
					Representative</option>
				<option value="Admin" <%= "Admin".equals(role) ? "selected" : "" %>>Admin</option>
			</select>

			<button type="submit">Update Customer Representative</button>
		</form>
		<% } %>
	</div>
</body>
</html>
