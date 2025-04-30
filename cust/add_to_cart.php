<?php
session_start();
include 'config.php';

if (isset($_SESSION['customer_id']) && $_SERVER['REQUEST_METHOD'] == 'POST') {
    $customer_id = $_SESSION['customer_id'];
    $product_id = $_POST['product_id'];
    $quantity = $_POST['quantity'];

    // Cek apakah customer sudah punya cart
    $queryCart = "SELECT cart_id FROM cart WHERE customer_id = '$customer_id'";
    $resultCart = mysqli_query($conn, $queryCart);
    
    if (mysqli_num_rows($resultCart) > 0) {
        // Jika ada cart, gunakan cart_id yang ada
        $cart = mysqli_fetch_assoc($resultCart);
        $cart_id = $cart['cart_id'];
    } else {
        // Jika belum ada cart, buat cart baru
        $queryCreateCart = "INSERT INTO cart (customer_id) VALUES ('$customer_id')";
        mysqli_query($conn, $queryCreateCart);
        $cart_id = mysqli_insert_id($conn);
    }

    // Cek apakah produk sudah ada di cart_items
    $queryCartItem = "SELECT * FROM cart_items WHERE cart_id = '$cart_id' AND product_id = '$product_id'";
    $resultCartItem = mysqli_query($conn, $queryCartItem);

    if (mysqli_num_rows($resultCartItem) > 0) {
        // Update quantity jika sudah ada
        $item = mysqli_fetch_assoc($resultCartItem);
        $newQuantity = $item['quantity'] + $quantity;
        $total_price = $newQuantity * $item['total_price'] / $item['quantity'];
        $queryUpdateItem = "UPDATE cart_items SET quantity = '$newQuantity', total_price = '$total_price' WHERE cart_item_id = '{$item['cart_item_id']}'";
        mysqli_query($conn, $queryUpdateItem);
    } else {
        // Tambahkan item baru jika belum ada
        $queryProduct = "SELECT product_price FROM product WHERE product_id = '$product_id'";
        $resultProduct = mysqli_query($conn, $queryProduct);
        $product = mysqli_fetch_assoc($resultProduct);
        $total_price = $product['product_price'] * $quantity;

        $queryAddItem = "INSERT INTO cart_items (cart_id, product_id, quantity, total_price) 
                         VALUES ('$cart_id', '$product_id', '$quantity', '$total_price')";
        mysqli_query($conn, $queryAddItem);
    }

    // Redirect ke halaman cart
    header("Location: cart.php");
} else {
    header("Location: loginform.php");
}
?>
