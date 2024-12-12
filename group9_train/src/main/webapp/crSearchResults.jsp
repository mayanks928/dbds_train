<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ include file="navbar.jsp"%>
<%@ page session="true"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Search Results</title>
</head>
<body class="bg-light">

	<div class="container mt-5">
		<h1 class="text-center mb-4">Search Results</h1>

		<!-- Success/Error Message -->
		<%
		String message = (String) request.getAttribute("message");
		if (message != null) {
		%>
		<div class="alert alert-info text-center"><%=message%></div>
		<%
		}
		%>

		<!-- Search Form -->
		<form class="form-inline justify-content-center mb-4" method="post"
			action="crSearchResults.jsp">
			<input type="text" class="form-control mr-2 w-50" name="search"
				placeholder="Search by keyword..." />
			<button type="submit" class="btn btn-primary">Search</button>
		</form>

		<div>
			<h2 class="mb-3">Questions Found:</h2>

			<h3 class="text-secondary">User Questions:</h3>
			<%
			// Get the search keyword from the request
			String searchKeyword = request.getParameter("search");
			if (searchKeyword == null || searchKeyword.trim().isEmpty()) {
			%>
			<div class="alert alert-warning text-center">Please enter a
				keyword to search.</div>
			<%
			} else {

			// Establish DB connection
			Connection conn = DBConnectionUtil.getConnection();
			PreparedStatement stmt = null;
			ResultSet rs = null;

			try {
				// Prepare SQL query to search for questions containing the keyword in the title or body
				String sql = "SELECT q.question_id, q.title, q.body, q.customer_id, "
				+ "a.answer_id, a.body AS reply_body, a.posted_by, a.customer_id AS answer_customer_id, a.employee_id "
				+ "FROM Question q " + "LEFT JOIN Answer a ON q.question_id = a.question_id "
				+ "WHERE q.title LIKE ? OR q.body LIKE ? " + "ORDER BY q.question_id ASC";

				stmt = conn.prepareStatement(sql);
				stmt.setString(1, "%" + searchKeyword + "%");
				stmt.setString(2, "%" + searchKeyword + "%");
				rs = stmt.executeQuery();

				// Maps to store questions and replies grouped by question_id
				Map<Integer, Map<String, Object>> userQuestions = new HashMap<>();

				Map<Integer, List<Map<String, Object>>> repliesByQuestionId = new HashMap<>();

				// Iterate over the result set and group questions and replies
				while (rs.next()) {
					int questionId = rs.getInt("question_id");

					// Prepare question data
					Map<String, Object> questionData = new HashMap<>();
					questionData.put("title", rs.getString("title"));
					questionData.put("body", rs.getString("body"));
					questionData.put("customer_id", rs.getInt("customer_id"));
					questionData.put("question_id", questionId);

					// Add the question to the appropriate list (user's or others')

					userQuestions.putIfAbsent(questionId, questionData);

					// Prepare reply data only if a reply exists
					if (rs.getString("reply_body") != null) {
				Map<String, Object> replyData = new HashMap<>();
				replyData.put("reply_body", rs.getString("reply_body"));
				replyData.put("posted_by", rs.getString("posted_by"));
				replyData.put("answer_customer_id", rs.getInt("answer_customer_id"));
				replyData.put("employee_id", rs.getInt("employee_id"));

				// Add reply to the replies list grouped by question_id
				repliesByQuestionId.computeIfAbsent(questionId, k -> new ArrayList<>()).add(replyData);
					}
				}

				// Display results: User's own questions
				for (Map.Entry<Integer, Map<String, Object>> entry : userQuestions.entrySet()) {
					Map<String, Object> question = entry.getValue();
			%>
			<div class="card mb-3">
				<div class="card-header bg-primary text-white">
					<h5 class="card-title mb-0"><%=question.get("title")%></h5>
				</div>
				<div class="card-body">
					<p class="card-text"><%=question.get("body")%></p>
					<h6>Replies:</h6>
					<%
					// Display all replies for user's own questions
					List<Map<String, Object>> replies = repliesByQuestionId.get(entry.getKey());
					if (replies != null) {
						for (Map<String, Object> reply : replies) {
							String replyClass = "Customer".equals(reply.get("posted_by")) ? "text-primary font-weight-bold"
							: "text-danger font-weight-bold";
					%>
					<%-- <p class="<%= replyClass %>"><%= reply.get("reply_body") %> (<%= reply.get("posted_by") %>)</p> --%>
					<div class="alert alert-light border-start border-primary">
						<p class="<%=replyClass%> mb-0"><%=reply.get("reply_body")%>
							(<%=reply.get("posted_by")%>)
						</p>
					</div>
					<%
					}
					}
					%>

					<!-- Reply Form for admin -->
					<form method="post" action="crPostReply.jsp">
						<textarea class="form-control mb-2" name="replyBody" required
							placeholder="Write your reply..."></textarea>
						<input type="hidden" name="questionId"
							value="<%=question.get("question_id")%>"> <input
							type="hidden" name="employeeId"
							value="<%=session.getAttribute("employeeId")%>">
						<button type="submit" class="btn btn-success">Post Reply</button>
					</form>
				</div>
			</div>

			<%
			}
			} catch (SQLException e) {
			e.printStackTrace();
			%>
			<div class="alert alert-danger">An error occurred while
				fetching the data. Please try again later.</div>
			<%
			} finally {
			try {
				if (rs != null)
					rs.close();
				if (stmt != null)
					stmt.close();
				if (conn != null)
					conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			}
			}
			%>
		</div>
	</div>

</body>
</html>
