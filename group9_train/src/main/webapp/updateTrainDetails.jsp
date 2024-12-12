<%@ page import="com.example.util.DBConnectionUtil, java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Train Details</title>
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
            String trainNumber = request.getParameter("train_number");
            boolean isExpress = request.getParameter("isExpress") != null;
            boolean directionToEnd = request.getParameter("directionToEnd") != null;
            int transitId = Integer.parseInt(request.getParameter("transit_id"));
            String startTime = request.getParameter("start_time");

            String updateQuery = "UPDATE Train SET isExpress = ?, directionToEnd = ?, transit_id = ?, start_time = ? WHERE train_number = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateQuery);
            psUpdate.setBoolean(1, isExpress);
            psUpdate.setBoolean(2, directionToEnd);
            psUpdate.setInt(3, transitId);
            psUpdate.setString(4, startTime);
            psUpdate.setInt(5, Integer.parseInt(trainNumber));

            int rowsUpdated = psUpdate.executeUpdate();
            if (rowsUpdated > 0) {
    %>
                <div class="alert alert-success" role="alert">
                    <h4 class="alert-heading">Success!</h4>
                    <p>Train details updated successfully!</p>
                    <hr>
                    <a href="editTrain.jsp" class="btn btn-primary">Back to Edit Train</a>
                </div>
    <%
            } else {
    %>
                <div class="alert alert-danger" role="alert">
                    <h4 class="alert-heading">Error!</h4>
                    <p>Failed to update train details. Please try again.</p>
                    <hr>
                    <a href="editTrain.jsp" class="btn btn-warning">Back to Edit Train</a>
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
                <a href="editTrain.jsp" class="btn btn-warning">Back to Edit Train</a>
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
