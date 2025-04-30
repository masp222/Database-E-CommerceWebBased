<?php
include 'config.php';
session_start();

function sanitize($data) {
    return htmlspecialchars(stripslashes(trim($data)));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $productId = sanitize($_POST['product_id']); // ID produk yang akan diedit
    $productName = sanitize($_POST['product_name']);
    $categoryId = sanitize($_POST['category_id']);
    $newCategory = sanitize($_POST['new_category']);
    $productDescription = sanitize($_POST['product_description']);
    $productStock = sanitize($_POST['product_stock']);
    $productPrice = sanitize($_POST['product_price']);

    // Jika ada kategori baru yang dimasukkan, tambahkan ke database
    if (!empty($newCategory)) {
        // Cek apakah kategori baru sudah ada
        $categoryQuery = "SELECT * FROM category WHERE category_name = '$newCategory'";
        $categoryResult = mysqli_query($conn, $categoryQuery);

        if (mysqli_num_rows($categoryResult) == 0) {
            // Tambahkan kategori baru ke tabel category
            $insertCategoryQuery = "INSERT INTO category (category_name) VALUES ('$newCategory')";
            if (mysqli_query($conn, $insertCategoryQuery)) {
                // Ambil ID kategori baru yang ditambahkan
                $categoryId = mysqli_insert_id($conn);
            } else {
                $error = "Error adding new category: " . mysqli_error($conn);
            }
        } else {
            // Jika kategori sudah ada, gunakan kategori yang ada
            $category = mysqli_fetch_assoc($categoryResult);
            $categoryId = $category['category_id'];
        }
    }

    // Cek apakah gambar baru diunggah
    $productImage = null;
    if (!empty($_FILES["product_image"]["name"])) {
        $targetDir = "images/";
        $productImage = $targetDir . basename($_FILES["product_image"]["name"]);

        if (!move_uploaded_file($_FILES["product_image"]["tmp_name"], $productImage)) {
            $error = "Error uploading image.";
            $productImage = null;
        }
    }

    // Update data produk di database
    $query = "UPDATE product 
              SET product_name = '$productName', 
                  category_id = '$categoryId', 
                  product_description = '$productDescription', 
                  product_stock = '$productStock', 
                  product_price = '$productPrice'";

    if ($productImage) {
        $query .= ", product_image = '$productImage'";
    }

    $query .= " WHERE product_id = '$productId'";

    if (mysqli_query($conn, $query)) {
        header("Location: products.php?status=updated");
        exit();
    } else {
        $error = "Error updating product: " . mysqli_error($conn);
    }
}
?>
