<?php
include 'config.php';

if (isset($_GET['id'])) {
    $productId = $_GET['id'];
    
    // Ambil data produk berdasarkan ID untuk ditampilkan di halaman konfirmasi
    $query = "SELECT * FROM product WHERE product_id = $productId";
    $result = mysqli_query($conn, $query);
    $product = mysqli_fetch_assoc($result);

    if (!$product) {
        echo "Product not found.";
        exit();
    }
} else {
    echo "No ID found.";
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Confirm Deletion</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Are you sure you want to delete this product?</h2>
        <div class="alert alert-warning">
            You are about to delete the product <strong><?php echo $product['product_name']; ?></strong>.
            This action cannot be undone.
        </div>
        <form action="delete_product.php" method="POST">
        <a href="delete.php?id=' . $productId . '" class="btn btn-danger btn-sm">Delete</a>
            <a href="products.php" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>
