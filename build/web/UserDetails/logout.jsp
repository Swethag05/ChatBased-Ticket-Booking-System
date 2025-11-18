
<%
    // Invalidate the session to log out the user
    session.invalidate();
    
    // Redirect to the home page after logout
    response.sendRedirect("../Home/home.jsp");
%>