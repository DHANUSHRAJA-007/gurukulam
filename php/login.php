<?php

require_once 'cors.php';
require_once 'conn.php';

header('Content-Type: application/json');


// =====================================================
// REQUEST METHOD
// =====================================================

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {

    http_response_code(405);

    echo json_encode([
        'success' => false,
        'message' => 'Invalid request method. Use POST.'
    ]);

    exit;
}


// =====================================================
// READ REQUEST DATA
// Supports BOTH:
// 1. application/json
// 2. application/x-www-form-urlencoded
// =====================================================

$contentType = $_SERVER['CONTENT_TYPE'] ?? '';

if (strpos($contentType, 'application/json') !== false) {

    $rawData = file_get_contents('php://input');

    $input = json_decode(
        $rawData,
        true
    );

    if (!is_array($input)) {
        $input = [];
    }

} else {

    // Flutter form-urlencoded request
    $input = $_POST;
}


// =====================================================
// GET USERNAME & PASSWORD
// =====================================================

$username = trim(
    $input['username'] ?? ''
);

$password = trim(
    $input['password'] ?? ''
);


// =====================================================
// VALIDATION
// =====================================================

if ($username === '' || $password === '') {

    http_response_code(400);

    echo json_encode([
        'success' => false,
        'message' => 'Username, password are required'
    ]);

    exit;
}


// =====================================================
// LOGIN
// =====================================================

try {

    $query = "
        SELECT
            id,
            name,
            user_type
        FROM users
        WHERE name = ?
        AND password = ?
        AND status = 'active'
        LIMIT 1
    ";


    $stmt = mysqli_prepare(
        $conn,
        $query
    );


    if (!$stmt) {

        throw new Exception(
            'Query preparation failed: '
            . mysqli_error($conn)
        );
    }


    mysqli_stmt_bind_param(
        $stmt,
        'ss',
        $username,
        $password
    );


    mysqli_stmt_execute($stmt);


    $result =
        mysqli_stmt_get_result($stmt);


    // =================================================
    // SUCCESS
    // =================================================

    if (mysqli_num_rows($result) === 1) {

        $userData =
            mysqli_fetch_assoc($result);


        echo json_encode([
            'success' => true,

            'message' =>
                'Login successful',

            'user' => [
                'id' =>
                    $userData['id'],

                'name' =>
                    $userData['name'],

                'user_type' =>
                    $userData['user_type'],
            ]
        ]);

        exit;
    }


    // =================================================
    // INVALID LOGIN
    // =================================================

    http_response_code(401);

    echo json_encode([
        'success' => false,
        'message' =>
            'Invalid username or password'
    ]);

} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([
        'success' => false,
        'message' =>
            'Server error: '
            . $e->getMessage()
    ]);
}


// =====================================================
// CLOSE CONNECTION
// =====================================================

if (isset($stmt)) {
    mysqli_stmt_close($stmt);
}

if (isset($conn) && $conn) {
    mysqli_close($conn);
}

?>