<?php


require_once "cors.php";
require_once "conn.php";

header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit();
}

// =====================================================
// MASTER TABLE CONFIGURATION
// =====================================================

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


// =====================================================
// GET DATA
// =====================================================

$master = $_POST["master"] ?? "";
$value = trim($_POST["value"] ?? "");


// =====================================================
// VALIDATION
// =====================================================

if (!isset($masters[$master])) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid master type"
    ]);

    exit;
}

if ($value === "") {

    echo json_encode([
        "success" => false,
        "message" => "Value is required"
    ]);

    exit;
}


$table = $masters[$master]["table"];
$column = $masters[$master]["column"];


// =====================================================
// INSERT
// =====================================================

try {

    // Check duplicate

    $check = $conn->prepare(
        "SELECT id
         FROM `$table`
         WHERE LOWER(`$column`) = LOWER(?)
         LIMIT 1"
    );

    $check->bind_param(
        "s",
        $value
    );

    $check->execute();

    $result = $check->get_result();

    if ($result->num_rows > 0) {

        echo json_encode([
            "success" => false,
            "message" => "This value already exists"
        ]);

        exit;
    }


    // Insert record

    $stmt = $conn->prepare(
        "INSERT INTO `$table`
        (`$column`, status)
        VALUES (?, 1)"
    );

    $stmt->bind_param(
        "s",
        $value
    );


    if ($stmt->execute()) {

        echo json_encode([
            "success" => true,
            "message" => "Added successfully",
            "id" => $stmt->insert_id
        ]);

    } else {

        echo json_encode([
            "success" => false,
            "message" => "Failed to add record"
        ]);
    }


} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([
        "success" => false,
        "message" => "Server error"
    ]);
}
?>