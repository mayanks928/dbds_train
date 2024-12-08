<%@ page import="java.sql.*"%>
<%@ include file="checkAdmin.jsp"%>
<%@ include file="navbar.jsp"%>
<%
    String employeeId = request.getParameter("employeeId");
    String errorMessage = null;
    String successMessage = null;

    String ssn = "";
    String username = "";
    String password = "";
    String firstName = "";
    String lastName = "";
    String role = "";

    if (employeeId != null) {
        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
            String sql = "SELECT ssn, username, password, first_name, last_name, role FROM Employee WHERE employee_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(employeeId));
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ssn = rs.getString("ssn");
                username = rs.getString("username");
                password = rs.getString("password");
                firstName = rs.getString("first_name");
                lastName = rs.getString("last_name");
                role = rs.getString("role");
            } else {
                errorMessage = "No Customer Representative found with the provided ID.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "An error occurred while fetching employee details.";
        }
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        ssn = request.getParameter("ssn");
        username = request.getParameter("username");
        password = request.getParameter("password");
        firstName = request.getParameter("first_name");
        lastName = request.getParameter("last_name");
        role = request.getParameter("role");

        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
            String updateSql = "UPDATE Employee SET ssn = ?, username = ?, password = ?, first_name = ?, last_name = ?, role = ? WHERE employee_id = ?";
            PreparedStatement ps = conn.prepareStatement(updateSql);
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
<div class="container my-5" style="max-width:600px;">
    <h1 class="text-center mb-4">Edit Customer Representative</h1>

    <% if (errorMessage != null) { %>
    <div class="alert alert-danger" role="alert"><%= errorMessage %></div>
    <% } else if (successMessage != null) { %>
    <div class="alert alert-success" role="alert"><%= successMessage %></div>
    <% } %>

    <% if (employeeId != null && errorMessage == null) { %>
    <div class="card p-4 shadow-sm">
        <form method="POST" action="editCustomerRep.jsp?employeeId=<%= employeeId %>">
            <div class="mb-3">
                <label for="ssn" class="form-label">SSN:</label>
                <input type="text" id="ssn" name="ssn" value="<%= ssn %>" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" name="username" value="<%= username %>" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password" value="<%= password %>" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="first_name" class="form-label">First Name:</label>
                <input type="text" id="first_name" name="first_name" value="<%= firstName %>" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="last_name" class="form-label">Last Name:</label>
                <input type="text" id="last_name" name="last_name" value="<%= lastName %>" class="form-control">
            </div>
            <div class="mb-3">
                <label for="role" class="form-label">Role:</label>
                <select id="role" name="role" required class="form-select">
                    <option value="CustomerRepresentative" <%= "CustomerRepresentative".equals(role) ? "selected" : "" %>>Customer Representative</option>
                    <option value="Admin" <%= "Admin".equals(role) ? "selected" : "" %>>Admin</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100">Update Customer Representative</button>
        </form>
    </div>
    <% } %>
</div>
