<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ page session="true"%>
<%
// Database credentials

// Form inputs
String customerId = request.getParameter("customer_id");
String title = request.getParameter("title");
String body = request.getParameter("body");

String message = "";
String messageType = "";
Connection conn=null;
PreparedStatement stmt=null;

try  {
	conn = DBConnectionUtil.getConnection();
	String sql = "INSERT INTO Question (customer_id, title, body) VALUES (?, ?, ?)";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, Integer.parseInt(customerId));
	stmt.setString(2, title);
	stmt.setString(3, body);

	int rowsInserted = stmt.executeUpdate();
	if (rowsInserted > 0) {
		message = "Your question has been submitted successfully.";
		messageType = "success";
	} else {
		message = "Failed to submit your question. Please try again.";
		messageType = "error";
	}
} catch (SQLException e) {
	e.printStackTrace();
	message = "An error occurred while submitting your question: " + e.getMessage();
	messageType = "error";
}finally {
	try {
if (stmt != null)
	stmt.close();
if (conn != null)
	conn.close();
	} catch (Exception e) {
e.printStackTrace();
	}
}


// Pass the message back to the helpdesk page
request.setAttribute("message", message);
request.setAttribute("messageType", messageType);
request.getRequestDispatcher("helpdesk.jsp").forward(request, response);
%>
