<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ include file="navbar.jsp" %>
<%
String transitId = request.getParameter("transitId");
String originId = request.getParameter("originId");
String destinationId = request.getParameter("destinationId");
String customerId = request.getParameter("customerId");
String totalFare = request.getParameter("totalFare");
String date = request.getParameter("date");
String fare = request.getParameter("fare");
String ticketCount = request.getParameter("ticketCount");
String paymentMode = request.getParameter("payment_mode");
String ticketsDataJson = request.getParameter("ticketsData");
%>
<div class="container my-5">
    <h1 class="text-center mb-4">Process Reservation Test</h1>
    <div class="card p-4 shadow-sm">
        <h2>Reservation Data</h2>
        <div class="mb-3"><strong>Transit ID:</strong> <%=transitId%></div>
        <div class="mb-3"><strong>Origin ID:</strong> <%=originId%></div>
        <div class="mb-3"><strong>Destination ID:</strong> <%=destinationId%></div>
        <div class="mb-3"><strong>Customer ID:</strong> <%=customerId%></div>
        <div class="mb-3"><strong>Total Fare:</strong> <%=totalFare%></div>
        <div class="mb-3"><strong>Travel Date:</strong> <%=date%></div>
        <div class="mb-3"><strong>Fare Per Ticket:</strong> <%=fare%></div>
        <div class="mb-3"><strong>Number of Tickets:</strong> <%=ticketCount%></div>
        <div class="mb-3"><strong>Payment Mode:</strong> <%=paymentMode%></div>
        <div class="mb-3"><strong>Tickets Data (JSON):</strong></div>
        <pre><%= ticketsDataJson %></pre>
    </div>
</div>
