<?php
    $servername = "localhost";  // Adjust if you use a different host
    $username = "root";         // Your MySQL username
    $password = "";             // Your MySQL password (default is empty for XAMPP)
    $dbname = "grocery";  // The database you're connecting to

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>
