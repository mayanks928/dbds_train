<%@ page session="true" %>
<%@ include file="navbar.jsp" %>
<%
    loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        session.setAttribute("logoutMessage", "You have been logged out. Please log in again.");
        response.sendRedirect("index.jsp");
        return;
    }

    String loggedInMessage = (String) session.getAttribute("loggedInMessage");
%>
<div class="container my-5 text-center">
    <% if (loggedInMessage != null) { %>
    <div class="alert alert-success" role="alert"><%= loggedInMessage %></div>
    <%
       session.removeAttribute("loggedInMessage");
    }
    %>
    <h1 class="mb-4">Welcome, <%= loggedInUser %>!</h1>
    <p class="lead mb-4">You are now logged in. Explore the exciting journey options we offer!</p>

    <div class="d-grid gap-3 mb-5">
        <a href="findTrain.jsp" class="btn btn-primary p-3">Find Trains</a>
        <a href="reservations.jsp" class="btn btn-primary p-3">Check Your Reservations</a>
        <a href="helpdesk.jsp" class="btn btn-primary p-3">Ask Us</a>
    </div>

    <div class="text-muted fst-italic">
        <p>"Travel with us - your journey, our responsibility!"</p>
        <p>"Make your dream destination a reality, one train ride at a time."</p>
        <p>"All aboard for a seamless travel experience!"</p>
    </div>

    <div class="mt-5">
        <a href="logout.jsp" class="btn btn-danger">Logout</a>
    </div>
</div>
