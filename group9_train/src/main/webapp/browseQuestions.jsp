<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.util.DBConnectionUtil, java.sql.*, java.util.*"%>
<%@ include file="navbar.jsp"%>
<%@ page session="true"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Questions</title>
    <!-- Bootstrap CSS -->
    
</head>
<body class="bg-light">
    <div class="container my-5 p-4 bg-white rounded shadow">
        <h1 class="text-center text-primary mb-4">Browse Questions</h1>

        <!-- Success/Error Message -->
        <%
            String message = (String) session.getAttribute("message");
            session.removeAttribute("message");
            if (message != null) {
        %>
        <div class="alert alert-info text-center" role="alert">
            <%= message %>
        </div>
        <%
            }
        %>

        <!-- Search Form -->
        <form method="post" action="searchResults.jsp" class="mb-4 d-flex justify-content-center">
            <input type="text" name="search" class="form-control me-2 w-50" placeholder="Search by keyword..." required />
            <button type="submit" class="btn btn-primary">Search</button>
        </form>

        <h2 class="text-secondary">Your Questions:</h2>

        <%
            int customerId = (int) session.getAttribute("customerId");
            Connection conn = DBConnectionUtil.getConnection();
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                String sql = "SELECT q.question_id, q.title, q.body, q.customer_id, "
                    + "a.answer_id, a.body AS reply_body, a.posted_by, a.customer_id AS answer_customer_id, a.employee_id "
                    + "FROM Question q "
                    + "LEFT JOIN Answer a ON q.question_id = a.question_id "
                    + "ORDER BY q.question_id ASC";

                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                Map<Integer, Map<String, Object>> userQuestions = new HashMap<>();
                Map<Integer, Map<String, Object>> otherQuestions = new HashMap<>();
                Map<Integer, List<Map<String, Object>>> repliesByQuestionId = new HashMap<>();

                while (rs.next()) {
                    int questionId = rs.getInt("question_id");
                    Map<String, Object> questionData = new HashMap<>();
                    questionData.put("title", rs.getString("title"));
                    questionData.put("body", rs.getString("body"));
                    questionData.put("customer_id", rs.getInt("customer_id"));
                    questionData.put("question_id", questionId);

                    if (rs.getInt("customer_id") == customerId) {
                        if (!userQuestions.containsKey(questionId)) {
                            userQuestions.put(questionId, questionData);
                        }
                    } else {
                        if (!otherQuestions.containsKey(questionId)) {
                            otherQuestions.put(questionId, questionData);
                        }
                    }

                    if (rs.getString("reply_body") != null) {
                        Map<String, Object> replyData = new HashMap<>();
                        replyData.put("reply_body", rs.getString("reply_body"));
                        replyData.put("posted_by", rs.getString("posted_by"));
                        replyData.put("answer_customer_id", rs.getInt("answer_customer_id"));
                        replyData.put("employee_id", rs.getInt("employee_id"));

                        repliesByQuestionId.computeIfAbsent(questionId, k -> new ArrayList<>()).add(replyData);
                    }
                }

                for (Map.Entry<Integer, Map<String, Object>> entry : userQuestions.entrySet()) {
                    Map<String, Object> question = entry.getValue();
        %>
        <div class="card mb-3">
            <div class="card-body">
                <h4 class="card-title text-primary"><%= question.get("title") %></h4>
                <p class="card-text"><%= question.get("body") %></p>

                <h5 class="text-secondary">Replies:</h5>
                <%
                    List<Map<String, Object>> replies = repliesByQuestionId.get(entry.getKey());
                    if (replies != null) {
                        for (Map<String, Object> reply : replies) {
                            String replyClass = "Customer".equals(reply.get("posted_by")) 
                                ? "text-primary fw-bold" 
                                : "text-danger fw-bold";
                %>
                <div class="alert alert-light border-start border-primary">
                    <p class="<%= replyClass %> mb-0"><%= reply.get("reply_body") %> (<%= reply.get("posted_by") %>)</p>
                </div>
                <%
                        }
                    }
                %>

                <form method="post" action="postReply.jsp" class="mt-3">
                    <textarea name="replyBody" class="form-control mb-3" rows="3" placeholder="Write your reply..." required></textarea>
                    <input type="hidden" name="questionId" value="<%= question.get("question_id") %>">
                    <input type="hidden" name="customerId" value="<%= session.getAttribute("customerId") %>">
                    <button type="submit" class="btn btn-success">Post Reply</button>
                </form>
            </div>
        </div>
        <%
                }
        %>

        <h2 class="text-secondary">Other Questions:</h2>

        <% 
            for (Map.Entry<Integer, Map<String, Object>> entry : otherQuestions.entrySet()) {
                Map<String, Object> question = entry.getValue();
        %>
        <div class="card mb-3">
            <div class="card-body">
                <h4 class="card-title text-primary"><%= question.get("title") %></h4>
                <p class="card-text"><%= question.get("body") %></p>

                <h5 class="text-secondary">Replies:</h5>
                <%
                    List<Map<String, Object>> replies = repliesByQuestionId.get(entry.getKey());
                    if (replies != null) {
                        for (Map<String, Object> reply : replies) {
                            String replyClass = "Customer".equals(reply.get("posted_by")) 
                                ? "text-primary fw-bold" 
                                : "text-danger fw-bold";
                %>
                <div class="alert alert-light border-start border-primary">
                    <p class="<%= replyClass %> mb-0"><%= reply.get("reply_body") %> (<%= reply.get("posted_by") %>)</p>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
        <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        %>

    </div>

    
</body>
</html>
