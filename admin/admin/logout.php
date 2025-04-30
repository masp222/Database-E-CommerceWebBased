<?php
// admin/logout.php
session_start();
session_destroy();
header("Location: login_form.php");
exit;
?>
