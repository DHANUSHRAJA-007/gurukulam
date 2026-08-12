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

    exit();
}


// =====================================================
// READ JSON BODY
// =====================================================

$input = json_decode(
    file_get_contents('php://input'),
    true
);


// =====================================================
// GET USERNAME & PASSWORD
// =====================================================

$username = isset($input['username'])
    ? trim($input['username'])
    : '';

$password = isset($input['password'])
    ? trim($input['password'])
    : '';


// =====================================================
// VALIDATION
// =====================================================

if (empty($username) || empty($password)) {

    http_response_code(400);

    echo json_encode([
        'success' => false,
        'message' => 'Username, password are required'
    ]);

    exit();
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
    // USER FOUND
    // =================================================

    if (mysqli_num_rows($result) === 1) {

        $user_data =
            mysqli_fetch_assoc($result);


        // =============================================
        // SESSION
        // =============================================

        session_start();

        $_SESSION['user_id'] =
            $user_data['id'];

        $_SESSION['username'] =
            $user_data['name'];

        $_SESSION['user_type'] =
            $user_data['user_type'];


        // =============================================
        // RESPONSE
        // =============================================

        echo json_encode([

            'success' => true,

            'message' =>
                'Login successful',

            'user' => [

                'id' =>
                    $user_data['id'],

                'name' =>
                    $user_data['name'],

                'user_type' =>
                    $user_data['user_type'],
            ]
        ]);

        exit();

    } else {

        // =============================================
        // INVALID LOGIN
        // =============================================

        http_response_code(401);

        echo json_encode([

            'success' => false,

            'message' =>
                'Invalid username or password'
        ]);

        exit();
    }


} catch (Exception $e) {

    http_response_code(500);

    echo json_encode([

        'success' => false,

        'message' =>
            'Server error: '
            . $e->getMessage()
    ]);

} finally {

    if (isset($stmt)) {
        mysqli_stmt_close($stmt);
    }

    if (isset($conn) && $conn) {
        mysqli_close($conn);
    }
}

?>