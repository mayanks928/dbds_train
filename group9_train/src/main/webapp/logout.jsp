<%@ page session="true" %>
<%
    session.invalidate();  // Invalidate the session to log the user out
    response.sendRedirect("login.jsp");  // Redirect to the login page
%>
