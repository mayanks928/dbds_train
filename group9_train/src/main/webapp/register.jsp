<%@ page import="com.example.util.DBConnectionUtil,java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.util.Base64" %>
<%@ include file="checkLogin.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label, input, button {
            margin-top: 10px;
            font-size: 16px;
            padding: 10px;
        }
        button {
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Register</h1>
        <form method="POST" action="register.jsp">
            <label for="first_name">First Name</label>
            <input type="text" id="first_name" name="first_name" required>
            
            <label for="last_name">Last Name</label>
            <input type="text" id="last_name" name="last_name">
            
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
            
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required>
            
            <button type="submit">Register</button>
        </form>

        <%
            // Check if the form was submitted
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String firstName = request.getParameter("first_name");
                String lastName = request.getParameter("last_name");
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                // Hash the password using SHA-256
                String hashedPassword = null;
                try {
                    MessageDigest digest = MessageDigest.getInstance("SHA-256");
                    byte[] hashBytes = digest.digest(password.getBytes("UTF-8"));
                    hashedPassword = Base64.getEncoder().encodeToString(hashBytes);
                } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
                    e.printStackTrace();
                }

                if (hashedPassword != null) {
                    // Database connection details
                    Connection conn = null;
                    PreparedStatement pstmt = null;

                    try {
                        // Connect to the database

                        // Insert customer data into the database
                        String sql = "INSERT INTO Customer (first_name, last_name, email, username, password) VALUES (?, ?, ?, ?, ?)";
                        conn = DBConnectionUtil.getConnection();
                        pstmt = conn.prepareStatement(sql);
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, firstName);
                        pstmt.setString(2, lastName);
                        pstmt.setString(3, email);
                        pstmt.setString(4, username);
                        pstmt.setString(5, hashedPassword);

                        int rowsInserted = pstmt.executeUpdate();
                        if (rowsInserted > 0) {
                            out.println("<p>Registration successful!</p>");
                        } else {
                            out.println("<p>Failed to register. Please try again.</p>");
                        }
                    } catch (Exception e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                        e.printStackTrace();
                    } finally {
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                    }
                }
            }
        %>
    </div>
</body>
</html>
