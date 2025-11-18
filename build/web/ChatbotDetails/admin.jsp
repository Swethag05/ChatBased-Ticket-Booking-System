<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>

<html>
<head>
    <title>Admin Panel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
        }
        .container {
            width: 50%;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
        }
        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        input[type="text"], input[type="password"] {
            width: 80%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: left;
        }
        .error {
            color: red;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Admin Panel</h2>
    
    <!-- Add User Form -->
    <h3>Add User</h3>
    <form method="post">
        <input type="text" name="username" placeholder="Username" required />
        <input type="password" name="password" placeholder="Password" required />
        <input type="text" name="email" placeholder="Email" required />
        <input type="submit" name="addUser" value="Add User" />
    </form>
    
    <!-- Delete User Form -->
    <h3>Delete User</h3>
    <form method="post">
        <input type="text" name="usernameToDelete" placeholder="Username to Delete" required />
        <input type="submit" name="deleteUser" value="Delete User" />
    </form>
    
    <!-- List Users -->
    <form method="post">
        <input type="submit" name="listUsers" value="List Users" />
    </form>
    <form action="../Home/home.jsp" method="post">
        <input type="submit" value="Return to Home" />
    </form>

    <%
        // Email validation regex pattern
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}$";
        Pattern emailPattern = Pattern.compile(emailRegex);

        // Updated password validation regex pattern
        String passwordRegex = "^(?=.[A-Za-z])(?=.[0-9])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$";
        Pattern passwordPattern = Pattern.compile(passwordRegex);

        // Database connection setup
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        String dbURL = "jdbc:derby://localhost:1527/Authentication";  // Adjust the DB URL
        String dbUser = "swetha";                        // Adjust the DB username
        String dbPass = "123";                    // Adjust the DB password
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver"); // Load Derby JDBC driver
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            stmt = conn.createStatement();
            
            // Add user logic
            if (request.getParameter("addUser") != null) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");

                // Check if email is valid
                Matcher emailMatcher = emailPattern.matcher(email);
                
                // Check if password is valid
                Matcher passwordMatcher = passwordPattern.matcher(password);
                
                if (!emailMatcher.matches()) {
                    // If email is not valid, show error message
                    out.println("<p class='error'>Invalid email format. Please enter a valid email.</p>");
                } else if (!passwordMatcher.matches()) {
                    // If password is not valid, show error message
                    out.println("<p class='error'>Invalid password format. Password must be at least 8 characters long, contain one digit, one special character, and at least one letter (uppercase or lowercase).</p>");
                } else {
                    // Insert the user into the database if both email and password are valid
                    String addUserQuery = "INSERT INTO users (username, password, email) VALUES ('" + username + "', '" + password + "', '" + email + "')";
                    stmt.executeUpdate(addUserQuery);
                    out.println("<p>User " + username + " added successfully!</p>");
                }
            }

            // Delete user logic
            if (request.getParameter("deleteUser") != null) {
                String usernameToDelete = request.getParameter("usernameToDelete");
                String deleteUserQuery = "DELETE FROM users WHERE username = '" + usernameToDelete + "'";
                int rowsAffected = stmt.executeUpdate(deleteUserQuery);

                if (rowsAffected > 0) {
                    out.println("<p>User " + usernameToDelete + " deleted successfully!</p>");
                } else {
                    out.println("<p>User " + usernameToDelete + " not found!</p>");
                }
            }

            // List all users
            if (request.getParameter("listUsers") != null) {
                String listUsersQuery = "SELECT * FROM users";
                rs = stmt.executeQuery(listUsersQuery);

                out.println("<h3>User List</h3>");
                out.println("<table>");
                out.println("<tr><th>Username</th><th>Password</th><th>Email</th></tr>");
                while (rs.next()) {
                    String username = rs.getString("username");
                    String password = rs.getString("password");
                    String email = rs.getString("email");

                    out.println("<tr><td>" + username + "</td><td>" + password + "</td><td>" + email + "</td></tr>");
                }
                out.println("</table>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p class = 'error'> User with the same username already exists! Try with another username. </p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</div>
</body>
</html>