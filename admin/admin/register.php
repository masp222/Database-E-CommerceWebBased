<?php
// admin/register.php
session_start();

include '../config.php';

function sanitize($data) {
    return htmlspecialchars(stripslashes(trim($data)));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = sanitize($_POST['username']);
    $email = sanitize($_POST['email']);
    $password = md5($_POST['password']); // MD5 encryption

    // Cek apakah username atau email sudah ada
    $query = "SELECT * FROM admin WHERE username = '$username' OR email = '$email'";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        $error = "Username or email already exists!";
    } else {
        // Insert data ke database
        $query = "INSERT INTO admin (username, email, password) VALUES ('$username', '$email', '$password')";
        $result = mysqli_query($conn, $query);

        if ($result) {
            $_SESSION['alert'] = "Registration successful! Please login.";
            header("Location: login_form.php");
            exit;
        } else {
            $error = "Error during registration. Please try again!";
        }
    }
}
?>