<%@ page session="true" %>
<%
    // Retrieve session attributes
    String crUserRole = (String) session.getAttribute("userRole");
    String crLoggedInUser = (String) session.getAttribute("loggedInUser");

    // Redirect based on user roles
    if (crLoggedInUser == null || crUserRole == null) {
        // User is not logged in, redirect to welcome.jsp
        session.setAttribute("logoutMessage", "You have been logged out. Please log in again.");
        response.sendRedirect("welcome.jsp");
        return;
    } else if (crUserRole.equals("Admin")) {
        // Redirect Admin to their dashboard
        response.sendRedirect("adminDashboard.jsp");
        return;
    } else if (!crUserRole.equals("CustomerRepresentative")) {
        // Redirect non-cr's to the default welcome page
        response.sendRedirect("welcome.jsp");
        return;
    }
%>
