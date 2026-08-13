<?php

require_once "cors.php";
require_once "conn.php";

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

$masters = [

    "degree" => "degreemaster",

    "education_level" =>
        "educationlevelmaster",

    "employment_type" =>
        "employment_type",

    "industry" =>
        "industry_master",

    "job_role" =>
        "job_role",

    "language" =>
        "languagemaster",

    "major_specialization" =>
        "major_specialization_master"
];

$master = $_POST["master"] ?? "";
$id = intval($_POST["id"] ?? 0);
$status = intval($_POST["status"] ?? -1);

if (!isset($masters[$master])) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid master type"
    ]);

    exit;
}

if ($id <= 0) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid ID"
    ]);

    exit;
}

if ($status !== 0 && $status !== 1) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid status"
    ]);

    exit;
}

$table = $masters[$master];

try {

    $check = $conn->prepare(
        "SELECT id
         FROM `$table`
         WHERE id = ?
         LIMIT 1"
    );

    $check->bind_param(
        "i",
        $id
    );

    $check->execute();

    $result = $check->get_result();

    if ($result->num_rows === 0) {

        echo json_encode([
            "success" => false,
            "message" => "Record not found"
        ]);

        exit;
    }

    $stmt = $conn->prepare(
        "UPDATE `$table`
         SET status = ?
         WHERE id = ?"
    );

    $stmt->bind_param(
        "ii",
        $status,
        $id
    );

    if (!$stmt->execute()) {

        throw new Exception(
            $stmt->error
        );
    }

    echo json_encode([
        "success" => true,
        "message" =>
            $status == 1
                ? "Activated successfully"
                : "Deactivated successfully",
        "id" => $id,
        "status" => $status
    ]);

} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([
        "success" => false,
        "message" => "Server error: " .
            $e->getMessage()
    ]);
}

$conn->close();

?>