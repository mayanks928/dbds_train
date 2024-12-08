<%@ page import="com.example.util.DBConnectionUtil,java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.util.Base64" %>
<%@ include file="navbar.jsp" %>
<%@ include file="checkLogin.jsp" %>

<div class="container my-5" style="max-width:500px;">
    <h1 class="text-center mb-4">Register</h1>
    <div class="card p-4 shadow-sm">
        <form method="POST" action="register.jsp">
            <div class="mb-3">
                <label for="first_name" class="form-label">First Name</label>
                <input type="text" id="first_name" name="first_name" required class="form-control">
            </div>

            <div class="mb-3">
                <label for="last_name" class="form-label">Last Name</label>
                <input type="text" id="last_name" name="last_name" class="form-control">
            </div>

            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" id="email" name="email" required class="form-control">
            </div>

            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" id="username" name="username" required class="form-control">
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" id="password" name="password" required class="form-control">
            </div>

            <button type="submit" class="btn btn-primary w-100">Register</button>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String firstName = request.getParameter("first_name");
                String lastName = request.getParameter("last_name");
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                String hashedPassword = null;
                try {
                    MessageDigest digest = MessageDigest.getInstance("SHA-256");
                    byte[] hashBytes = digest.digest(password.getBytes("UTF-8"));
                    hashedPassword = Base64.getEncoder().encodeToString(hashBytes);
                } catch (NoSuchAlgorithmException | java.io.UnsupportedEncodingException e) {
                    e.printStackTrace();
                }

                if (hashedPassword != null) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    try {
                        String sql = "INSERT INTO Customer (first_name, last_name, email, username, password) VALUES (?, ?, ?, ?, ?)";
                        conn = DBConnectionUtil.getConnection();
                        pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, firstName);
                        pstmt.setString(2, lastName);
                        pstmt.setString(3, email);
                        pstmt.setString(4, username);
                        pstmt.setString(5, hashedPassword);

                        int rowsInserted = pstmt.executeUpdate();
                        if (rowsInserted > 0) {
                            out.println("<div class='alert alert-success mt-3'>Registration successful!</div>");
                        } else {
                            out.println("<div class='alert alert-danger mt-3'>Failed to register. Please try again.</div>");
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
                        e.printStackTrace();
                    } finally {
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    }
                }
            }
        %>
    </div>
</div>
