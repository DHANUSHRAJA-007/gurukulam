<?php

header("Content-Type: application/json");

require_once "conn.php";


// =====================================================
// MASTER TABLE CONFIGURATION
// =====================================================

$masters = [

    "degree" => "degreemaster",

    "education_level" => "educationlevelmaster",

    "employment_type" => "employment_type",

    "industry" => "industry_master",

    "job_role" => "job_role",

    "language" => "languagemaster",

    "major_specialization" =>
        "major_specialization_master"
];


// =====================================================
// GET DATA
// =====================================================

$master = $_POST["master"] ?? "";
$id = intval($_POST["id"] ?? 0);


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


$table = $masters[$master];


// =====================================================
// DELETE / DEACTIVATE
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


    // Soft delete

    $stmt = $conn->prepare(
        "UPDATE `$table`
         SET status = 0
         WHERE id = ?"
    );

    $stmt->bind_param(
        "i",
        $id
    );


    if ($stmt->execute()) {

        echo json_encode([
            "success" => true,
            "message" => "Deleted successfully"
        ]);

    } else {

        echo json_encode([
            "success" => false,
            "message" => "Failed to delete record"
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