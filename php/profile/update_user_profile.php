<?php
// api/update_user_profile.php
require_once "cors.php";
require_once "conn.php";

session_start();

header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit();
}

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(405);
    echo json_encode([
        "success" => false,
        "message" => "Only POST method is allowed"
    ]);
    exit;
}


$user_id = $_GET['user_id'];
$data = json_decode(file_get_contents("php://input"), true);

$update_fields = [];
$params = [];

if (isset($data['name'])) {
    $update_fields[] = "name = ?";
    $params[] = $data['name'];
}
if (isset($data['mobile'])) {
    $update_fields[] = "mobile = ?";
    $params[] = $data['mobile'];
}
if (isset($data['industry_id'])) {
    $update_fields[] = "industry_id = ?";
    $params[] = $data['industry_id'];
}
if (isset($data['location_id'])) {
    $update_fields[] = "location_id = ?";
    $params[] = $data['location_id'];
}

if (empty($update_fields)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "No fields to update"
    ]);
    exit;
}

$params[] = $user_id;
$update_fields[] = "updated_at = current_timestamp()";

$query = "UPDATE users SET " . implode(", ", $update_fields) . " WHERE id = ?";
$stmt = mysqli_prepare($conn, $query);

if (!$stmt) {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Database error"
    ]);
    exit;
}

$types = str_repeat("s", count($params) - 1) . "i";
mysqli_stmt_bind_param($stmt, $types, ...$params);

if (mysqli_stmt_execute($stmt)) {
    echo json_encode([
        "success" => true,
        "message" => "Profile updated successfully"
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Failed to update profile"
    ]);
}

mysqli_stmt_close($stmt);
$conn->close();
?>