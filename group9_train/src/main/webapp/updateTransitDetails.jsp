<%@ page import="com.example.util.DBConnectionUtil, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Transit Details</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container mt-5">
    <h2>Update Train Details</h2>

    <%
        Connection conn = null;
        try {
            conn = DBConnectionUtil.getConnection();
            
            
            
            int transitId = Integer.parseInt(request.getParameter("transit_id"));
            double fare = Double.parseDouble(request.getParameter("fare")); 

            String updateQuery = "UPDATE Transit_line SET fare = ? WHERE transit_id = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateQuery);
            psUpdate.setDouble(1, fare);
            psUpdate.setInt(2, transitId);

            int rowsUpdated = psUpdate.executeUpdate();
            if (rowsUpdated > 0) {
    %>
                <div class="alert alert-success" role="alert">
                    <h4 class="alert-heading">Success!</h4>
                    <p>Transit details updated successfully!</p>
                    <hr>
                    <a href="editTransit.jsp" class="btn btn-primary">Back to Edit Train</a>
                </div>
    <%
            } else {
    %>
                <div class="alert alert-danger" role="alert">
                    <h4 class="alert-heading">Error!</h4>
                    <p>Failed to update transit details. Please try again.</p>
                    <hr>
                    <a href="editTransit.jsp" class="btn btn-warning">Back to Edit Transit</a>
                </div>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
    %>
            <div class="alert alert-danger" role="alert">
                <h4 class="alert-heading">Error!</h4>
                <p>There was an error updating the train details.</p>
                <hr>
                <a href="editTransit.jsp" class="btn btn-warning">Back to Edit Transit</a>
            </div>
    <%
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.bundle.min.js"></script>

</body>
</html>
