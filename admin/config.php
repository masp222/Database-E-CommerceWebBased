<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "mikrotik";

// Membuat koneksi
$conn = mysqli_connect("localhost", "root", "", "mikrotik");

if (!$conn) { 
    echo "Connection failed: " . mysqli_connect_error();
} 



?>