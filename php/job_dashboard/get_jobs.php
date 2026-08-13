<?php
// api/get_jobs.php
require_once "cors.php";
require_once "conn.php";

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

try {
    $query = "
        SELECT
            j.id,
            j.job_status,
            j.job_role_id,
            j.industry_id,
            j.work_mode,
            j.location,
            j.salary_min,
            j.salary_max,
            j.age_limit,
            j.minimum_qualification_id,
            j.experience_required,
            j.languages,
            j.skills,
            j.employment_type_id,
            j.work_shift_timing,
            j.number_of_vacancies,
            j.job_benefits,
            j.job_description,
            j.tag_message,
            j.screening_questions,
            j.status,
            j.created_at,

            jr.job_role AS job_role_name,
            i.industry AS industry_name,
            d.degree AS qualification_name,
            et.employment_type AS employment_type_name

        FROM job_master j

        LEFT JOIN job_role jr
            ON jr.id = j.job_role_id

        LEFT JOIN industry_master i
            ON i.id = j.industry_id

        LEFT JOIN degreemaster d
            ON d.id = j.minimum_qualification_id

        LEFT JOIN employment_type et
            ON et.id = j.employment_type_id

        WHERE j.status = 1
        ORDER BY j.id DESC
    ";

    $result = mysqli_query($conn, $query);

    if (!$result) {
        throw new Exception(mysqli_error($conn));
    }

    $data = [];

    while ($row = mysqli_fetch_assoc($result)) {
        // Decode JSON fields
        $row["languages"] = !empty($row["languages"])
            ? json_decode($row["languages"], true)
            : [];

        $row["skills"] = !empty($row["skills"])
            ? json_decode($row["skills"], true)
            : [];

        $row["screening_questions"] = !empty($row["screening_questions"])
            ? json_decode($row["screening_questions"], true)
            : [];

        // Format salary range
        $row["salary_range"] = $row["salary_min"] && $row["salary_max"]
            ? "₹" . number_format($row["salary_min"]) . "–" . number_format($row["salary_max"]) . " LPA"
            : "Not specified";

        $data[] = $row;
    }

    echo json_encode([
        "success" => true,
        "message" => "Jobs fetched successfully",
        "data" => $data
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