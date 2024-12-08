<%@ include file="navbar.jsp"%>
<%
    String logoutMessage = (String) session.getAttribute("logoutMessage");
    String loggedInMessage = (String) session.getAttribute("loggedInMessage");
%>
<div class="container my-5">
    <% if (logoutMessage != null) { %>
    <div class="alert alert-warning" role="alert">
        <%= logoutMessage %>
    </div>
    <%
       session.removeAttribute("logoutMessage");
    } 
    if (loggedInMessage != null) {
    %>
    <div class="alert alert-success" role="alert">
        <%= loggedInMessage %>
    </div>
    <%
       session.removeAttribute("loggedInMessage");
    }
    %>
    <h1 class="text-center mb-5">Welcome to the Train Reservation System</h1>
    <div class="row g-4">
        <!-- Employee Section -->
        <div class="col-md-6">
            <div class="card p-4 shadow-sm">
                <h2 class="text-primary text-center">If you are an Employee</h2>
                <p class="text-center mt-3">Access your account here:</p>
                <div class="d-grid">
                    <a href="employeeLogin.jsp" class="btn btn-primary">Employee Login</a>
                </div>
            </div>
        </div>

        <!-- Customer Section -->
        <div class="col-md-6">
            <div class="card p-4 shadow-sm">
                <h2 class="text-primary text-center">If you are a Customer</h2>
                <p class="text-center mt-3">Explore our services:</p>
                <div class="d-grid gap-2">
                    <a href="register.jsp" class="btn btn-primary">Register</a>
                    <a href="login.jsp" class="btn btn-primary">Customer Login</a>
                    <a href="findTrain.jsp" class="btn btn-primary">Find Trains</a>
                </div>
            </div>
        </div>
    </div>
</div>
