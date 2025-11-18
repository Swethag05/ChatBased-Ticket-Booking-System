<%-- 
    Document   : downloadticket
    Created on : 11 Oct, 2024, 6:59:18 PM
    Author     : bhava
--%>

<%@ page import="java.io.*" %>
<%
    String bookingID = request.getParameter("bookingID");
    String currentMuseum = request.getParameter("currentMuseum");
    String currentLocation = request.getParameter("currentLocation");
    String visitDate = request.getParameter("visitDate");
    String adultCount = request.getParameter("adults");
    String childCount = request.getParameter("children");

    // Use the same path for the QR code generated in payment.jsp
    String qrCodePath = "ticket_qr_" + bookingID + ".png";
%>

<html>
<head>
    <title>Download Ticket</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #ffffff;
            padding: 20px;
            text-align: center;
        }
        .ticket-container {
            border: 2px solid #000;
            padding: 20px;
            margin: auto;
            max-width: 600px;
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
    <div class="ticket-container">
        <h2>Booking Confirmation</h2>
        <p><strong>Museum Name:</strong> <%= currentMuseum %></p>
        <p><strong>Location:</strong> <%= currentLocation %></p>
        <p><strong>Booking ID:</strong> <%= bookingID %></p>
        <p><strong>Date of Visit:</strong> <%= visitDate %></p>
        <p><strong>Number of Adults:</strong> <%= adultCount %></p>
        <p><strong>Number of Children:</strong> <%= childCount %></p>
        <p>Scan the QR code for ticket details:</p>
        <img src="<%= qrCodePath %>" alt="QR Code">
    </div>
<div class="profile-container">
  <img src="pr.png" alt="Profile" class="profile-icon">
  <div class="dropdown-content">
    <a href="../BookingDetails/bookinghistory.jsp">My Bookings</a>
    <a href="../UserDetails/logout.jsp">Logout</a>
  </div>
</div>
    <!-- Button to Print the Ticket -->
    <button class="button" onclick="window.print()">Print Ticket</button>
</body>
</html>