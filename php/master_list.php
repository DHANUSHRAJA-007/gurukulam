<?php

header("Content-Type: application/json");

require_once "conn.php";

$masters = [

    "degree" => [
        "table" => "degreemaster",
        "column" => "degree"
    ],

    "education_level" => [
        "table" => "educationlevelmaster",
        "column" => "education_level"
    ],

    "employment_type" => [
        "table" => "employment_type",
        "column" => "employment_type"
    ],

    "industry" => [
        "table" => "industry_master",
        "column" => "industry"
    ],

    "job_role" => [
        "table" => "job_role",
        "column" => "job_role"
    ],

    "language" => [
        "table" => "languagemaster",
        "column" => "language"
    ],

    "major_specialization" => [
        "table" => "major_specialization_master",
        "column" => "major_specialization"
    ]
];

$master = $_GET["master"] ?? "";

if (!isset($masters[$master])) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid master type"
    ]);

    exit;
}

$table = $masters[$master]["table"];
$column = $masters[$master]["column"];

try {

    // Only active records
    $stmt = $conn->prepare(
        "SELECT id, `$column`, status
         FROM `$table`
         WHERE status = 1
         ORDER BY id DESC"
    );

    $stmt->execute();

    $result = $stmt->get_result();

    $data = [];

    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode([
        "success" => true,
        "message" => "Active records fetched successfully",
        "data" => $data
    ]);

} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([
        "success" => false,
        "message" => "Server error"
    ]);
}

?>