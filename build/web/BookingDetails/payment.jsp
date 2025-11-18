<%@ page import="java.text.SimpleDateFormat, java.util.Date, java.sql.*, java.io.File" %>
<%@ page import="com.google.zxing.qrcode.QRCodeWriter, com.google.zxing.BarcodeFormat, com.google.zxing.client.j2se.MatrixToImageWriter, com.google.zxing.common.BitMatrix" %>
<%
    // Retrieve parameters from the request
    String totalAmount = request.getParameter("total");
    String adultCount = request.getParameter("adults");
    String childCount = request.getParameter("children");
    String visitDate = request.getParameter("visitDate");
    String currentLocation = request.getParameter("currentLocation");
    String currentMuseum = request.getParameter("currentMuseum");

    // Booking ID and current date
    String bookingID = "NM" + System.currentTimeMillis();
   //SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
    
    Date currentDate = new Date();

    // Username from session
    String loggedInUsername = (String) session.getAttribute("username");

    // Formatting visit date
    
    
    
    SimpleDateFormat visitDateFormatter = new SimpleDateFormat("dd/MM/yyyy");
    String formattedVisitDate = "N/A";
    try {
        if (visitDate != null && !visitDate.isEmpty()) {
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedVisitDate = inputFormat.parse(visitDate);
            formattedVisitDate = visitDateFormatter.format(parsedVisitDate);
        }
    } catch (Exception e) {
        formattedVisitDate = "Invalid Date";
    }

    // QR Code Generation
    String qrText = "Museum Name: " + currentMuseum + "\nLocation: " + currentLocation + "\nBooking ID: " + bookingID + "\nVisit Date: " + visitDate + "\nNumber of Adults: " + adultCount + "\nNumber of Children: " + childCount;
    String qrPath = application.getRealPath("/") + File.separator + "BookingDetails" + File.separator + "ticket_qr_" + bookingID + ".png";
    try {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(qrText, BarcodeFormat.QR_CODE, 250, 250);
        File qrFile = new File(qrPath);
        MatrixToImageWriter.writeToFile(bitMatrix, "PNG", qrFile);
    } catch (Exception e) {
        out.println("QR Code Generation Failed: " + e.getMessage());
    }
    try {
        // Connect to the database
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/Authentication", "swetha", "123");

       


    String query = "INSERT INTO bookings (booking_id, username, booking_date, museum, location, total_amount) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, bookingID);
        ps.setString(2, loggedInUsername);  // Store the user's name
        if (visitDate != null) {
            ps.setString(3, visitDate);  // Correctly set visit date
        } else {
            ps.setNull(3, java.sql.Types.DATE);  // Handle missing date case
        }
        ps.setString(4,currentMuseum );  // Parsed integer for adults
        ps.setString(5, currentLocation);  // Parsed integer for children
        ps.setInt(6, Integer.parseInt(totalAmount));  // Total amount as double

        int result = ps.executeUpdate();
        if (result > 0) {
            out.println("<p>Booking successful! Your booking ID is " + bookingID + ".</p>");
        } else {
            out.println("<p>Failed to book tickets.</p>");
        }

        // Close the connection
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }

%>

<html>
<head>
    <title>Payment Success</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            padding: 20px;
            text-align: center;
        }
        
        .receipt-container {
            border: 2px solid #000;
            padding: 20px;
            margin: auto;
            max-width: 600px;
        }
        
        .success-message {
            font-size: 24px;
            color: green;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 8px;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }
        .button:hover {
            background-color: #45a049;
        }
        .profile-container {
  position: absolute;
  top: 20px;  /* Adjust the top distance as needed */
  right: 20px;  /* Adjust the right distance as needed */
  display: inline-block;
  cursor: pointer;
  z-index: 1000; /* Make sure it stays on top of other content */
}

/* Profile icon styling */
.profile-icon {
  width: 40px;  /* Adjust the size of the image */
  height: 40px;
  border-radius: 50%;  /* Makes the image circular */
  cursor: pointer;
}

/* Dropdown content */
.dropdown-content {
  display: none;
  position: absolute;
  background-color: #f9f9f9;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1001; /* Ensure it appears above other elements */
  right: 0;  /* Align dropdown with the right side of the profile */
}

/* Dropdown content links */
.dropdown-content a {
  color: black;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}

/* Change color of links on hover */
.dropdown-content a:hover {
  background-color: #f1f1f1;
}

/* Show the dropdown when hovering over the profile-container */
.profile-container:hover .dropdown-content {
  display: block;
}
    </style>
</head>
<body>

    <!-- Display only required details for the receipt -->
    <div id="receipt-details" class="receipt-container">
        <h1 class="success-message">Payment Successful!</h1>
        <p><strong>From:</strong> <%= loggedInUsername %></p>
        <p><strong>To:</strong> <%= currentMuseum %></p>
        <p><strong>Total Amount:</strong> $<%= String.format("%.2f", Double.parseDouble(totalAmount)) %></p>

        <!-- Button to Print the Receipt -->
        <button class="button" onclick="window.print()">Print Receipt</button>
        
        <!-- Button to Download Ticket -->
        <form method="get" action="downloadticket.jsp">
            
            <input type="hidden" name="bookingID" value="<%= bookingID %>">
            <input type="hidden" name="currentMuseum" value="<%= currentMuseum %>">
            <input type="hidden" name="currentLocation" value="<%= currentLocation %>">
            <input type="hidden" name="visitDate" value="<%= visitDate %>">
            <input type="hidden" name="adults" value="<%= adultCount %>">
            <input type="hidden" name="children" value="<%= childCount %>">
            <button type="submit" class="button">Download Ticket</button>
            
        </form>
        
    </div>
            <div class="profile-container">
  <img src="pr.png" alt="Profile" class="profile-icon">
  <div class="dropdown-content">
    <a href="../BookingDetails/bookinghistory.jsp">My Bookings</a>
    <a href="../UserDetails/logout.jsp">Logout</a>
  </div>
</div>

</body>
</html>