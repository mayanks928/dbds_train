<%@ page import="java.sql.*" %>
<%@ include file="checkAdmin.jsp" %>
<%@ include file="navbar.jsp" %>
<%
    String errorMessage = null;
    String successMessage = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String ssn = request.getParameter("ssn");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String role = request.getParameter("role");

        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
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
                return;
            }
        } catch (SQLIntegrityConstraintViolationException e) {
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
<div class="container my-5" style="max-width:600px;">
    <h1 class="text-center mb-4">Add Customer Representative</h1>
    <% if (errorMessage != null) { %>
    <div class="alert alert-danger" role="alert"><%= errorMessage %></div>
    <% } %>
    <% if (successMessage != null) { %>
    <div class="alert alert-success" role="alert"><%= successMessage %></div>
    <% } %>
    <div class="card p-4 shadow-sm">
        <form method="POST" action="addCustomerRep.jsp">
            <div class="mb-3">
                <label for="ssn" class="form-label">SSN:</label>
                <input type="text" id="ssn" name="ssn" minlength="9" maxlength="9" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" name="username" maxlength="50" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password" maxlength="100" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="first_name" class="form-label">First Name:</label>
                <input type="text" id="first_name" name="first_name" maxlength="20" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="last_name" class="form-label">Last Name:</label>
                <input type="text" id="last_name" name="last_name" maxlength="20" class="form-control">
            </div>
            <div class="mb-3">
                <label for="role" class="form-label">Role:</label>
                <select id="role" name="role" required class="form-select">
                    <option value="CustomerRepresentative">Customer Representative</option>
                    
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100">Add Representative</button>
        </form>
    </div>
</div>
