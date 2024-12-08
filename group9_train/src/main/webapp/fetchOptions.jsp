<%@ page import="java.sql.*, java.util.*, org.json.*" %>
<%
String type = request.getParameter("type");
String query = request.getParameter("query");
JSONArray options = new JSONArray();

try (Connection conn = com.example.util.DBConnectionUtil.getConnection()) {
    String sql = "";
    if ("transit".equals(type)) {
        sql = "SELECT transit_name FROM Transit_Line WHERE transit_name LIKE ?";
    } else if ("customer".equals(type)) {
        sql = "SELECT CONCAT(first_name, ' ', last_name) AS customerName FROM Customer WHERE CONCAT(first_name, ' ', last_name) LIKE ?";
    }

    if (!sql.isEmpty()) {
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, query + "%");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            options.put(rs.getString(1));
        }
    }
} catch (Exception e) {
    e.printStackTrace();
}

response.setContentType("application/json");
response.getWriter().write(options.toString());
%>
