<%-- <%@ page import="java.sql.*" %> --%>

<%@ page import=" com.example.util.DBConnectionUtil,java.sql.Connection, java.sql.Statement, java.sql.ResultSet, java.util.List, java.util.ArrayList" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Schedule Search</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
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
        label, select, input, button {
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
    <script>
        // Automatically set the minimum date to today's date for the date input
        window.onload = function () {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('date').setAttribute('min', today);
        };
    </script>
</head>
<body>
    <div class="container">
        <h1>Search Train Schedule</h1>
        <form action="findTrain.jsp" method="GET">
            <!-- Origin Dropdown -->
            <label for="origin">Origin</label>
            <select id="origin" name="origin" required onchange="this.form.submit()">
                <option value="" disabled selected>Select Origin Station</option>
                  <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = DBConnectionUtil.getConnection();
                        stmt = conn.createStatement();
                        String query = "SELECT station_id, station_name FROM Station ORDER BY station_name";
                        rs = stmt.executeQuery(query);

                        while (rs.next()) {
                            int stationId = rs.getInt("station_id");
                            String stationName = rs.getString("station_name");
                            out.println("<option value='" + stationId + "'" +
                                    (request.getParameter("origin") != null &&
                                     request.getParameter("origin").equals(String.valueOf(stationId))
                                     ? " selected" : "") +
                                    ">" + stationName + "</option>");
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

            <!-- Destination Dropdown -->
            <label for="destination">Destination</label>
            <select id="destination" name="destination" required>
                <option value="" disabled selected>Select Destination Station</option>
                <%
                String originId = request.getParameter("origin");
                if (originId != null) {
                    try {
                        conn = DBConnectionUtil.getConnection();
                        stmt = conn.createStatement();

                        // Fetch all transit_ids where the origin station is a stop
                        String transitQuery = "SELECT DISTINCT transit_id FROM Transit_Stop WHERE station_id = " + originId;
                        rs = stmt.executeQuery(transitQuery);

                        List<Integer> transitIds = new ArrayList<>();
                        while (rs.next()) {
                            transitIds.add(rs.getInt("transit_id"));
                        }
                        rs.close();

                        // Fetch all unique stations from those transit_ids
                        if (!transitIds.isEmpty()) {
                            String transitIdList = transitIds.toString().replace("[", "").replace("]", "");
                            String destinationQuery = "SELECT DISTINCT s.station_id, s.station_name " +
                                    "FROM Transit_Stop ts " +
                                    "JOIN Station s ON ts.station_id = s.station_id " +
                                    "WHERE ts.transit_id IN (" + transitIdList + ") " +
                                    "AND ts.station_id != " + originId + " " +
                                    "ORDER BY s.station_name";

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

            <!-- Date Input -->
            <label for="date">Date</label>
            <input type="date" id="date" name="date" required>

            <!-- Submit Button -->
            <button type="submit">Search</button>
        </form>
    </div>
</body>
</html>

