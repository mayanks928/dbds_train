<%@ page import=" com.example.util.DBConnectionUtil,java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.util.List, java.util.ArrayList"%>
<%@ include file="navbar.jsp" %>
<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
%>
<div class="container my-5" style="max-width:600px;">
    <h1 class="text-center mb-4">Search Train Schedule</h1>
    <form action="findTrain.jsp" method="GET" class="card p-4 shadow-sm mb-4">
        <div class="mb-3">
            <label for="origin" class="form-label">Origin</label>
            <select id="origin" name="origin" required class="form-select" onchange="this.form.submit()">
                <option value="" disabled selected>Select Origin Station</option>
                <%
                try {
                    conn = DBConnectionUtil.getConnection();
                    stmt = conn.createStatement();
                    String query = "SELECT station_id, station_name FROM Station ORDER BY station_name";
                    rs = stmt.executeQuery(query);

                    while (rs.next()) {
                        int stationId = rs.getInt("station_id");
                        String stationName = rs.getString("station_name");
                %>
                <option value="<%=stationId%>" <%= (request.getParameter("origin") != null 
                    && request.getParameter("origin").equals(String.valueOf(stationId))) ? "selected" : "" %>>
                    <%=stationName%>
                </option>
                <%
                    }
                } catch (Exception e) {
                    out.println("<option disabled>Error loading stations</option>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                    if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
                    if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                }
                %>
            </select>
        </form>

    <form action="searchTrains.jsp" method="GET" class="card p-4 shadow-sm">
        <input type="hidden" name="origin" value="<%=request.getParameter("origin")%>">
        <div class="mb-3">
            <label for="destination" class="form-label">Destination</label>
            <select id="destination" name="destination" required class="form-select">
                <option value="" disabled selected>Select Destination Station</option>
                <%
                String originId = request.getParameter("origin");
                if (originId != null) {
                    try {
                        conn = DBConnectionUtil.getConnection();
                        stmt = conn.createStatement();
                        String transitQuery = "SELECT DISTINCT transit_id FROM Transit_Stop WHERE station_id = " + originId;
                        rs = stmt.executeQuery(transitQuery);

                        List<Integer> transitIds = new ArrayList<>();
                        while (rs.next()) {
                            transitIds.add(rs.getInt("transit_id"));
                        }
                        rs.close();

                        if (!transitIds.isEmpty()) {
                            String transitIdList = transitIds.toString().replace("[", "").replace("]", "");
                            String destinationQuery = "SELECT DISTINCT s.station_id, s.station_name " +
                                    "FROM Transit_Stop ts JOIN Station s ON ts.station_id = s.station_id " +
                                    "WHERE ts.transit_id IN ("+transitIdList+") AND ts.station_id != "+originId+" ORDER BY s.station_name";
                            rs = stmt.executeQuery(destinationQuery);

                            while (rs.next()) {
                                String stationId = rs.getString("station_id");
                                String stationName = rs.getString("station_name");
                                out.println("<option value='" + stationId + "'>" + stationName + "</option>");
                            }
                        }
                    } catch (Exception e) {
                        out.println("<option disabled>Error loading destinations</option>");
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
                        if (conn != null) try { conn.close(); } catch (Exception ignored) {}
                    }
                }
                %>
            </select>
        </div>

        <div class="mb-3">
            <label for="date" class="form-label">Date</label>
            <input type="date" id="date" name="date" required class="form-control">
        </div>
        <button type="submit" class="btn btn-primary w-100">Search</button>
    </form>
</div>

<script>
window.onload = function() {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('date').setAttribute('min', today);
};
</script>
