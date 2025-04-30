<?php
include 'config.php';

if (isset($_GET['id'])) {
    $productId = $_GET['id'];

    // Hapus data di tabel transaction_detail
    $deleteTransactionDetailQuery = "DELETE FROM transaction_detail WHERE product_id = $productId";
    mysqli_query($conn, $deleteTransactionDetailQuery);

    // Hapus data di tabel product
    $deleteProductQuery = "DELETE FROM product WHERE product_id = $productId";
    if (mysqli_query($conn, $deleteProductQuery)) {
        header("Location: products.php?status=deleted");
        exit();
    } else {
        echo "Error deleting product: " . mysqli_error($conn);
    }
} else {
    echo "No ID found.";
}
?>
