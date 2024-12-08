<%@ page import="java.sql.*, org.json.*" %>
<%@ page session="true"%>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation Confirmation</title>
    <link rel="stylesheet" href="confirmation_style.css">
</head>
<body>
    <div class="container">
        <%
        // Retrieve reservation number and error message from session
        Integer reservationNo = (Integer) session.getAttribute("reservationNo");
        String errorMessage = (String) session.getAttribute("errorMessage");

        if (errorMessage != null) {
        %>
        <div class="message error">
            <h1>Error</h1>
            <p><%= errorMessage %></p>
            <a href="findTrain.jsp" class="btn">Try Again</a>
        </div>
        <%
            } else if (reservationNo != null) {
        %>
        <div class="message success">
            <h1>Reservation Successful!</h1>
            <p>Your reservation number is: <strong><%= reservationNo %></strong></p>
            <a href="welcome.jsp" class="btn">Back to Home</a>
        </div>
        <%
            } else {
        %>
        <div class="message error">
            <h1>Error</h1>
            <p>Reservation failed. Please try again.</p>
            <a href="findTrain.jsp" class="btn">Try Again</a>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>
