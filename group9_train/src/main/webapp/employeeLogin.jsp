<%@ page import="java.sql.*, com.example.util.DBConnectionUtil" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>
<div class="container my-5" style="max-width:400px;">
    <h1 class="text-center mb-4">Employee Login</h1>
    <div class="card p-4 shadow-sm">
        <form action="employeeLogin.jsp" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username:</label>
                <input type="text" id="username" name="username" required class="form-control">
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password:</label>
                <input type="password" id="password" name="password" required class="form-control">
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnectionUtil.getConnection();
                    String sql = "SELECT role, first_name FROM Employee WHERE username = ? AND password = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setString(1, username);
                    ps.setString(2, password);

                    rs = ps.executeQuery();
                    if (rs.next()) {
                        String role = rs.getString("role");
                        String firstName = rs.getString("first_name");

                        session.setAttribute("loggedInUser", username);
                        session.setAttribute("userRole", role);
                        session.setAttribute("firstName", firstName);

                        if ("Admin".equals(role)) {
                            response.sendRedirect("adminDashboard.jsp");
                        } else if ("CustomerRepresentative".equals(role)) {
                            response.sendRedirect("customerRepDashboard.jsp");
                        }
                    } else {
                        out.println("<div class='alert alert-danger mt-3'>Invalid username or password. Please try again.</div>");
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger mt-3'>An error occurred. Please try again later.</div>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            }
        %>
    </div>
</div>
