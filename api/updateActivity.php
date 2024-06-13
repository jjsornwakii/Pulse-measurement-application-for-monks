<?php
    header('Content-Type: application/json');

    include 'connect.php';

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = json_decode(file_get_contents('php://input'), true);

        if (isset($data['user_id']) && isset($data['task_id'])) {

            $stmt = $pdo->prepare("UPDATE tb_activity set activity_status = 1 WHERE user_id = ? AND task_id = ? AND date = CURDATE() LIMIT 1");
            $stmt->execute([$data['user_id'],$data['task_id']]);

        } else {
            // If user_id or task_id is missing, return error message
            echo json_encode(array("error" => "user_id And task_id are required "));
        }
    } else {
        // If the request method is not POST, return error message
        echo json_encode(array("error" => "Only POST requests are allowed"));
    }
?>
