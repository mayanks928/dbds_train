<%@ page import="com.example.util.DBConnectionUtil,java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.util.Base64"%>
<%@ page session="true"%>
<%@ include file="navbar.jsp" %>
<%@ include file="checkLogin.jsp" %>
<%
    String logoutMessage = (String) session.getAttribute("logoutMessage");
%>
<div class="container my-5" style="max-width:400px;">
    <h1 class="text-center mb-4">Customer Login</h1>
    <% if (logoutMessage != null) { %>
    <div class="alert alert-warning" role="alert">
        <%=logoutMessage%>
    </div>
    <%
       session.removeAttribute("logoutMessage");
    } 
    %>
    <div class="card p-4 shadow-sm">
        <form method="POST" action="login.jsp">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label> 
                <input type="text" id="username" name="username" required class="form-control">
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label> 
                <input type="password" id="password" name="password" required class="form-control">
            </div>

            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>
        <%
        if (request.getMethod().equalsIgnoreCase("POST")) {
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
                ResultSet rs = null;
                try {
                    conn = DBConnectionUtil.getConnection();
                    String sql = "SELECT * FROM Customer WHERE username = ? AND password = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, username);
                    pstmt.setString(2, hashedPassword);

                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        session.setAttribute("loggedInUser", username);
                        session.setAttribute("customerId", rs.getInt("customer_id"));
                        response.sendRedirect("welcome.jsp");
                    } else {
                        out.println("<div class='alert alert-danger mt-3' role='alert'>Invalid username or password. Please try again.</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger mt-3' role='alert'>An error occurred. Please try again later.</div>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            }
        }
        %>
    </div>
</div>
