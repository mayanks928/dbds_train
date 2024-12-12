<%@ page import="com.example.util.DBConnectionUtil, java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Transit Stop Details</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container mt-5">
    <h2>Update Transit Stop Details</h2>

    <%
        Connection conn = null;
        try {
            conn = DBConnectionUtil.getConnection();
            
            
            
            int transitId = Integer.parseInt(request.getParameter("transit_id"));
            int no_stops = Integer.parseInt(request.getParameter("no_stops"));
            
            
            
            // Arrays to store parameters
            int[] localOffsets = new int[no_stops];
            Integer[] expressOffsets = new Integer[no_stops];
            boolean[] isExpressStops = new boolean[no_stops];
            
            for (int i = 1; i <= no_stops; i++) { // Assuming a maximum of 10 stops
            	
                String localOffsetParam = "local_offset_" + i;
                String expressOffsetParam = "express_offset_" + i;
                String isExpressStopParam = "isExpressStop_" + i;
				
                
                
                localOffsets[i - 1] = Integer.parseInt(request.getParameter(localOffsetParam));
                if (request.getParameter(expressOffsetParam) != null && !request.getParameter(expressOffsetParam).isEmpty()) {
                    expressOffsets[i - 1] = Integer.parseInt(request.getParameter(expressOffsetParam));
                } else {
                    expressOffsets[i - 1] = null;
                }
                isExpressStops[i - 1] = Boolean.parseBoolean(request.getParameter(isExpressStopParam));
            }
            
            
            String updateQuery = "UPDATE Transit_Stop " +
            	    "SET local_time_offset = ?, express_time_offset = ?, isExpressStop = ? " +
            	    "WHERE transit_id = ? AND stop_number = ?";
            PreparedStatement ps = conn.prepareStatement(updateQuery);
            for (int i = 0; i < no_stops; i++) {
                ps.setInt(1, localOffsets[i]);
                ps.setObject(2, expressOffsets[i]);
                ps.setBoolean(3, isExpressStops[i]);
                ps.setInt(4, transitId);
                ps.setInt(5, i + 1);
                ps.addBatch();
            }
            int[] updateCounts = ps.executeBatch();
            boolean allUpdatesSuccessful = true;

         // Check if all updates were successful
         for (int count : updateCounts) {
             if (count == Statement.EXECUTE_FAILED) {
                 allUpdatesSuccessful = false;
                 break;
             }
         }
           

            if (allUpdatesSuccessful) {
    %>
                <div class="alert alert-success" role="alert">
                    <h4 class="alert-heading">Success!</h4>
                    <p>Transit stop details updated successfully!</p>
                    <hr>
                    <a href="editTransit.jsp" class="btn btn-primary">Back to Edit Transit</a>
                </div>
    <%
            } else {
    %>
                <div class="alert alert-danger" role="alert">
                    <h4 class="alert-heading">Error!</h4>
                    <p>Failed to update transit stop details. Please try again.</p>
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
                <p>There was an error updating the transit stop details.</p>
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
