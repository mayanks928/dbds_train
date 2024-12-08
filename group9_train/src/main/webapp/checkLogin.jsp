<%@ page session="true" %>
<%
String loggedInUser2 = (String) session.getAttribute("loggedInUser");
if (loggedInUser2 != null) {
    session.setAttribute("loggedInMessage", "You are already logged in.");
    response.sendRedirect("index.jsp");
    return;
}
%>
