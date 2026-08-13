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

$input = json_decode(
    file_get_contents("php://input"),
    true
);

if (!$input) {

    echo json_encode([
        "success" => false,
        "message" => "Invalid JSON data"
    ]);

    exit;
}

try {

    $job_status =
        trim($input["job_status"] ?? "Draft");

    $job_role_id =
        intval($input["job_role_id"] ?? 0);

    $industry_id =
        intval($input["industry_id"] ?? 0);

    $work_mode =
        trim($input["work_mode"] ?? "");

    $location =
        trim($input["location"] ?? "");

    $salary_min =
        $input["salary_min"] !== ""
            ? floatval($input["salary_min"])
            : null;

    $salary_max =
        $input["salary_max"] !== ""
            ? floatval($input["salary_max"])
            : null;

    $gender =
        trim(
            $input["gender_preference"]
            ?? "Any"
        );

    $age_limit =
        $input["age_limit"] !== ""
            ? intval($input["age_limit"])
            : null;

    $qualification_id =
        intval(
            $input[
                "minimum_qualification_id"
            ] ?? 0
        );

    $experience =
        trim(
            $input["experience_required"]
            ?? ""
        );

    $languages =
        json_encode(
            $input["languages"] ?? []
        );

    $skills =
        json_encode(
            $input["skills"] ?? []
        );

    $employment_type_id =
        intval(
            $input["employment_type_id"]
            ?? 0
        );

    $shift =
        trim(
            $input["work_shift_timing"]
            ?? ""
        );

    $vacancies =
        intval(
            $input["number_of_vacancies"]
            ?? 1
        );

    $benefits =
        trim(
            $input["job_benefits"] ?? ""
        );

    $description =
        trim(
            $input["job_description"] ?? ""
        );

    $tag_message =
        trim(
            $input["tag_message"] ?? ""
        );

    $questions =
        json_encode(
            $input["screening_questions"]
            ?? []
        );

    $status =
        intval($input["status"] ?? 1);


    if ($job_role_id <= 0) {
        throw new Exception(
            "Job role is required"
        );
    }

    if ($industry_id <= 0) {
        throw new Exception(
            "Industry is required"
        );
    }


    $stmt = $conn->prepare(
        "INSERT INTO job_master (
            job_status,
            job_role_id,
            industry_id,
            work_mode,
            location,
            salary_min,
            salary_max,
            gender_preference,
            age_limit,
            minimum_qualification_id,
            experience_required,
            languages,
            skills,
            employment_type_id,
            work_shift_timing,
            number_of_vacancies,
            job_benefits,
            job_description,
            tag_message,
            screening_questions,
            status
        )
        VALUES (
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        )"
    );

    $stmt->bind_param(
        "siissddsissssiisssssi",
        $job_status,
        $job_role_id,
        $industry_id,
        $work_mode,
        $location,
        $salary_min,
        $salary_max,
        $gender,
        $age_limit,
        $qualification_id,
        $experience,
        $languages,
        $skills,
        $employment_type_id,
        $shift,
        $vacancies,
        $benefits,
        $description,
        $tag_message,
        $questions,
        $status
    );


    if (!$stmt->execute()) {
        throw new Exception(
            $stmt->error
        );
    }


    echo json_encode([
        "success" => true,
        "message" =>
            "Job created successfully",
        "id" => $stmt->insert_id
    ]);

} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([
        "success" => false,
        "message" =>
            $e->getMessage()
    ]);
}

$conn->close();

?>