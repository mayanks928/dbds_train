<%@ include file="navbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            /* padding: 20px; */
        }

        h1 {
            text-align: center;
            color: #333;
        }

        .container {
            display: flex;
            justify-content: space-around;
            margin-top: 50px;
        }

        .section {
            width: 45%;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .section h2 {
            text-align: center;
            color: #007bff;
        }

        .section p {
            text-align: center;
            margin: 15px 0;
        }

        .section a {
            display: block;
            margin: 10px auto;
            text-align: center;
            text-decoration: none;
            font-size: 16px;
            color: #fff;
            background-color: #007bff;
            padding: 10px 15px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .section a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

    <h1>Welcome to the Train Reservation System</h1>

    <div class="container">
        <!-- Employee Section -->
        <div class="section">
            <h2>If you are an Employee</h2>
            <p>Access your account here:</p>
            <a href="employeeLogin.jsp">Employee Login</a>
        </div>

        <!-- Customer Section -->
        <div class="section">
            <h2>If you are a Customer</h2>
            <p>Explore our services:</p>
            <a href="register.jsp">Register</a>
            <a href="login.jsp">Customer Login</a>
            <a href="findTrain.jsp">Find Trains</a>
        </div>
    </div>

</body>
</html>
