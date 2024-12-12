<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="navbar.jsp"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Helpdesk</title>
    <!-- Bootstrap CSS -->
    
</head>
<body class="bg-light">
    <div class="container my-5 p-4 bg-white shadow rounded">
        <h1 class="text-center text-primary mb-4">Helpdesk</h1>
        
        <!-- Display Success/Failure Message -->
        <%
            String message = (String) request.getAttribute("message");
            String messageType = (String) request.getAttribute("messageType"); // "success" or "error"
            if (message != null && messageType != null) {
        %>
            <div class="alert alert-<%= messageType.equals("success") ? "success" : "danger" %> text-center" role="alert">
                <%= message %>
            </div>
        <%
            }
        %>

        <!-- Ask a Question Form -->
        <form action="postQuestion.jsp" method="post">
            <input type="hidden" name="customer_id" value="<%= session.getAttribute("customerId") %>">
            
            <div class="mb-3">
                <label for="title" class="form-label">Question Title</label>
                <input type="text" id="title" name="title" class="form-control" required placeholder="Enter your question title">
            </div>
            
            <div class="mb-3">
                <label for="body" class="form-label">Question Body</label>
                <textarea id="body" name="body" rows="5" class="form-control" required placeholder="Enter the details of your question"></textarea>
            </div>
            
            <button type="submit" class="btn btn-primary w-100">Submit Question</button>
        </form>

        <!-- Prominent Browse Questions Link -->
        <div class="text-center mt-4">
            <a href="browseQuestions.jsp" class="btn btn-secondary">Browse Questions and Answers</a>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
