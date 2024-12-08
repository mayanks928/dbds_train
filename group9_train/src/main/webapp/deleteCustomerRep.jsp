<%@ page import="java.sql.*" %>
<%
    String employeeId = request.getParameter("employeeId");
    String errorMessage = null;

    if (employeeId == null || employeeId.isEmpty()) {
        errorMessage = "Employee ID is missing. Please check the URL.";
    } else {
        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
            // Check if the employee is a Customer Representative
            String checkSql = "SELECT role FROM Employee WHERE employee_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, Integer.parseInt(employeeId));
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    String role = rs.getString("role");
                    if (!"CustomerRepresentative".equals(role)) {
                        errorMessage = "Only Customer Representatives can be deleted.";
                    } else {
                        // Delete the Customer Representative
                        String deleteSql = "DELETE FROM Employee WHERE employee_id = ?";
                        try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                            deleteStmt.setInt(1, Integer.parseInt(employeeId));
                            int rowsAffected = deleteStmt.executeUpdate();

                            if (rowsAffected > 0) {
                                // Redirect to viewCustomerRep.jsp after successful deletion
                                response.sendRedirect("viewCustomerRep.jsp");
                                return;
                            } else {
                                errorMessage = "Failed to delete the Customer Representative. Please try again.";
                            }
                        }
                    }
                } else {
                    errorMessage = "Employee with the provided ID does not exist.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "An error occurred while deleting the Customer Representative.";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Customer Representative</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h1 {
            color: #dc3545;
        }
        p {
            font-size: 16px;
        }
        .error {
            color: #dc3545;
            font-weight: bold;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <% if (errorMessage != null) { %>
            <h1>Error</h1>
            <p class="error"><%= errorMessage %></p>
            <a href="viewCustomerRep.jsp">Back to Customer Representatives</a>
        <% } %>
    </div>
</body>
</html>
