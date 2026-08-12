<?php

$servername = "localhost";
// $database = "healthcare";
$database = "u258460312_gurukulam";
$username = "u258460312_gurukulam_user";
// $username = "root";
$password = "Sbva/tech1";

function getDBConnection() {
    global $servername, $username, $password, $database;
    
    // Try to create connection
    $conn = new mysqli($servername, $username, $password, $database);
    
    // Check connection
    if ($conn->connect_error) {
        // Try one more time after a short pause
        usleep(100000); // Wait 0.1 seconds
        $conn = new mysqli($servername, $username, $password, $database);
        
        if ($conn->connect_error) {
            return null;
        }
    }
    
    // Set charset
    $conn->set_charset("utf8mb4");
    
    // Increase timeout to prevent connection drops
    $conn->query("SET SESSION wait_timeout = 300");
    $conn->query("SET SESSION interactive_timeout = 300");
    
    return $conn;
}

// Get connection with retry
$conn = getDBConnection();

// if (!$conn) {
    // die(json_encode([
        // 'status' => 'error', 
        // 'message' => 'Database connection failed after retry'
    // ]));
// }

?>
