<?php
include 'config.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $productId = mysqli_real_escape_string($conn, $_POST['product_id']);
    $productName = mysqli_real_escape_string($conn, $_POST['product_name']);
    $categoryId = mysqli_real_escape_string($conn, $_POST['category_id']);
    $productDescription = mysqli_real_escape_string($conn, $_POST['product_description']);
    $productStock = mysqli_real_escape_string($conn, $_POST['product_stock']);
    $productImage = null;

    // Proses upload gambar jika ada file baru
    if (!empty($_FILES['product_image']['name'])) {
        $targetDir = "images/";
        $productImage = $targetDir . basename($_FILES["product_image"]["name"]);

        if (!move_uploaded_file($_FILES["product_image"]["tmp_name"], $productImage)) {
            die("Error uploading image.");
        }
    }

    // Update data produk
    $query = "UPDATE product SET 
              product_name = '$productName', 
              category_id = '$categoryId', 
              product_description = '$productDescription', 
              product_stock = '$productStock'";

    if ($productImage) {
        $query .= ", product_image = '$productImage'";
    }

    $query .= " WHERE product_id = $productId";

    if (mysqli_query($conn, $query)) {
        header("Location: products.php?status=updated");
        exit();
    } else {
        die("Error: " . mysqli_error($conn));
    }
}
?>
