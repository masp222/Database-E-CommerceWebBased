<?php
session_start();
include 'config.php';

// Pastikan pengguna sudah login
if (!isset($_SESSION['customer_id'])) {
    header("Location: loginform.php");
    exit;
}

// Periksa apakah ada data quantity yang diubah
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['quantity'])) {
    $customer_id = $_SESSION['customer_id'];
    
    // Ambil data quantity yang diubah
    foreach ($_POST['quantity'] as $cart_item_id => $new_quantity) {
        $cart_item_id = intval($cart_item_id);
        $new_quantity = intval($new_quantity);

        if ($new_quantity > 0) {
            // Dapatkan harga produk
            $queryProduct = "SELECT product_price FROM cart_items ci 
                             JOIN product p ON ci.product_id = p.product_id 
                             WHERE ci.cart_item_id = '$cart_item_id' AND ci.cart_id IN (SELECT cart_id FROM cart WHERE customer_id = '$customer_id')";
            $resultProduct = mysqli_query($conn, $queryProduct);
            
            if (mysqli_num_rows($resultProduct) > 0) {
                $product = mysqli_fetch_assoc($resultProduct);
                $total_price = $product['product_price'] * $new_quantity;

                // Update quantity dan total_price di cart_items
                $queryUpdate = "UPDATE cart_items SET quantity = '$new_quantity', total_price = '$total_price' WHERE cart_item_id = '$cart_item_id'";
                mysqli_query($conn, $queryUpdate);
            }
        }
    }

    // Redirect kembali ke halaman cart setelah update
    header("Location: cart.php");
    exit;
} else {
    // Jika tidak ada data quantity yang dikirim, arahkan ke halaman cart
    header("Location: cart.php");
    exit;
}
?>
