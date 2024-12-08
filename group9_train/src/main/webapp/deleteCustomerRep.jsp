<%@ page import="java.sql.*" %>
<%
    String employeeId = request.getParameter("employeeId");
    String errorMessage = null;

    if (employeeId == null || employeeId.isEmpty()) {
        errorMessage = "Employee ID is missing. Please check the URL.";
    } else {
        try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
            String checkSql = "SELECT role FROM Employee WHERE employee_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, Integer.parseInt(employeeId));
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                String role = rs.getString("role");
                if (!"CustomerRepresentative".equals(role)) {
                    errorMessage = "Only Customer Representatives can be deleted.";
                } else {
                    String deleteSql = "DELETE FROM Employee WHERE employee_id = ?";
                    PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                    deleteStmt.setInt(1, Integer.parseInt(employeeId));
                    int rowsAffected = deleteStmt.executeUpdate();

                    if (rowsAffected > 0) {
                        response.sendRedirect("viewCustomerRep.jsp");
                        return;
                    } else {
                        errorMessage = "Failed to delete the Customer Representative. Please try again.";
                    }
                }
            } else {
                errorMessage = "Employee with the provided ID does not exist.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "An error occurred while deleting the Customer Representative.";
        }
    }
%>
<%@ include file="navbar.jsp" %>
<div class="container my-5">
    <h1 class="text-center text-danger mb-4">Delete Customer Representative</h1>
    <% if (errorMessage != null) { %>
    <div class="alert alert-danger" role="alert"><%= errorMessage %></div>
    <div class="text-center mt-3">
        <a href="viewCustomerRep.jsp" class="btn btn-primary">Back to Customer Representatives</a>
    </div>
    <% } %>
</div>
