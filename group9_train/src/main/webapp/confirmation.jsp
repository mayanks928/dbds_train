<%@ page import="java.sql.*, org.json.*" %>
<%@ page session="true"%>
<%@ include file="navbar.jsp" %>
<%
    Integer reservationNo = (Integer) session.getAttribute("reservationNo");
    String errorMessage = (String) session.getAttribute("errorMessage");
%>
<div class="container my-5" style="max-width:600px;">
    <% if (errorMessage != null) { %>
    <div class="alert alert-danger text-center">
        <h1>Error</h1>
        <p><%= errorMessage %></p>
        <a href="findTrain.jsp" class="btn btn-primary">Try Again</a>
    </div>
    <%
       session.removeAttribute("errorMessage");
    } else if (reservationNo != null) {
    %>
    <div class="alert alert-success text-center">
        <h1>Reservation Successful!</h1>
        <p>Your reservation number is: <strong><%= reservationNo %></strong></p>
        <a href="welcome.jsp" class="btn btn-primary mt-3">Back to Home</a>
    </div>
    <%
       session.removeAttribute("reservationNo");
    } else {
    %>
    <div class="alert alert-danger text-center">
        <h1>Error</h1>
        <p>Reservation failed. Please try again.</p>
        <a href="findTrain.jsp" class="btn btn-primary">Try Again</a>
    </div>
    <% } %>
</div>
