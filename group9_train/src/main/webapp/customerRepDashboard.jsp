<%@ include file="checkCustomerRep.jsp" %>
<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Representative Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f4f4f9;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .dashboard-links {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .dashboard-links a {
            display: block;
            background-color: #007BFF;
            color: white;
            padding: 15px;
            text-decoration: none;
            width: 250px;
            text-align: center;
            margin: 10px 0;
            border-radius: 5px;
            font-size: 1.2em;
            transition: background-color 0.3s ease;
        }
        .dashboard-links a:hover {
            background-color: #0056b3;
        }
        .dashboard-links a:active {
            background-color: #003c6f;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Customer Representative Dashboard</h1>
        <div class="dashboard-links">
            <a href="faqPage.jsp">Go to FAQ Page</a>
            <a href="trainSchedules.jsp">View Train Schedules for a Given Station</a>
            <a href="customerReservations.jsp">View All Customers with Reservations on a Given Transit Line and Date</a>
        </div>
    </div>
</body>
</html>
