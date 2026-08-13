<?php
// api/get_user_profile.php
require_once "cors.php";
require_once "conn.php";

session_start();

header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit();
}

if ($_SERVER["REQUEST_METHOD"] !== "GET") {
    http_response_code(405);
    echo json_encode([
        "success" => false,
        "message" => "Only GET method is allowed"
    ]);
    exit;
}



$user_id = $_GET['user_id'];

try {
    $query = "
        SELECT
            u.id,
            u.name,
            u.user_type,
            u.email,
            u.mobile,
            u.role,
            u.industry_id,
            u.location_id,
            u.status,
            u.created_at,
            u.updated_at,
            i.industry AS industry_name,
            l.location AS location_name
        FROM users u
        LEFT JOIN industry_master i ON i.id = u.industry_id
        LEFT JOIN location_master l ON l.id = u.location_id
        WHERE u.id = $user_id
    ";

    $result = mysqli_query($conn, $query);

    if (!$result) {
        throw new Exception(mysqli_error($conn));
    }

    $user = mysqli_fetch_assoc($result);

    if (!$user) {
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "message" => "User not found"
        ]);
        exit;
    }

    echo json_encode([
        "success" => true,
        "message" => "User profile fetched successfully",
        "data" => $user
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?>