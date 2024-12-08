<%@ page session="true"%>
<nav style="background-color: #007bff; padding: 10px; color: white;">
	<ul
		style="list-style: none; display: flex; gap: 20px; padding: 0; margin: 0; align-items: center;">
		<%
		// Check if the user is logged in
		String loggedInUser = (String) session.getAttribute("loggedInUser");
		String userRole = (String) session.getAttribute("userRole");
		String homeHref = null;
		if (loggedInUser ==null) {
			homeHref = "index.jsp";
		} else if (userRole==null) {
			homeHref = "welcome.jsp";
		} else if (userRole.equals("CustomerRepresentative")) {
			homeHref = "customerRepDashboard.jsp";
		} else {
			homeHref = "adminDashboard.jsp";
		}
		%>
		<li><a href="<%=homeHref%>"
			style="color: white; text-decoration: none;">Home</a></li>
		<li><a href="findTrain.jsp"
			style="color: white; text-decoration: none;">Find Trains</a></li>

		<%
		if (loggedInUser != null && userRole == null) {
		%>
		<!-- Links for logged-in users -->
		<li>Welcome, <%=loggedInUser%></li>
		<li><a href="logout.jsp"
			style="color: white; text-decoration: none;">Logout</a></li>
		<li><a href="reservations.jsp"
			style="color: white; text-decoration: none;">Check Your
				Reservations</a></li>
		<%
		} else if (loggedInUser != null && userRole != null) {
		%>
		<li>Welcome, <%=loggedInUser%></li>
		<li><a href="logout.jsp"
			style="color: white; text-decoration: none;">Logout</a></li>
		<%
		} else {
		%>
		<!-- Links for non-logged-in users -->
		<li><a href="register.jsp"
			style="color: white; text-decoration: none;">Register</a></li>
		<li><a href="login.jsp"
			style="color: white; text-decoration: none;">Login</a></li>
		<li><a href="employeeLogin.jsp"
			style="color: white; text-decoration: none;">Employee Login</a></li>
		<%
		}
		%>
	</ul>
</nav>
