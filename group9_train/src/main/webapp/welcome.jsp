<%@ page session="true" %>
<%@ include file="navbar.jsp" %>
<%
    // Check if the user is logged in
    loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        // Set a message in the session
        session.setAttribute("logoutMessage", "You have been logged out. Please log in again.");
        // Redirect to login.jsp
        response.sendRedirect("index.jsp");
        return; // Stop further execution of the page
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
    <link rel="stylesheet" href="welcome_styles.css">
</head>
<body>
    <div class="container">
        <div class="message-box">
            <%
                String loggedInMessage = (String) session.getAttribute("loggedInMessage");
                if (loggedInMessage != null) {
            %>
                <p class="success-message"><%= loggedInMessage %></p>
                <%
                    // Clear the message from the session after displaying it
                    session.removeAttribute("loggedInMessage");
                }
            %>
        </div>

        <h1 class="welcome-header">Welcome, <%= loggedInUser %>!</h1>
        <p class="intro-text">You are now logged in. Explore the exciting journey options we offer!</p>

        <div class="links">
            <a href="searchTrains.jsp" class="btn">Find Trains</a>
            <a href="reservations.jsp" class="btn">Check Your Reservations</a>
        </div>

        <div class="slogan">
            <p>"Travel with us - your journey, our responsibility!"</p>
            <p>"Make your dream destination a reality, one train ride at a time."</p>
            <p>"All aboard for a seamless travel experience!"</p>
        </div>

        <div class="logout">
            <a href="logout.jsp" class="btn logout-btn">Logout</a>
        </div>
    </div>
</body>
</html>
