<?php
session_start();
// Menghubungkan dengan file config untuk koneksi database
include 'config.php';



// Cek apakah data login sudah dikirim melalui POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Ambil data dari form login
    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);

    // Cek jika username atau password kosong
    if (empty($username) || empty($password)) {
        $_SESSION['alert'] = "Username atau password tidak boleh kosong!";
        header("Location: loginform.php");
        exit;
    }

    // Query untuk mencari username dan password
    $query = "SELECT * FROM login WHERE username = '$username'";
    $result = mysqli_query($conn, $query);

    // Cek apakah username ditemukan
    if (mysqli_num_rows($result) > 0) {
        // Ambil data dari result
        $user = mysqli_fetch_assoc($result);
        
        // Verifikasi password dengan yang ada di database
        if (password_verify($password, $user['password'])) {
            // Set session data
            $_SESSION['username'] = $user['username'];
            $_SESSION['login_id'] = $user['login_id'];
            $_SESSION['customer_id'] = $user['customer_id'];
            

            $_SESSION['alert'] = "Login berhasil!";
            // Redirect ke halaman utama setelah login
            header("Location: index.php");
            exit;
        } else {
            $_SESSION['alert'] = "Username atau password salah!";
            header("Location: loginform.php");
            exit;
        }
    } else {
        $_SESSION['alert'] = "Username atau password salah!";
        header("Location: loginform.php");
        exit;
    }
}
?>
