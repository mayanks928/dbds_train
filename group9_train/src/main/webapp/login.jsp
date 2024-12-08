<%@ page import="com.example.util.DBConnectionUtil,java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.util.Base64"%>
<%@ page session="true"%>
<%@ include file="navbar.jsp" %>
<%@ include file="checkLogin.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Login</title>
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

		<%
		String logoutMessage = (String) session.getAttribute("logoutMessage");
		if (logoutMessage != null) {
		%>
		<p style="color: red; font-weight: bold;"><%=logoutMessage%></p>
		<%
		// Clear the message from the session after displaying it
		session.removeAttribute("logoutMessage");
		}
		%>
		<h1>Customer Login</h1>
		<form method="POST" action="login.jsp">
			<label for="username">Username</label> <input type="text"
				id="username" name="username" required> <label
				for="password">Password</label> <input type="password" id="password"
				name="password" required>

			<button type="submit">Login</button>
		</form>

		<%
		// Check if the form was submitted
		if (request.getMethod().equalsIgnoreCase("POST")) {
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
				ResultSet rs = null;

				try {
			// Connect to the database
			// Check if the username and password exist in the database
			String sql = "SELECT * FROM Customer WHERE username = ? AND password = ?";
			conn = DBConnectionUtil.getConnection();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, username);
			pstmt.setString(2, hashedPassword);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// User is logged in, set session attributes
				session.setAttribute("loggedInUser", username);
				session.setAttribute("customerId", rs.getInt("customer_id"));
				out.println("<p>Login successful! Welcome " + username + ".</p>");
				response.sendRedirect("welcome.jsp"); // Redirect to welcome page or dashboard
			} else {
				out.println("<p>Invalid username or password. Please try again.</p>");
			}
				} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
			e.printStackTrace();
				} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (SQLException ignored) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException ignored) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException ignored) {
				}
				}
			}
		}
		%>
	</div>
</body>
</html>
