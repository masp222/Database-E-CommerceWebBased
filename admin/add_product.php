<?php
include 'config.php';

function sanitize($data) {
    return htmlspecialchars(stripslashes(trim($data)));
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $productName = sanitize($_POST['product_name']);
    $categoryId = sanitize($_POST['category_id']);
    $newCategory = sanitize($_POST['new_category']);
    $productDescription = sanitize($_POST['product_description']);
    $productStock = sanitize($_POST['product_stock']);
    $productprice = sanitize($_POST['product_price']);

    // Jika ada kategori baru yang dimasukkan, tambahkan ke database
    if (!empty($newCategory)) {
        // Cek apakah kategori baru sudah ada
        $categoryQuery = "SELECT * FROM category WHERE category_name = '$newCategory'";
        $categoryResult = mysqli_query($conn, $categoryQuery);

        if (mysqli_num_rows($categoryResult) == 0) {
            // Tambahkan kategori baru ke tabel category
            $insertCategoryQuery = "INSERT INTO category (category_name) VALUES ('$newCategory')";
            if (mysqli_query($conn, $insertCategoryQuery)) {
                // Ambil id kategori baru yang ditambahkan
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

    // Upload gambar
    $targetDir = "images/";
    $productImage = $targetDir . basename($_FILES["product_image"]["name"]);

    if (move_uploaded_file($_FILES["product_image"]["tmp_name"], $productImage)) {
        // Simpan data produk ke database
        $query = "INSERT INTO product (product_name, category_id, product_description, product_stock, product_price, product_image) 
                  VALUES ('$productName', '$categoryId', '$productDescription', '$productStock', '$productprice', '$productImage')";

        if (mysqli_query($conn, $query)) {
            header("Location: products.php?status=added");
            exit();
        } else {
            $error = "Error: " . mysqli_error($conn);
        }
    } else {
        $error = "Error uploading image.";
    }
}
?>
