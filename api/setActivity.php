<?php
    header('Content-Type: application/json');

    include 'connect.php';

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = json_decode(file_get_contents('php://input'), true);

        if (isset($data['user_id'])) {

            $stmt = $pdo->prepare("SELECT date FROM tb_activity WHERE user_id = ? AND date = CURDATE() LIMIT 1");
            $stmt->execute([$data['user_id']]);
            $result = $stmt->fetch();

            // If no result found for today's date, insert new data
            if (!$result) {
                // Prepare and execute the INSERT query
                $stmt2 = $pdo->prepare("INSERT INTO tb_activity (date,user_id, task_id)
                    SELECT CURRENT_DATE,tb_user.user_id, tb_task.task_id
                    FROM tb_task
                    INNER JOIN tb_user ON tb_task.type_id = tb_user.type_id AND tb_user.user_id = ?;");
                $stmt2->execute([$data['user_id']]);

                echo json_encode(array("message" => "Data inserted successfully"));
            } else {
                echo json_encode(array("error" => "Data already exists for today's date"));
            }
        } else {
            // If user_id or task_id is missing, return error message
            echo json_encode(array("error" => "user_id is required"));
        }
    } else {
        // If the request method is not POST, return error message
        echo json_encode(array("error" => "Only POST requests are allowed"));
    }
?>
