<%@ page import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Train Details</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container mt-5">
    <h2>Edit Train Details</h2>
    
    <!-- Train Selection Form -->
    <form action="editTrain.jsp" method="POST">
        <div class="form-group">
            <label for="train_number">Select Train Number</label>
            <select id="train_number" name="train_number" class="form-control" required>
                <option value="" disabled selected>Select a train</option>
                <%
                    Connection conn = null;
                    try {
                        conn = DBConnectionUtil.getConnection();
                        String query = "SELECT train_number FROM Train";
                        PreparedStatement ps = conn.prepareStatement(query);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            int trainNumber = rs.getInt("train_number");
                            out.println("<option value='" + trainNumber + "'>" + trainNumber + "</option>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Load Train Details</button>
    </form>

    <hr>

    <!-- Train Details Form (Populated after train selection) -->
    <form action="updateTrainDetails.jsp" method="POST" onsubmit="return confirm('Are you sure you want to update the train details?');">
        <%
            String selectedTrainNumber = request.getParameter("train_number");
            if (selectedTrainNumber != null) {
                try {
                    conn = DBConnectionUtil.getConnection();
                    String trainQuery = "SELECT * FROM Train WHERE train_number = ?";
                    PreparedStatement psTrain = conn.prepareStatement(trainQuery);
                    psTrain.setInt(1, Integer.parseInt(selectedTrainNumber));
                    ResultSet rsTrain = psTrain.executeQuery();

                    if (rsTrain.next()) {
                        int trainNumber = rsTrain.getInt("train_number");
                        boolean isExpress = rsTrain.getBoolean("isExpress");
                        boolean directionToEnd = rsTrain.getBoolean("directionToEnd");
                        int transitId = rsTrain.getInt("transit_id");
                        Time startTime = rsTrain.getTime("start_time");

                        // Fetch transit lines for dropdown
                        String transitQuery = "SELECT * FROM Transit_Line";
                        PreparedStatement psTransit = conn.prepareStatement(transitQuery);
                        ResultSet rsTransit = psTransit.executeQuery();
        %>
        
        <div class="form-group">
            <label for="train_number">Train Number</label>
            <input type="text" class="form-control" id="train_number" name="train_number" value="<%= trainNumber %>" readonly>
        </div>
        
        <div class="form-group">
            <label for="isExpress">Is this an express train?</label>
            <input type="checkbox" id="isExpress" name="isExpress" <%= isExpress ? "checked" : "" %> >
            <small class="form-text text-muted">Select if the train is an express train.</small>
        </div>
        
        <div class="form-group">
            <label for="directionToEnd">Direction to End</label>
            <input type="checkbox" id="directionToEnd" name="directionToEnd" <%= directionToEnd ? "checked" : "" %> >
            <small class="form-text text-muted">True means the train follows the direction from the starting stop to the ending stop of its transit line.</small>
        </div>

        <div class="form-group">
            <label for="transit_id">Transit Line</label>
            <select id="transit_id" name="transit_id" class="form-control" required>
                <option value="" disabled>Select a Transit Line</option>
                <%
                    while (rsTransit.next()) {
                        int transitIdValue = rsTransit.getInt("transit_id");
                        String transitName = rsTransit.getString("transit_name");
                        out.println("<option value='" + transitIdValue + "' " + (transitId == transitIdValue ? "selected" : "") + ">" + transitName + "</option>");
                    }
                %>
            </select>
            <small class="form-text text-muted">Each train is associated with a transit line, and follows the common schedule of that transit.</small>
        </div>

        <div class="form-group">
            <label for="start_time">Start Time</label>
            <input type="time" class="form-control" id="start_time" name="start_time" value="<%= startTime.toString().substring(0, 5) %>" required>
        </div>

        <button type="submit" class="btn btn-success">Update Train Details</button>

        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
    </form>
</div>


</body>
</html>
