<%@ page import="java.sql.* , java.util.*" %>
<html>
<head>
    <title>Booking History for <%= session.getAttribute("username") %></title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        /* Styles for the Cancel button */
        .cancel-button {
            background-color: #ff6347; /* Button color */
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        .cancel-button:hover {
            background-color: #ff4500; /* Darker color on hover */
        }
    </style>
    <script>
        function confirmCancel(event) {
            // Show confirmation dialog
            var confirmation = confirm("Are you sure you want to cancel this booking?");
            if (!confirmation) {
                // Prevent form submission if user clicks 'Cancel'
                event.preventDefault();
            }
        }
    </script>
</head>
<body>
    <h2>Booking History for <%= session.getAttribute("username") %></h2>

    <!-- Display cancellation message -->
    <%
        String message = request.getParameter("message");
        if (message != null) {
    %>
        <div style="color: green; font-weight: bold;">
            <%= message %>
        </div>
    <%
        }
    %>

    <table>
        <tr>
            <th>Booking ID</th>
            <th>Visiting Date</th>
            <th>Number of Museum</th>
            <th>Location</th>
            <th>Total Amount</th>
            <th>Action</th> <!-- New column for action -->
        </tr>
        <%
            String username = (String) session.getAttribute("username"); // Retrieve logged-in user's name
            
            try {
                // Database connection
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Authentication", "swetha", "123"); 
                
                // Query to fetch bookings based on the username
                String query = "SELECT * FROM BOOKINGS WHERE USERNAME = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setString(1, username);
                
                ResultSet rs = stmt.executeQuery();

                // Iterate through the result set and display booking data
                while (rs.next()) {
                    String bookingId = rs.getString("BOOKING_ID");
                    String bookingDate = rs.getString("BOOKING_DATE");
                    String museum = rs.getString("museum");
                    String location= rs.getString("location");
                    int totalAmount = rs.getInt("TOTAL_AMOUNT");
                    
        %>
        <tr>
            <td><%= bookingId %></td>
            <td><%= bookingDate %></td>
            <td><%= museum %></td>
            <td><%= location %></td>
            <td>$<%= totalAmount %></td>
            <td>
                <!-- Form to cancel the booking -->
                <form action="cancel.jsp" method="post" onsubmit="confirmCancel(event);">
                    <input type="hidden" name="bookingId" value="<%= bookingId %>"/>
                    <button type="submit" class="cancel-button">Cancel</button>
                </form>
            </td>
        </tr>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>