<%@ page import="java.sql.*" %>
<%@ include file="checkAdmin.jsp" %>
<%@ include file="navbar.jsp" %>
<%
    // Variables to hold error messages
    String errorMessage = null;
    String successMessage = null;

    // Handle form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String ssn = request.getParameter("ssn");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String role = request.getParameter("role");

        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
            // Insert the new customer representative into the database
            String sql = "INSERT INTO Employee (ssn, username, password, first_name, last_name, role) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, ssn);
            ps.setString(2, username);
            ps.setString(3, password);
            ps.setString(4, firstName);
            ps.setString(5, lastName);
            ps.setString(6, role);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                successMessage = "Customer Representative added successfully.";
                response.sendRedirect("viewCustomerRep.jsp");
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            // Handle unique constraint violation
            if (e.getMessage().contains("ssn")) {
                errorMessage = "SSN must be unique. This SSN is already in use.";
            } else if (e.getMessage().contains("username")) {
                errorMessage = "Username must be unique. This username is already in use.";
            } else {
                errorMessage = "An error occurred: " + e.getMessage();
            }
        } catch (Exception e) {
            errorMessage = "An unexpected error occurred: " + e.getMessage();
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Customer Representative</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-bottom: 5px;
            font-weight: bold;
        }
        input, select {
            margin-bottom: 15px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        .btn {
            background-color: #007bff;
            color: #fff;
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: #d9534f;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .success-message {
            color: #5cb85c;
            margin-bottom: 15px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Add Customer Representative</h1>
        <% if (errorMessage != null) { %>
            <div class="error-message"><%= errorMessage %></div>
        <% } %>
        <% if (successMessage != null) { %>
            <div class="success-message"><%= successMessage %></div>
        <% } %>
        <form method="POST" action="addCustomerRep.jsp">
            <label for="ssn">SSN:</label>
            <input type="text" id="ssn" name="ssn" minlength="9" maxlength="9" required>
            
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" maxlength="50" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" maxlength="100" required>
            
            <label for="first_name">First Name:</label>
            <input type="text" id="first_name" name="first_name" maxlength="20" required>
            
            <label for="last_name">Last Name:</label>
            <input type="text" id="last_name" name="last_name" maxlength="20">
            
            <label for="role">Role:</label>
            <select id="role" name="role" required>
                <option value="CustomerRepresentative">Customer Representative</option>
                <option value="Admin">Admin</option>
            </select>
            
            <button type="submit" class="btn">Add Representative</button>
        </form>
    </div>
</body>
</html>
