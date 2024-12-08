<%@ page session="true" %>
<%
	String userRole=(String) session.getAttribute("userRole");
String redirectTo=null;
if(userRole==null){
	redirectTo="login.jsp";
}else{
	redirectTo="employeeLogin.jsp";
}
    session.invalidate();  // Invalidate the session to log the user out
    response.sendRedirect(redirectTo);  // Redirect to the login page
%>
