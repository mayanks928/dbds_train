<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome, <%= session.getAttribute("loggedInUser") %>!</h1>
    <p>You are now logged in.</p>
    <a href="logout.jsp">Logout</a>
</body>
</html>
