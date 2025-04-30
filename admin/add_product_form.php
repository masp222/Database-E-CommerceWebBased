<?php
include 'config.php'; // Menyertakan file koneksi
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Add New Product</h2>
        <?php if (isset($error)): ?>
            <div class="alert alert-danger"><?php echo $error; ?></div>
        <?php endif; ?>
        <form action="add_product.php" method="POST" enctype="multipart/form-data">
            <div class="mb-3">
                <label for="product_name" class="form-label">Product Name</label>
                <input type="text" class="form-control" id="product_name" name="product_name" required>
            </div>
            <div class="mb-3">
                <label for="category_id" class="form-label">Category</label>
                <select class="form-control" id="category_id" name="category_id">
                    <option value="">Select a category</option>
                    <?php
                    // Ambil daftar kategori dari database
                    $categoryQuery = "SELECT * FROM category";
                    $categoryResult = mysqli_query($conn, $categoryQuery);
                    while ($row = mysqli_fetch_assoc($categoryResult)) {
                        echo '<option value="' . $row['category_id'] . '">' . $row['category_name'] . '</option>';
                    }
                    ?>
                </select>
            </div>
            <div class="mb-3">
                <label for="new_category" class="form-label">Or Add New Category</label>
                <input type="text" class="form-control" id="new_category" name="new_category" placeholder="Enter new category (optional)">
            </div>
            <div class="mb-3">
                <label for="product_image" class="form-label">Product Image</label>
                <input type="file" class="form-control" id="product_image" name="product_image" accept="image/*" required>
            </div>
            <div class="mb-3">
                <label for="product_description">Description:</label>
                <textarea id="product_description" name="product_description" rows="4" required></textarea><br>
            </div>
            <div class="mb-3">
                <label for="product_price" class="form-label">Price</label>
                <input type="number" class="form-control" id="product_price" name="product_price" min="0" required>
            </div>
            <div class="mb-3">
                <label for="product_stock" class="form-label">Stock</label>
                <input type="number" class="form-control" id="product_stock" name="product_stock" min="0" required>
            </div>
            <button type="submit" class="btn btn-primary">Add Product</button>
            <a href="products.php" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>
