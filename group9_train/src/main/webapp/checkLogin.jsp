<%@ page session="true" %>
<%
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    if (loggedInUser != null) {
        session.setAttribute("loggedInMessage", "You are already logged in.");
        response.sendRedirect("welcome.jsp");
        return;
    }
%>
