<%@ page session="true" %>
<%
String crUserRole = (String) session.getAttribute("userRole");
String crLoggedInUser = (String) session.getAttribute("loggedInUser");

if (crLoggedInUser == null || crUserRole == null) {
    session.setAttribute("logoutMessage", "You have been logged out. Please log in again.");
    response.sendRedirect("welcome.jsp");
    return;
} else if (crUserRole.equals("Admin")) {
    response.sendRedirect("adminDashboard.jsp");
    return;
} else if (!crUserRole.equals("CustomerRepresentative")) {
    response.sendRedirect("welcome.jsp");
    return;
}
%>
