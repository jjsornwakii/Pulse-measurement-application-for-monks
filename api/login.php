<?php
    header('Content-Type: application/json');

    include 'connect.php';

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = json_decode(file_get_contents('php://input'), true);

        if (isset($data['username']) && isset($data['password'])) {

            try {
                $stmt = $pdo->prepare("SELECT * FROM tb_user WHERE user_username = ? AND user_password = ?");
                $stmt->execute([$data['username'], $data['password']]);
                
                if ($stmt->fetch()) {
                    echo json_encode(array("message" => "success"));
                } else {
                    echo json_encode(array("message" => "username or password not correct"));
                }
            } catch (PDOException $e) {
                echo json_encode(array("message" => "Database error: " . $e->getMessage()));
            }

        } else {
            // If username or password is missing, return error message
            echo json_encode(array("message" => "username or password not provided"));
        }
    } else {
        // If the request method is not POST, return error message
        echo json_encode(array("message" => "Only POST requests are allowed"));
    }
?>
