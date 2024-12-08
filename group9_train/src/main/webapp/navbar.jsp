<%@ page session="true" %>
<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userRole = (String) session.getAttribute("userRole");
    String homeHref = "index.jsp";
    if (loggedInUser != null) {
        if (userRole == null) {
            homeHref = "welcome.jsp";
        } else if (userRole.equals("Admin")) {
            homeHref = "adminDashboard.jsp";
        } else if (userRole.equals("CustomerRepresentative")) {
            homeHref = "customerRepDashboard.jsp";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Train Reservation System</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="<%=homeHref%>">Home</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link" href="findTrain.jsp">Find Trains</a>
        </li>
        <%
          if (loggedInUser != null && userRole == null) {
        %>
        <li class="nav-item">
          <a class="nav-link" href="reservations.jsp">Reservations</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="logout.jsp">Logout</a>
        </li>
        <%
          } else if (loggedInUser != null && userRole != null) {
        %>
        <li class="nav-item">
          <a class="nav-link" href="logout.jsp">Logout</a>
        </li>
        <%
          } else {
        %>
        <li class="nav-item">
          <a class="nav-link" href="register.jsp">Register</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="login.jsp">Login</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="employeeLogin.jsp">Employee Login</a>
        </li>
        <%
          }
        %>
      </ul>
    </div>
  </div>
</nav>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
