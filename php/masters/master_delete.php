<?php

require_once "cors.php";
require_once "conn.php";

header("Content-Type: application/json");

// =====================================================
// HANDLE PREFLIGHT REQUEST
// =====================================================

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit();
}

// =====================================================
// ONLY POST ALLOWED
// =====================================================

if ($_SERVER["REQUEST_METHOD"] !== "POST") {

    http_response_code(405);

    echo json_encode([
        "success" => false,
        "message" => "Only POST method is allowed"
    ]);

    exit;
}

// =====================================================
// MASTER TABLE CONFIGURATION
// =====================================================

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
       ,
         "location" =>
                 "location_master",


];

// =====================================================
// GET POST DATA
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
// SOFT DELETE
// =====================================================

try {

    // -------------------------------------------------
    // CHECK RECORD
    // -------------------------------------------------

    $check = $conn->prepare(
        "SELECT id
         FROM `$table`
         WHERE id = ?
         LIMIT 1"
    );

    if (!$check) {
        throw new Exception(
            "Prepare failed: " .
            $conn->error
        );
    }

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

    // -------------------------------------------------
    // SOFT DELETE
    // -------------------------------------------------

    $stmt = $conn->prepare(
        "UPDATE `$table`
         SET status = 0
         WHERE id = ?"
    );

    if (!$stmt) {
        throw new Exception(
            "Delete prepare failed: " .
            $conn->error
        );
    }

    $stmt->bind_param(
        "i",
        $id
    );

    if (!$stmt->execute()) {

        throw new Exception(
            "Delete failed: " .
            $stmt->error
        );
    }

    echo json_encode([
        "success" => true,
        "message" => "Deleted successfully",
        "id" => $id
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