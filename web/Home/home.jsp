<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Head Content -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>National Gallery of Art</title>
    <style>
        /* General styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-image: url('ba.jpg'); /* Set the background image */
            background-size: cover;
            background-position: center;
            color: white; /* Set the text color to white */
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        header {
            background-color: rgba(44, 62, 80, 0.8);
            padding: 20px 0;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }
        .nav-container {
            text-align: center;
        }
        .nav-container a {
            color: white;
            margin: 0 15px;
            text-decoration: none;
            font-size: 18px;
            text-transform: uppercase;
            transition: color 0.3s ease;
        }
        .nav-container a:hover {
            color: #ff6347;
        }
        .container {
            text-align: center;
            padding: 80px 20px;
            margin: 100px auto 20px; /* Adjusted top margin to account for fixed header */
            max-width: 1200px;
            color: white; /* Ensure the container text is also white */
        }
        h2 {
            font-size: 36px;
            margin: 30px 0;
            text-transform: uppercase;
            color: white;
        }
        p {
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 30px;
            color: white;
        }
        .button-container {
            margin-top: 30px;
        }
        button {
            background-color: #ff6347;
            border: none;
            color: white;
            padding: 15px 30px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            margin: 10px;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #ff4500;
        }
        .museum-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 20px;
            display: none; /* Hide all images initially */
        }
        footer {
            background-color: rgba(44, 62, 80, 0.8);
            color: white;
            text-align: center;
            padding: 10px;
            width: 100%;
            position: fixed;
            bottom: 0;
            left: 0;
            z-index: 1000;
        }
        marquee {
            font-size: 16px;
            color: #ff6347;
        }
        /* Pop-up message styles */
        .popup-message {
            position: fixed;
            bottom: 120px;
            right: 20px;
            background-color: rgba(200, 128, 0, 0.9);
            color: white;
            padding: 30px 50px;
            border-radius: 10px;
            display: none;
            z-index: 2000;
            transition: opacity 1.5s ease-in-out;
            font-size: 24px;
        }
        /* Profile Icon Styles */
        .profile-icon {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            background-image: url('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'); /* Profile icon image */
            background-size: cover;
            background-position: center;
            border-radius: 50%;
            cursor: pointer;
            z-index: 1000;
        }
        /* Chatbot Container Styles */
        #chatbotContainer {
            display: none; /* Hidden by default */
            position: fixed;
            bottom: 30px;
            right: 20px;
            width: 600px;
            height: 920px;
            background-color: white;
            color: black;
            border: 2px solid #444;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            z-index: 2000;
            overflow: hidden; /* Hide the scrollbar */
        }
        /* Close Button for Chatbot */
        #chatbotContainer .close-button {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: red;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <!-- Header with Navigation Links -->
    <header>
        <div class="nav-container">
            <a href="../UserDetails/login.jsp">Login</a>
        </div>
    </header>

    <!-- Pop-up Message -->
    <div class="popup-message" id="welcomeMessage">HEY!! PLEASE LOGIN TO COMMUNICATE FREELY WITH US</div>

    <!-- Main Content Container -->
    <div class="container">
        <h2>Welcome to the National Gallery of Art</h2>
        <p>Where history and culture come alive through our vast collection of artworks from various periods and styles. Discover the rich tapestry of human creativity and innovation across centuries.</p>

        <!-- Image Carousel -->
        <img class="museum-image" id="image1" src="cultural.jpg" alt="Museum Image 1">
        <img class="museum-image" id="image2" src="prime.jpg" alt="Museum Image 2">
        <img class="museum-image" id="image3" src="three.jpg" alt="Museum Image 3">

        <div class="button-container">
            <!-- Buttons Removed -->
        </div>
    </div>

    <!-- Profile Icon at Bottom Right -->
    <div class="profile-icon" id="profileIcon"></div>

    <!-- Chatbot Container -->
    <div id="chatbotContainer">
        <!-- Close Button for Chatbot -->
        <button class="close-button" onclick="toggleChatbot()">X</button>
        <!-- Chatbot Content will be loaded here -->
    </div>

    <!-- Footer with Marquee -->
    <footer>
        <marquee behavior="scroll" direction="left">National Gallery of Art © All rights reserved</marquee>
    </footer>

    <script>
        // Show the welcome message when the page loads
        window.onload = function() {
            var welcomeMessage = document.getElementById("welcomeMessage");
            welcomeMessage.style.display = "block";
            setTimeout(function() {
                welcomeMessage.style.opacity = 1; // Make it visible
            }, 100); // Small delay before showing
            setTimeout(function() {
                welcomeMessage.style.opacity = 0; // Fade out
                setTimeout(function() {
                    welcomeMessage.style.display = "none"; // Hide it after fading out
                }, 500); // Wait for the fade out to complete
            }, 3000); // Display for 3 seconds

            // Start the image carousel
            var images = document.querySelectorAll('.museum-image');
            var currentIndex = 0;
            images[currentIndex].style.display = 'block'; // Show the first image

            setInterval(function() {
                images[currentIndex].style.display = 'none'; // Hide the current image
                currentIndex = (currentIndex + 1) % images.length; // Move to the next index
                images[currentIndex].style.display = 'block'; // Show the next image
            }, 2000); // Change image every 2 seconds
        };

        // Function to toggle the chatbot display
        function toggleChatbot() {
            var chatbotContainer = document.getElementById('chatbotContainer');

            if (chatbotContainer.style.display === 'none' || chatbotContainer.style.display === '') {
                // Show the chatbot container
                chatbotContainer.style.display = 'block';

                // Check if content is already loaded
                if (!chatbotContainer.innerHTML.includes('iframe')) {
                    // Create an iframe to load chatbot.jsp
                    var iframe = document.createElement('iframe');
                    iframe.src = '../ChatbotDetails/chatbot.jsp';
                    iframe.style.width = '100%';
                    iframe.style.height = '100%';
                    iframe.style.border = 'none';

                    // Clear any existing content except the close button
                    var closeButton = chatbotContainer.querySelector('.close-button');
                    chatbotContainer.innerHTML = '';
                    chatbotContainer.appendChild(closeButton);
                    chatbotContainer.appendChild(iframe);
                }
            } else {
                // Hide the chatbot container
                chatbotContainer.style.display = 'none';
            }
        }

        // Attach the click event to the profile icon
        document.getElementById('profileIcon').addEventListener('click', toggleChatbot);
    </script>
</body>
</html>