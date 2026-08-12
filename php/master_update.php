<?php

header("Content-Type: application/json");

require_once "conn.php";


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
$id = intval($_POST["id"] ?? 0);
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

if ($id <= 0) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid ID"
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
// UPDATE
// =====================================================

try {

    // Check record exists

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


    if ($result->num_rows == 0) {

        echo json_encode([
            "success" => false,
            "message" => "Record not found"
        ]);

        exit;
    }


    // Check duplicate

    $duplicate = $conn->prepare(
        "SELECT id
         FROM `$table`
         WHERE LOWER(`$column`) = LOWER(?)
         AND id != ?
         LIMIT 1"
    );

    $duplicate->bind_param(
        "si",
        $value,
        $id
    );

    $duplicate->execute();

    $duplicateResult =
        $duplicate->get_result();


    if ($duplicateResult->num_rows > 0) {

        echo json_encode([
            "success" => false,
            "message" => "This value already exists"
        ]);

        exit;
    }


    // Update

    $stmt = $conn->prepare(
        "UPDATE `$table`
         SET `$column` = ?
         WHERE id = ?"
    );

    $stmt->bind_param(
        "si",
        $value,
        $id
    );


    if ($stmt->execute()) {

        echo json_encode([
            "success" => true,
            "message" => "Updated successfully"
        ]);

    } else {

        echo json_encode([
            "success" => false,
            "message" => "Failed to update record"
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