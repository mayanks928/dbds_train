<%@ page import="java.sql.*, java.util.*, org.json.*" %>
<%
    String type = request.getParameter("type");
    String query = request.getParameter("query");
    JSONArray options = new JSONArray(); // Use org.json.JSONArray to store options

    try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
        String sql = "";
        if ("transit".equals(type)) {
            sql = "SELECT transit_name FROM Transit_Line WHERE transit_name LIKE ?";
        } else if ("customer".equals(type)) {
            sql = "SELECT CONCAT(first_name, ' ', last_name) AS customerName FROM Customer WHERE CONCAT(first_name, ' ', last_name) LIKE ?";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, query + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    options.put(rs.getString(1)); // Add each result to the JSONArray
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Output options as JSON
    response.setContentType("application/json");
    response.getWriter().write(options.toString()); // Convert JSONArray to JSON string
%>
