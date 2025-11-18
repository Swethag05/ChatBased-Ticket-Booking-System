<%-- 
    Document   : registration
    Created on : 24 Sep, 2024, 12:28:48 PM
    Author     : swethaganesh
--%>

<%@ page import="java.sql.*" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: white; 
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .registration-container {
            background-color: white; 
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2); 
            width: 300px; 
        }
        h2 {
            text-align: center;
            color: green; /* Bootstrap primary color */
        }
        input[type="text"],
        input[type="password"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc; 
            border-radius: 5px;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.1); 
        }
        input[type="submit"] {
            background-color: green; 
            color: white;
            border: none;
            padding: 10px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease; 
            width: 100%;
        }
        input[type="submit"]:hover {
            background-color: greenyellow; 
        .message {
            text-align: center;
            color: green; 
            margin-top: 10px;
        }
        .error {
            text-align: center;
            color: red; 
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="registration-container">
        <h2>Register</h2>
        <form method="get">
            Username: <input type="text" name="username" required><br>
            Password: <input type="password" name="password" required><br>
            Email: <input type="email" name="email" required><br>
            <input type="submit" value="Register">
        </form>
        <div class="message">
            <%
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                if (username != null && password != null && email != null) {
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Authentication","swetha","123");

                       String query = "INSERT INTO users(username, password, email) VALUES (?, ?, ?)";
                        PreparedStatement psmt = conn.prepareStatement(query);
                        psmt.setString(1, username);
                        psmt.setString(2, password);
                        psmt.setString(3, email);

                        int result = psmt.executeUpdate();
                        if (result > 0) {
                            out.println("<div class='message'>Registration successful. Redirecting to login page...</div>");
                            response.setHeader("Refresh", "3;URL=login.jsp"); // Redirect after 3 seconds
                        } else {
                            out.println("<div class='error'>Registration failed.</div>");
                        }
                    } catch (SQLException e) {
                        out.println("<div class='error'>Error:User already exists, try with another username </div>");
                        e.printStackTrace();
                    } catch (ClassNotFoundException e) {
                        out.println("<div class='error'>Driver not found.</div>");
                        e.printStackTrace();
                    }
                }
            %>
        </div>
    </div>
</body>
</html>