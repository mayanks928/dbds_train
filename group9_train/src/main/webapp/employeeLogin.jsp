<%@ page import="java.sql.*, com.example.util.DBConnectionUtil" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Login</title>
    <link rel="stylesheet" href="employeeloginstyles.css">
</head>
<body>
    <div class="login-container">
        <h1>Employee Login</h1>
        <form action="employeeLogin.jsp" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
            
            <button type="submit">Login</button>
        </form>
        
        <% 
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    // Establish database connection
                    conn = DBConnectionUtil.getConnection();
                    
                    // Query to authenticate user
                    String sql = "SELECT role, first_name FROM Employee WHERE username = ? AND password = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, username);
                    ps.setString(2, password);
                    
                    rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String role = rs.getString("role");
                        String firstName = rs.getString("first_name");
                        
                        // Store user info in session
                        session.setAttribute("loggedInUser", username);
                        session.setAttribute("userRole", role);
                        session.setAttribute("firstName", firstName);

                        // Redirect based on role
                        if ("Admin".equals(role)) {
                            response.sendRedirect("adminDashboard.jsp");
                        } else if ("CustomerRepresentative".equals(role)) {
                            response.sendRedirect("customerRepDashboard.jsp");
                        }
                    } else {
                        // Invalid login
                        out.println("<p class='error-message'>Invalid username or password. Please try again.</p>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<p class='error-message'>An error occurred. Please try again later.</p>");
                } finally {
                    // Close resources
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>
</body>
</html>
