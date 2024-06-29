<?php
    include 'connect.php';  

    $stmt = $pdo->query('SELECT hb.*, u.user_fname, u.user_lname
                         FROM tb_health_behavior AS hb
                         INNER JOIN tb_user AS u ON u.user_id = hb.user_id');
    
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Set headers for CSV download
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename=health_behavior_data.csv');

    // Output CSV headers
    $output = fopen('php://output', 'w');
    fputcsv($output, array(
        'Physical Activity Management',
'Leisure Time Usage',
'High-Fiber Foods',
'Healthy Fats',
'Sugary Drinks',
'Sweet Foods',
'Smoking',
'Stress Management',
'Stress Management Techniques',
'Name'

    ));

    // Output data rows
    foreach ($results as $row) {
        fputcsv($output, array(
            $row['item_1'],
            $row['item_2'],
            $row['item_3'],
            $row['item_4'],
            $row['item_5'],
            $row['item_6'],
            $row['item_7'], 
            $row['item_8'],
            $row['item_9'],
            $row['user_fname'] . ' ' . $row['user_lname']
        ));
    }

    fclose($output);
    exit;
?>
