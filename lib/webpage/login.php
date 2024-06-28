<?php
include 'connect.php'; // Ensure this file has the correct DB connection settings
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    if (!empty($username) && !empty($password)) {
        $stmt = $conn->prepare('SELECT * FROM tb_admin WHERE admin_username = :username AND admin_password = :password');
        $stmt->bindParam(':username', $username);
        $stmt->bindParam(':password', $password);

        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            header('Location: adminPage.php');
            exit;
        } else {
            $error = 'Invalid username or password';
        }
    } else {
        $error = 'Please enter both username and password';
    }
}
?>


<!DOCTYPE html>
<html lang="en">

<head>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/adminLogin.css">
    <!-- AOS CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.css" />
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Prompt:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900&display=swap" rel="stylesheet">
    <style>
      body {
        display: flex;
        height: 100vh;
        margin: 0;
        align-items: center;
        justify-content: center;
        background-image: linear-gradient(
            0deg,
            rgba(0, 0, 0, 0.5),
            rgba(0, 0, 0, 0.5)
          ),
          url("assets/background/web_bg.png");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
        background-attachment: fixed;
        }
      .container {
        display: flex;
        position: relative;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        border: 1px solid white;
        border-radius: 20px;
        width: 35%;
        height: 50%;
        background-color: rgb(0, 0, 0); /* Fallback color */
        background-color: rgba(0, 0, 0, 0.4);
        min-width: 350px;
        min-height: 350px;
        gap: 30px;
      }

      .container h1 {
        display: flex;
        margin: 0;
        color: white;
        font-size: 50px;
      }

      .form-container {
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        gap: 35px;
        margin-bottom: 15px;
      }

      .input-container {
        display: flex;
        flex-direction: column;
        gap: 20px;
      }

      .input-field {
        min-width: 270px;
        min-height: 50px;
        border-radius: 40px;
        background-color: transparent;
        border: 1px solid white;
        color: white;
        padding-left: 30px;
      }

      .input-field::placeholder {
        font-family: "Prompt", sans-serif;
        font-weight: 400;
        color: white;
      }

      .login-button {
        min-width: 300px;
        min-height: 50px;
        border-radius: 40px;
        font-family: "Prompt", sans-serif;
        font-weight: 400;
        color: black;
        font-size: 20px;
      }

      .prompt-regular {
        font-family: "Prompt", sans-serif;
        font-weight: 400;
        font-style: normal;
      }
    </style>
</head>

<body>
    <div class="bg-image"></div>
    <div class="container" data-aos="fade-up">
        <h1 class="prompt-regular" data-aos="fade-in">Login</h1>
        <form class="form-container" method="post" action="login.php">
            <div class="input-container" data-aos="fade-right">
                <input type="text" id="username" name="username" placeholder="Username" class="input-field" required>
                <input type="password" id="password" name="password" placeholder="Password" class="input-field" required>
            </div>
            <input type="submit" value="Login" class="login-button" data-aos="fade-left">
        </form>
        <?php if (!empty($error)) : ?>
            <p style="color: red;"><?php echo htmlspecialchars($error); ?></p>
        <?php endif; ?>
    </div>
    <!-- AOS JS -->
    <script src="https://cdn.jsdelivr.net/npm/aos@2.3.4/dist/aos.js"></script>
    <script>
        AOS.init({
            once: false,
            duration: 800,
            easing: 'ease',
        });
    </script>
</body>

