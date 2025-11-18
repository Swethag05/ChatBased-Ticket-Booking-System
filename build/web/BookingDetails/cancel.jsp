<%@ page import="java.sql.*" %>
<%
    // Retrieve the booking ID from the request
    String bookingId = request.getParameter("bookingId");

    // Initialize a message variable
    String message = "";

    try {
        // Database connection
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Authentication", "swetha", "123");

        // SQL query to delete the booking
        String query = "DELETE FROM BOOKINGS WHERE BOOKING_ID = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, bookingId);

        // Execute the deletion
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            message = "Booking with ID " + bookingId + " has been successfully cancelled.";
        } else {
            message = "No booking found with ID " + bookingId + ".";
        }

        // Close resources
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        message = "An error occurred while trying to cancel the booking.";
    }

    // Redirect back to booking history with a message
    response.sendRedirect("bookinghistory.jsp?message=" + message);
%>