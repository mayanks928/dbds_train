<%@ page session="true" %>
<%
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        // Set a message in the session
        session.setAttribute("logoutMessage", "You have been logged out. Please log in again.");
        // Redirect to login.jsp
        response.sendRedirect("login.jsp");
        return; // Stop further execution of the page
    }
    
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
</head>
<body>
<%
String loggedInMessage = (String) session.getAttribute("loggedInMessage");
if (loggedInMessage != null) {
%>
    <p style="color: green; font-weight: bold;"><%= loggedInMessage %></p>
<%
    // Clear the message from the session after displaying it
    session.removeAttribute("loggedInMessage");
}

%>
    <h1>Welcome, <%= session.getAttribute("loggedInUser") %>!</h1>
    <p>You are now logged in.</p>
    <a href="logout.jsp">Logout</a>
</body>
</html>
