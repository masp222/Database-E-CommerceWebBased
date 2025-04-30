<?php
if(session_id() == '' || !isset($_SESSION)) { session_start(); }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | MikroTik E-Commerce</title>
    <link rel="icon" href="favicon.ico" type="images/logo.jpg">
    <link href="style.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
    body {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background-color: #f8f9fa;
        margin: 0;
    }
    .login-form {
        width: 100%;
        max-width: 400px;
        padding: 20px;
        margin-top: 40px;  /* Jarak di atas */
        margin-bottom: 40px;  /* Jarak di bawah */
        border: 1px solid #ced4da;
        border-radius: 8px;
        background-color: #ffffff;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    }
    .form-title {
        text-align: center;
        margin-bottom: 20px;
    }
    .login-form .btn-primary {
        background-color: #FF4B4B;
        border: none;
        padding: 10px;
        color: white;
        width: 100%;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .login-form .btn-primary:hover {
        background-color: #E04343;
    }
    </style>
</head>
<body>
    <div class="login-form">
        <h2 class="form-title">Login</h2>
        
        <!-- Menampilkan alert jika ada -->
        <?php
        if (isset($_SESSION['alert'])) {
            echo '<div class="alert alert-info text-center" role="alert">' . $_SESSION['alert'] . '</div>';
            unset($_SESSION['alert']);
        }
        ?>

        <form action="login.php" method="POST">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>
        <p class="mt-3 text-center">Don't have an account? <a href="registerform.php">Register</a></p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
