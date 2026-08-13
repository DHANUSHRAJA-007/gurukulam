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

    "degree" => [
        "table" => "degreemaster",
        "column" => "degree"
    ],

    "education_level" => [
        "table" => "educationlevelmaster",
        "column" => "educationlevel"
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
    ],
      "location" => [
            "table" => "location_master",
            "column" => "location"
        ],

];

// =====================================================
// GET POST DATA
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

    // -------------------------------------------------
    // CHECK RECORD EXISTS
    // -------------------------------------------------

    $check = $conn->prepare(
        "SELECT id
         FROM `$table`
         WHERE id = ?
         LIMIT 1"
    );

    if (!$check) {
        throw new Exception(
            "Prepare failed: " . $conn->error
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
    // CHECK DUPLICATE
    // -------------------------------------------------

    $duplicate = $conn->prepare(
        "SELECT id
         FROM `$table`
         WHERE LOWER(`$column`) = LOWER(?)
         AND id != ?
         LIMIT 1"
    );

    if (!$duplicate) {
        throw new Exception(
            "Duplicate check failed: " .
            $conn->error
        );
    }

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

    // -------------------------------------------------
    // UPDATE RECORD
    // -------------------------------------------------

    $stmt = $conn->prepare(
        "UPDATE `$table`
         SET `$column` = ?
         WHERE id = ?"
    );

    if (!$stmt) {
        throw new Exception(
            "Update prepare failed: " .
            $conn->error
        );
    }

    $stmt->bind_param(
        "si",
        $value,
        $id
    );

    if (!$stmt->execute()) {

        throw new Exception(
            "Update failed: " .
            $stmt->error
        );
    }

    echo json_encode([
        "success" => true,
        "message" => "Updated successfully",
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