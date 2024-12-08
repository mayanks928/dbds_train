<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ include file="navbar.jsp" %>
<%
    // Retrieve the form parameters passed from the previous page
    String transitId = request.getParameter("transitId");
    String originId = request.getParameter("originId");
    String destinationId = request.getParameter("destinationId");
    String customerId = request.getParameter("customerId");
    String totalFare = request.getParameter("totalFare");
    String date = request.getParameter("date");
    String fare = request.getParameter("fare");
    String ticketCount = request.getParameter("ticketCount");
    String paymentMode = request.getParameter("payment_mode");
    String ticketsDataJson = request.getParameter("ticketsData");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Reservation Test</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h1 {
            color: #007BFF;
            text-align: center;
            margin-top: 30px;
        }

        .container {
            margin: 30px;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .section {
            margin-bottom: 15px;
        }

        .section label {
            font-weight: bold;
        }

        .section p {
            font-size: 1.1em;
        }
    </style>
</head>
<body>

    <h1>Reservation Data</h1>

    <div class="container">
        <div class="section">
            <label>Transit ID:</label>
            <p><%= transitId %></p>
        </div>
        <div class="section">
            <label>Origin ID:</label>
            <p><%= originId %></p>
        </div>
        <div class="section">
            <label>Destination ID:</label>
            <p><%= destinationId %></p>
        </div>
        <div class="section">
            <label>Customer ID:</label>
            <p><%= customerId %></p>
        </div>
        <div class="section">
            <label>Total Fare:</label>
            <p><%= totalFare %></p>
        </div>
        <div class="section">
            <label>Travel Date:</label>
            <p><%= date %></p>
        </div>
        <div class="section">
            <label>Fare Per Ticket:</label>
            <p><%= fare %></p>
        </div>
        <div class="section">
            <label>Number of Tickets:</label>
            <p><%= ticketCount %></p>
        </div>
        <div class="section">
            <label>Payment Mode:</label>
            <p><%= paymentMode %></p>
        </div>
        <div class="section">
            <label>Tickets Data (JSON):</label>
            <pre><%= ticketsDataJson %></pre>
        </div>
    </div>

</body>
</html>
