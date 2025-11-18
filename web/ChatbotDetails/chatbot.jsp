<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>


<%!
    int bookingStep =0;
    int totalAmount = 0;
    String userName = "";
    String bookingDate = "";
    int numAdults = 0;
    int numChildren = 0;

int adultTicketPrice = 20;  // Example price
int childTicketPrice = 10; 

%>
<%
 // Example price

// Regular expression patterns
String namePattern = "^[A-Za-z ]+$";  // For names with letters and spaces only
String datePattern = "^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-\\d{4}$";

    // Ensure the user session is available
    session = request.getSession();
    String loggedInUser = (String) session.getAttribute("username");

    // Get the user input from the previous form submission (if any)
    String userInput = request.getParameter("userInput");

    
    // Variables to track the chatbot flow
    String currentMuseum = (String) session.getAttribute("currentMuseum");
    String currentLocation = (String) session.getAttribute("currentLocation");
    String chatStage = (String) session.getAttribute("chatStage");

    // Initialize locations and museums
    HashMap<String, String[]> locations = new HashMap<String, String[]>();
    locations.put("1", new String[]{"Delhi", "1. National Museum<br>2. Art Museum<br>3. PrimeMinister Museum<br>4. Exit"});
    locations.put("2", new String[]{"Chennai", "1. Government Museum<br>2. Cultural Museum<br>3. Science Museum<br>4. Exit"});
    locations.put("3", new String[]{"Bangalore", "1. Salar Jung Museum<br>2. Nizam's Museum<br>3. Telangana State Archaeology Museum<br>4. Exit"});

    // Museums data with details
    HashMap<String, String[]> museums = new HashMap<String, String[]>();
    // Delhi Museums
    museums.put("1", new String[]{
        "National Museum",
        "A stunning museum in Delhi showcasing India’s rich history, art, and culture. Visit the ancient artifacts, and beautiful galleries. <br>Nearby tourist places: <a href='https://maps.google.com?q=India+Gate' target='_blank'>India Gate</a>, <a href='https://maps.google.com?q=Rajpath' target='_blank'>Rajpath</a>.",
        "Price: $10",
        "Timings: 9 AM - 5 PM",
        "Location: Delhi",
        "Landmark: Near India Gate",
        "Map: <a href='https://maps.google.com?q=National+Museum+Delhi' target='_blank'>View Map</a>"
    });
    museums.put("2", new String[]{
        "Art Museum", 
        "Explore art collections from different eras. <br>Nearby: <a href='https://maps.google.com?q=Jantar+Mantar' target='_blank'>Jantar Mantar</a>.",
        "Price: $8", 
        "Timings: 10 AM - 6 PM", 
        "Location: Delhi", 
        "Landmark: Near Jantar Mantar",
        "Map: <a href='https://maps.google.com?q=Art+Museum+Delhi' target='_blank'>View Map</a>"
    });
    museums.put("3", new String[]{
        "PrimeMinister Museum", 
        "Discover India's rich history of prime ministers. <br>Nearby: <a href='https://maps.google.com?q=Red+Fort' target='_blank'>Red Fort</a>.",
        "Price: $6", 
        "Timings: 8 AM - 4 PM", 
        "Location: Delhi", 
        "Landmark: Near Red Fort",
        "Map: <a href='https://maps.google.com?q=History+Museum+Delhi' target='_blank'>View Map</a>"
    });

    // Chennai Museums
    museums.put("4", new String[]{
        "Government Museum",
        "Government Museum showcases a wide collection of artifacts and cultural items from Tamil Nadu. <br>Nearby tourist places: <a href='https://maps.google.com?q=Marina+Beach' target='_blank'>Marina Beach</a>, <a href='https://maps.google.com?q=Kapaleeshwarar+Temple' target='_blank'>Kapaleeshwarar Temple</a>.",
        "Price: $5",
        "Timings: 10 AM - 6 PM",
        "Location: Chennai",
        "Landmark: Near SRM University",
        "Map: <a href='https://maps.google.com?q=SRM+Museum+Chennai' target='_blank'>View Map</a>"
    });
    museums.put("5", new String[]{
        "Cultural Museum",
        "One of the oldest museums in India, with a vast collection of bronze artifacts and art pieces. <br>Nearby: <a href='https://maps.google.com?q=Egmore' target='_blank'>Egmore Railway Station</a>.",
        "Price: $6",
        "Timings: 9 AM - 5 PM",
        "Location: Chennai",
        "Landmark: Near Egmore",
        "Map: <a href='https://maps.google.com?q=Government+Museum+Chennai' target='_blank'>View Map</a>"
    });
    museums.put("6", new String[]{
        "Science and Technology Museum",
        "A museum dedicated to modern science and technology with interactive exhibits. <br>Nearby: <a href='https://maps.google.com?q=Guindy+National+Park' target='_blank'>Guindy National Park</a>",
        "Price: $4",
        "Timings: 9 AM - 5 PM",
        "Location: Chennai",
        "Landmark: Near IIT Madras",
        "Map: <a href='https://maps.google.com?q=Science+and+Technology+Museum+Chennai' target='_blank'>View Map</a>"
    });

    // Hyderabad Museums
    museums.put("7", new String[]{
        "Salar Jung Museum",
        "This museum has a world-renowned collection of art, artifacts, and manuscripts from various civilizations. <br>Nearby tourist places: <a href='https://maps.google.com?q=Charminar' target='_blank'>Charminar</a>, <a href='https://maps.google.com?q=Mecca+Masjid' target='_blank'>Mecca Masjid</a>.",
        "Price: $12",
        "Timings: 10 AM - 5 PM",
        "Location: Hyderabad",
        "Landmark: Near Charminar",
        "Map: <a href='https://maps.google.com?q=Salar+Jung+Museum+Hyderabad' target='_blank'>View Map</a>"
    });
    museums.put("8", new String[]{
        "Nizam's Museum",
        "Exhibiting the treasures of the Nizams, this museum is a treasure trove of history. <br>Nearby: <a href='https://maps.google.com?q=Chowmahalla+Palace' target='_blank'>Chowmahalla Palace</a>",
        "Price: $10",
        "Timings: 10 AM - 5 PM",
        "Location: Hyderabad",
        "Landmark: Near Chowmahalla Palace",
        "Map: <a href='https://maps.google.com?q=Nizams+Museum+Hyderabad' target='_blank'>View Map</a>"
    });
    museums.put("9", new String[]{
        "Telangana State Archaeology Museum",
        "Home to archaeological treasures from Telangana, including ancient sculptures and inscriptions. <br>Nearby: <a href='https://maps.google.com?q=Public+Gardens' target='_blank'>Public Gardens</a>.",
        "Price: $8",
        "Timings: 9 AM - 4:30 PM",
        "Location: Hyderabad",
        "Landmark: Near Public Gardens",
        "Map: <a href='https://maps.google.com?q=Telangana+State+Archaeology+Museum+Hyderabad' target='_blank'>View Map</a>"
    });

    // Initialize chat history if it doesn't exist
    ArrayList<String> chatHistory = (ArrayList<String>) session.getAttribute("chatHistory");
    if (chatHistory == null) {
        chatHistory = new ArrayList<String>();
        chatHistory.add("Bot: Hi, please choose a location:<br>1. Delhi<br>2. Chennai<br>3. Bangalore");
        session.setAttribute("chatHistory", chatHistory);
        session.setAttribute("chatStage", "chooseLocation");
    }

    // Variable to store the chatbot's response
    String botResponse = "";

    // Variable to determine if the login popup should be shown
    boolean showLoginPopup = false;

    // Chatbot flow management
    if (userInput != null && !userInput.trim().isEmpty()) {
        chatHistory.add("User: " + userInput); // Add user input to chat history

        if (chatStage.equals("chooseLocation")) {
            if (locations.containsKey(userInput)) {
                currentLocation = userInput;
                session.setAttribute("currentLocation", currentLocation);
                botResponse = "Museums in " + locations.get(currentLocation)[0] + ":<br>" + locations.get(currentLocation)[1] + "<br>Please choose a museum:";
                session.setAttribute("chatStage", "chooseMuseum");
            } 
            else {
                botResponse = "Invalid choice. Please choose a location:<br>1. Delhi<br>2. Chennai<br>3. Bangalore";
            }
        } 
        else if (chatStage.equals("chooseMuseum")) {
            if(userInput.equals("4")){
                botResponse = "Hi, please choose a location:<br>1. Delhi<br>2. Chennai<br>3. Bangalore";
                session.setAttribute("chatStage", "chooseLocation");
            }
            else if (Integer.parseInt(userInput)<4 && museums.containsKey(userInput)) {
                if(currentLocation.equals("1")){
                    currentMuseum = userInput;
                }
                else if(currentLocation.equals("2")){
                    int sum = 3 + Integer.parseInt(userInput);
                    currentMuseum = String.valueOf(sum);
                }
                else { // Bangalore
                    int sum = 6 + Integer.parseInt(userInput);
                    currentMuseum = String.valueOf(sum);
                }
                session.setAttribute("currentMuseum", currentMuseum);
                botResponse = "What do you want to know about " + museums.get(currentMuseum)[0] + "?<br>1. Description<br>2. Ticket Price<br>3. Available Timings<br>4. Location<br>5. Map<br>6. Landmark<br>7. Book Ticket<br>8. Exit";
                session.setAttribute("chatStage", "museumDetails");
            } 
            else {
                botResponse = "Invalid choice. Please select a museum.";
            }
        } 
        else if (chatStage.equals("museumDetails")) {
            if (userInput.equals("1") && bookingStep==0) { // Description
                botResponse = museums.get(currentMuseum)[1];
            } else if (userInput.equals("2") && bookingStep==0) { // Ticket Price
                botResponse = museums.get(currentMuseum)[2];
            } else if (userInput.equals("3") && bookingStep==0) { // Available Timings
                botResponse = museums.get(currentMuseum)[3];
            } else if (userInput.equals("4") && bookingStep==0) { // Location
                botResponse = museums.get(currentMuseum)[4];
            } else if (userInput.equals("5") && bookingStep==0) { // Map
                botResponse = museums.get(currentMuseum)[6];
            } else if (userInput.equals("6") && bookingStep==0) { // Landmark
                botResponse = museums.get(currentMuseum)[5];
            }
           else if (userInput.equals("7") ) {  // User selects "Book Ticket"
            if (loggedInUser == null) {
                botResponse = "After login, Again  type 7 to book tickets.";
                showLoginPopup = true;
            }
            else {
                if (bookingStep == 0) {
                botResponse = "Enter your Name:";
                bookingStep = 1;  // Move to the next step
            } 
        }
           }
        else if (bookingStep==1) {
            // Validate name using regex
            if (userInput.matches(namePattern)) {
                userName = userInput;  // Store user's name
                botResponse = "Enter the date in (DD-MM-YYYY) format:";
                bookingStep = 2;  // Move to the next step
            } else {
                botResponse = "Please enter a valid name (letters and spaces only).";
            }
        } 
        else if (bookingStep == 2) {
            // Validate date using regex
            if (userInput.matches(datePattern)) {
                // Parse date and check if it's valid and not in the past or Sunday
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
                Date date = dateFormat.parse(userInput);
                Date currentDate = new Date();  // Get current date

                Calendar calendar = Calendar.getInstance();
                calendar.setTime(date);

                int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

                // Check if the entered date is in the past
                if (date.before(currentDate)) {
                    botResponse = "You cannot book tickets for past dates. Please enter a future date.";
                    
                } 
                // Check if it's a Sunday
                else if (dayOfWeek == Calendar.SUNDAY) {
                    botResponse = "Bookings are not allowed on Sundays. Please enter a different date.";
                } 
                else {
                    bookingDate = userInput;  // Store booking date
                    botResponse = "Enter number of adults:";
                    bookingStep = 3;  // Move to the next step
                }
            } else {
                botResponse = "Please enter a valid date in DD-MM-YY format.";
            }
        } 
        else if (bookingStep == 3) {
            // Check if the input is a valid number
            if (userInput.matches("\\d+")) {
                numAdults = Integer.parseInt(userInput);  // Store number of adults
                botResponse = "Enter number of children:";
                bookingStep = 4;  // Move to the next step
            } else {
                botResponse = "Please enter a valid number for adults.";
            }
        } 
        else if (bookingStep == 4) {
            // Check if the input is a valid number
            if (userInput.matches("\\d+")) {
                numChildren = Integer.parseInt(userInput);  // Store number of children
                totalAmount = (numAdults * adultTicketPrice) + (numChildren * childTicketPrice);  // Calculate total payment
                botResponse = "Total payment: $" + totalAmount + ". Enter 'confirm' to proceed to payment.";
                bookingStep = 5;  // Move to the next step
            } else {
                botResponse = "Please enter a valid number for children.";
            }
        } 
        else if (bookingStep == 5) {
            if (userInput.equalsIgnoreCase("confirm")) {
                response.sendRedirect("../BookingDetails/payment.jsp?currentMuseum=" + museums.get(currentMuseum)[0] + "&currentLocation=" + locations.get(currentLocation)[0] +"&total=" + totalAmount +"&adults=" + numAdults +"&children=" + numChildren +"&visitDate=" + bookingDate);


                    return;

            } else {
                botResponse = "Booking cancelled.";
                bookingStep = 0;  // Reset the flow if not confirmed
            }
        }
    

            
            else if (userInput.equals("8")) { // Exit
                botResponse = "Museums in " + locations.get(currentLocation)[0] + ":<br>" + locations.get(currentLocation)[1] + "<br>Please choose a museum:";
                session.setAttribute("chatStage", "chooseMuseum");
            } else {
                botResponse = "Invalid choice. What do you want to know about " + museums.get(currentMuseum)[0] + "?<br>1. Description<br>2. Ticket Price<br>3. Available Timings<br>4. Location<br>5. Map<br>6. Landmark<br>7. Book Ticket<br>8. Exit";
            }
        }

        // Add bot response to chat history
        chatHistory.add("Bot: " + botResponse);

        // If login popup needs to be shown, set a session attribute
        if (showLoginPopup) {
            session.setAttribute("showLoginPopup", true);
        }
    }

    // Remove the login redirect at the top
%>

<!DOCTYPE html>
<html>
<head>
    <title>Museum Ticket Booking Chatbot</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            
        }

        #chatbox {
            width: 900px;
            height: 530px;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 10px;
            overflow-y: auto;
            background-color: white;
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
            margin-left: 60px;
             background-image: url('ch.jpg');
    background-size: cover; /* This will make the image cover the entire chatbox */
    background-position: center; 
        }

        #userInput {
            width: 820px;
            padding: 10px;
            border-radius: 10px;
            border: 1px solid #ccc;
             margin-left: 60px;
        }

        .bot-message-container {
            position: relative;
            margin-left: 40px; /* Ensures that the icon does not overlap the bot message */
            display: flex;
            justify-content: flex-start; /* Align the bot's message to the left */
        }

        .user-message-container {
            display: flex;
            justify-content: flex-end; /* Align the user's message to the right */
        }

        .bot-message, .user-message {
            margin: 10px 0;
            padding: 10px;
            border-radius: 10px;
            position: relative;
            max-width: 80%;
            display: inline-block;
        }

        .bot-message {
            background-color: #f1f1f1;
            text-align: left; /* Align bot messages to the left */
            align-self: flex-start; /* Align bot messages to the left */
        }

        .user-message {
            background-color: #d1f5d3;
            text-align: right; /* Align user messages to the right */
            align-self: flex-end; /* Align user messages to the right */
        }

        .bot-icon {
            width: 30px;
            height: 30px;
            position: absolute;
            left: -40px; /* Position the icon outside the message box */
            top: 0;
        }

        .timestamp {
            font-size: 0.8em;
            color: gray;
            margin-left: 10px; /* Add space between message and timestamp */
        }

        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Modal styling */
        #loginPopup {
            display: none; /* Hidden by default */
            position: fixed;
            z-index: 1000; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.4); /* Black background with opacity */
        }

        #loginPopupContent {
            background-color: white;
            margin: 15% auto; /* 15% from the top and centered */
            padding: 20px;
            border: 1px solid #888;
            width: 40%;
            text-align: center;
            border-radius: 10px;
        }

        .closeBtn {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .closeBtn:hover,
        .closeBtn:focus {
            color: black;
            text-decoration: none;
        }
       /* Container for the profile */
/* Container for the profile */
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
    <script>
        // Function to scroll to the bottom of the chatbox after every new message
        function scrollToBottom() {
            var chatbox = document.getElementById("chatbox");
            chatbox.scrollTop = chatbox.scrollHeight;
        }

        // Call scrollToBottom on page load and after a short delay to ensure messages are rendered
        window.onload = function() {
            scrollToBottom();
            showLoginPopup();
        };

        function getCurrentTimestamp() {
            var now = new Date();
            var hours = now.getHours();
            var minutes = now.getMinutes();
            var ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours ? hours : 12; // Convert 0 to 12
            minutes = minutes < 10 ? '0' + minutes : minutes;
            var timeString = hours + ':' + minutes + ' ' + ampm;
            var dateString = now.toLocaleDateString();
            return dateString + " " + timeString;
        }

        // Function to show the login popup if needed
        function showLoginPopup() {
            var showLogin = "<%= (session.getAttribute("showLoginPopup") != null && ((Boolean) session.getAttribute("showLoginPopup"))) ? "true" : "false" %>";
            if (showLogin === "true") {
                document.getElementById('loginPopup').style.display = "block";
                // Reset the session attribute to prevent showing the popup again on refresh
                <% session.setAttribute("showLoginPopup", false); %>
            }
        }

        // Close the popup
        function closePopup() {
            document.getElementById('loginPopup').style.display = "none";
        }

        // Redirect to login page
        function goToLogin() {
            window.location.href = '../UserDetails/login.jsp';
        }
    </script>
</head>
<body>
<center><h1>   Chatbot for Museum Ticket Booking</h1><center>
    <div id="chatbox">
        <% for (String message : chatHistory) { %>
            <div style="position: relative;" class="<%= message.startsWith("Bot") ? "bot-message-container" : "user-message-container" %>">
                <% if (message.startsWith("Bot")) { %>
                    <!-- Add AI icon outside the bot message box -->
                    <img src="https://png.pngtree.com/png-clipart/20230401/original/pngtree-smart-chatbot-cartoon-clipart-png-image_9015126.png" alt="AI Icon" class="bot-icon">
                <% } %>
                
                <div class="<%= message.startsWith("Bot") ? "bot-message" : "user-message" %>">
                    <%= message.replaceFirst("Bot: ", "") %> <!-- Display message without "Bot: " prefix -->
                    <span class="timestamp"><script>document.write(getCurrentTimestamp());</script></span>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Modal Popup -->
    <div id="loginPopup">
        <div id="loginPopupContent">
            <span class="closeBtn" onclick="closePopup()">&times;</span>
            <h2>Login Required</h2>
            <p>You need to log in to continue booking tickets.</p>
            <button onclick="goToLogin()">Login</button>
        </div>
    </div>

    <form method="get">
        <input type="text" id="userInput" name="userInput" placeholder="Type your message here..." required>
        <button type="submit">Send</button>
    </form>
    
<div class="profile-container">
  <img src="pr.png" alt="Profile" class="profile-icon">
  <div class="dropdown-content">
    <a href="../BookingDetails/bookinghistory.jsp">My Bookings</a>
    <a href="../UserDetails/logout.jsp">Logout</a>
  </div>
</div>



</body>
</html>