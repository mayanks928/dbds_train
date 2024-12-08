<%@ page session="true" %>
<%
    // Retrieve session attributes
    String adminUserRole = (String) session.getAttribute("userRole");
    String adminLoggedInUser = (String) session.getAttribute("loggedInUser");

    // Redirect based on user roles
    if (adminLoggedInUser == null || adminUserRole == null) {
        // User is not logged in, redirect to welcome.jsp
        session.setAttribute("logoutMessage", "You have been logged out. Please log in again.");
        response.sendRedirect("welcome.jsp");
        return;
    } else if (adminUserRole.equals("CustomerRepresentative")) {
        // Redirect Customer Representative to their dashboard
        response.sendRedirect("customerRepDashboard.jsp");
        return;
    } else if (!adminUserRole.equals("Admin")) {
        // Redirect non-admins to the default welcome page
        response.sendRedirect("welcome.jsp");
        return;
    }
%>
