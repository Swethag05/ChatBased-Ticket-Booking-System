<%-- 
    Document   : login
    Created on : 24 Sep, 2024, 12:24:18 PM
    Author     : swethaganesh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* Full viewport height */
            margin: 0;
        }
        .login-container {
            background-color: rgba(255, 255, 255, 0.8); /* White background with transparency */
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2); /* Soft shadow */
            width: 300px; /* Fixed width */
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #555; /* Darker grey for labels */
        }
        input[type="text"],
        input[type="password"] {
            width: 100%; /* Full width */
            padding: 10px; /* Padding for inputs */
            margin-bottom: 15px; /* Space between inputs */
            border: 1px solid #ccc; /* Light grey border */
            border-radius: 5px; /* Rounded corners */
            font-size: 16px; /* Larger font size */
        }
        input[type="submit"] {
            background-color:green; 
            color: white; /* White text */
            border: none;
            border-radius: 5px; /* Rounded corners */
            padding: 10px; /* Padding for button */
            font-size: 16px; /* Larger font size */
            cursor: pointer; /* Pointer cursor */
            width: 100%; /* Full width */
            transition: background-color 0.3s ease; /* Smooth transition */
        }
        input[type="submit"]:hover {
            background-color: greenyellow; /* Darker blue on hover */
        }
        .error-message {
            color: red; /* Red color for error messages */
            text-align: center;
            margin-top: 10px; /* Space above error message */
        }
        .register-link {
            text-align: center; /* Center-align the text */
            margin-top: 10px; /* Space above the link */
        }
        .register-link a {
            color: #007BFF; /* Link color */
            text-decoration: none; /* Remove underline */
            font-size: 14px; /* Smaller font size for the link */
        }
        .register-link a:hover {
            text-decoration: underline; /* Underline on hover */
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <form method="get">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <input type="submit" value="Login">

            <div class="register-link">
                <span>New user?</span> 
                <a href="registration.jsp">Register</a>
            </div>
        </form>

        <%
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if(username != null && password != null) {
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Authentication", "swetha", "123");

                    String query = "SELECT * FROM users WHERE username=? AND password=?";
                    PreparedStatement pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, username);
                    pstmt.setString(2, password);
                    ResultSet rs = pstmt.executeQuery();

                    
                    if(rs.next()) {
                        session.setAttribute("username", username);
                        session.setAttribute("role", rs.getString("role"));
                        response.sendRedirect("../ChatbotDetails/chatbot.jsp");
                    } else {
                        out.println("<div class='error-message'>Invalid username or password.</div>");
                    }
                } catch(Exception e) {
                    out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
                }
            }
        %>
    </div>
</body>
</html>