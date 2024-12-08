<%@ page session="true" %>
<%
String adminUserRole = (String) session.getAttribute("userRole");
String adminLoggedInUser = (String) session.getAttribute("loggedInUser");

if (adminLoggedInUser == null || adminUserRole == null) {
    session.setAttribute("logoutMessage", "You have been logged out. Please log in again.");
    response.sendRedirect("welcome.jsp");
    return;
} else if (adminUserRole.equals("CustomerRepresentative")) {
    response.sendRedirect("customerRepDashboard.jsp");
    return;
} else if (!adminUserRole.equals("Admin")) {
    response.sendRedirect("welcome.jsp");
    return;
}
%>
