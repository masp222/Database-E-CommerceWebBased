<?php
session_start();
session_unset(); // Menghapus semua session
session_destroy(); // Menghancurkan session

// Redirect ke halaman index setelah logout
header("Location: index.php");
exit();
?>
