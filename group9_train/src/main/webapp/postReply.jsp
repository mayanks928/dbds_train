<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ page session="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Reply Submitted</title>
</head>
<body>
	<%
	int questionId = Integer.parseInt(request.getParameter("questionId"));
	int customerId = Integer.parseInt(request.getParameter("customerId"));
	String replyBody = request.getParameter("replyBody");

	Connection conn = null;
	PreparedStatement stmt = null;
	String sql = "INSERT INTO Answer (question_id, posted_by, customer_id, body) VALUES (?, 'Customer', ?, ?)";

	try {

		conn = DBConnectionUtil.getConnection();
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, questionId);
		stmt.setInt(2, customerId);
		stmt.setString(3, replyBody);
		int rowsAffected = stmt.executeUpdate();
		
		if (rowsAffected > 0) {
			session.setAttribute("message", "Reply posted successfully!");
		} else {
			session.setAttribute("message", "Failed to post reply.");
		}
	} catch (SQLException e) {
		e.printStackTrace();
		session.setAttribute("message", "Error: " + e.getMessage());
	} finally {
		try {
			if (stmt != null)
		stmt.close();
			if (conn != null)
		conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	response.sendRedirect("browseQuestions.jsp");
	%>
</body>
</html>
