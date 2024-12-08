<?php
    include 'connect.php';  

    $stmt = $pdo->query('SELECT hb.*, u.user_fname, u.user_lname
                         FROM tb_health_behavior AS hb
                         INNER JOIN tb_user AS u ON u.user_id = hb.user_id');
    
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Health Behavior Data</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f0f0f0;
            padding: 20px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #e9e9e9;
        }
    </style>
</head>
<body>

<h1>Health Behavior Data</h1>
<p>Total records: <?php echo count($results); ?></p>
<table>
    <thead>
        <tr>
            <th>การบริหารร่างกาย</th>
            <th>การใช้เวลาว่าง</th>
            <th>อาหารที่มีกากใย</th>
            <th>ไขมันที่ดีต่อสุขภาพ</th>
            <th>เครื่องดื่มที่มีน้ำตาล</th>
            <th>อาหารรสหวาน</th>
            <th>สูบบุหรี่</th>
            <th>จัดการความเครียด</th>
            <th>วิธีจัดการความเครียด</th>
            <th>ชื่อ-สกุล</th>
        </tr>
    </thead>
    <tbody> 
        <?php foreach ($results as $row): ?>
            <tr>
                <td><?php echo htmlspecialchars($row["item_1"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_2"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_3"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_4"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_5"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_6"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_7"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_8"]); ?></td>
                <td><?php echo htmlspecialchars($row["item_9"]); ?></td>
                <td><?php echo htmlspecialchars($row["user_fname"] . " " . $row["user_lname"]); ?></td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>

<p><a href="export.php">Export as Spreadsheet</a></p>

<?php
    $pdo = null;
?>
</body>
</html>
