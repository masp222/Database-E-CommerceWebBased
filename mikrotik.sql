-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 30, 2024 at 11:00 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mikrotik`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addCustomer` (IN `c_first_name` VARCHAR(100), IN `c_last_name` VARCHAR(100), IN `c_email` VARCHAR(100), IN `c_phone_number` VARCHAR(20), IN `c_customer_address` VARCHAR(255))   BEGIN
    INSERT INTO customer (first_name, last_name, email, phone_number, customer_address)
    VALUES (c_first_name, c_last_name, c_email, c_phone_number, c_customer_address);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateTransactionData` ()   BEGIN
    DECLARE i INT DEFAULT 6;
    DECLARE cust_id INT;
    DECLARE prod_id INT;

    WHILE i <= 100 DO
        SET cust_id = FLOOR(4 + RAND() * 10); -- Pilih customer_id random
        SET prod_id = FLOOR(1 + RAND() * 33); -- Pilih product_id random
        INSERT INTO `transaction` (`transaction_id`, `transaction_date`, `customer_id`, `admin_id`)
        VALUES (i, DATE_ADD('2024-12-01', INTERVAL i DAY), cust_id, NULL);

        INSERT INTO `transaction_detail` (`transaction_detail_id`, `transaction_id`, `product_id`, `quantity`, `total_price`, `status`, `payment_proof`, `transaction_description`)
        VALUES (i, i, prod_id, FLOOR(1 + RAND() * 5), FLOOR(500000 + RAND() * 2000000), 
                CASE FLOOR(RAND() * 3)
                    WHEN 0 THEN 'completed'
                    WHEN 1 THEN 'pending'
                    ELSE 'cancelled'
                END, 
                NULL, CONCAT('Pembelian produk dengan ID ', prod_id));
        SET i = i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Customer_Transactions` (IN `customer_id` INT)   BEGIN
    SELECT 
        t.transaction_id,
        t.transaction_date,
        td.product_id,
        p.product_name,
        td.quantity,
        td.total_price
    FROM 
        transaction t
    JOIN 
        transaction_detail td ON t.transaction_id = td.transaction_id
    JOIN 
        product p ON td.product_id = p.product_id
    WHERE 
        t.customer_id = customer_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertProduct` (IN `p_product_name` VARCHAR(100), IN `p_product_price` DECIMAL(10,2), IN `p_product_description` TEXT, IN `p_category_id` INT, IN `p_product_image` VARCHAR(255), IN `p_product_stock` INT)   BEGIN
INSERT INTO product (
product_name,
product_price,
product_description,
category_id,
product_image,
product_stock
) VALUES (
p_product_name,
p_product_price,
p_product_description,
p_category_id,
p_product_image,
p_product_stock
);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertTransaction` (IN `p_transaction_id` INT, IN `p_transaction_date` DATETIME, IN `p_customer_id` INT)   BEGIN
INSERT INTO `transaction` (transaction_id, transaction_date, customer_id)
VALUES (p_transaction_id, p_transaction_date, p_customer_id);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(32) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `username`, `password`, `email`) VALUES
(1, 'aku', '89ccfac87d8d06db06bf3211cb2d69ed', 'aku@gmail.com'),
(2, 'ado', '421359a899e6aeb972c11a26fb52ad15', 'ado@gmail.com'),
(3, 'anis', '38a1ffb5ccad9612d3d28d99488ca94b', 'ana@gmail.com'),
(4, 'aniss', '38a1ffb5ccad9612d3d28d99488ca94b', 'anad@gmail.com'),
(5, 'aaaa', '74b87337454200d4d33f80c4663dc5e5', 'agus@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`cart_id`, `customer_id`) VALUES
(8, 4),
(9, 5);

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `cart_item_id` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `total_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`cart_item_id`, `cart_id`, `product_id`, `quantity`, `total_price`) VALUES
(25, 9, 1, 3, 60000.00);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `category_name`) VALUES
(1, 'router'),
(3, 'antena'),
(4, 'switch'),
(5, 'RJ45 Connector');

-- --------------------------------------------------------

--
-- Stand-in structure for view `ccustomer_transaction_history`
-- (See below for the actual view)
--
CREATE TABLE `ccustomer_transaction_history` (
`customer_id` int(11)
,`customer_name` varchar(201)
,`transaction_id` int(11)
,`transaction_date` datetime
,`product_id` int(11)
,`product_name` varchar(100)
,`quantity` int(11)
,`total_price` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `customer_address` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `first_name`, `last_name`, `email`, `phone_number`, `customer_address`) VALUES
(4, 'agus', 'efendi', 'agus@gmail.com', '082132137431', 'Jl. Sudirman No. 45, Kelurahan Setiabudi, Kecamatan Setiabudi, Jakarta Selatan, DKI Jakarta 12920'),
(5, 'arifin', 'ilham', 'ilhamku2005@gmail.com', '08213107431', 'Jl. Diponegoro No. 17, Kelurahan Citarum, Kecamatan Bandung Wetan, Bandung, Jawa Barat 40115'),
(7, 'ana', 'eni', 'ana@gmail.com', '085132137431', 'Jl. Malioboro No. 12, Kelurahan Suryatmajan, Kecamatan Danurejan, Yogyakarta 55213'),
(8, 'arian', 'febrian', 'arian@gmail.com', '08213336631', 'Jl. Pemuda No. 88, Kelurahan Sekayu, Kecamatan Semarang Tengah, Semarang, Jawa Tengah 50132'),
(9, 'agung', 'raidi', 'agungrde@gmail.com', '082135037431', 'Jl. Basuki Rahmat No. 25, Kelurahan Kedungdoro, Kecamatan Tegalsari, Surabaya, Jawa Timur 60261'),
(11, 'anas', 'haryadi', 'an.harya@gmail.com', '08515037431', 'Jl. Ahmad Yani No. 10, Kelurahan Kedungrejo, Kecamatan Waru, Sidoarjo, Jawa Timur 61256'),
(12, 'ari', 'gumilang', 'arigu@gmail.com', '082135037431', 'Jl. Asia Afrika No. 9, Kelurahan Braga, Kecamatan Sumur Bandung, Bandung, Jawa Barat 40111'),
(13, 'arzak', 'kristiawan', 'arzakchillguyjakbar@gmail.com', '085132137431', 'Jl. Panglima Sudirman No. 34, Kelurahan Sukorejo, Kecamatan Blimbing, Malang, Jawa Timur 65125'),
(14, 'ahmad', 'dana', 'danaahmad@gmail.com', '0815537431', 'Jl. Kartini No. 5, Kelurahan Kartini, Kecamatan Sawah Besar, Jakarta Pusat, DKI Jakarta 10750');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `login_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`login_id`, `customer_id`, `username`, `password`) VALUES
(4, 4, 'agus', '$2y$10$TvyzDpYcAtE5QlJb5UtUJOBceRCTOrvmOKJkq.jCLJnCgcYZTaET6'),
(5, 5, 'arifin', '$2y$10$wEq0cqY2cx1nCwGT/lfpSODFuex3MqSE3v9pk3cwNjiCw/BWajP5i'),
(6, 7, 'ae', '$2y$10$LgynevrxA6OVR/2/DawT6u0KjELgLMaK00.gNtxSR/fm6jZlzEmx.'),
(7, 8, 'ags', '$2y$10$c3IUJwoMD6a8IytQ9LTb3.YqotPbFD4ao43ffn2fm12FKbWqaYYQy'),
(8, 9, 'ads', '$2y$10$na4VEwbzaIigNYStLWgF5.3JHDyPX5r1Jovvls/BY1zoRkzazALTa'),
(9, 11, 'agoes', '$2y$10$TJe7fDxtkQrz5HVJu/Eln.oJikBKYpPX24UnNSkvXipPCvBEhWO/a'),
(10, 12, 'arian', '$2y$10$nXMTQbVYfH.aCgb9OJTZVuBPAw8n5jQyZkzxaa7K3PH05fgNQ.XMS'),
(11, 13, 'arz', '$2y$10$d2TKtSziZwz7HZKd.aHH5.ADxLKrr.BJqW3oI2B9RlGgdFW.ZiVCG'),
(12, 14, 'qwe', '$2y$10$f2V/zM9sdkeoS7las6DSv.A/NED1g.FsMeQPO6dgYk5XH1YCfoSHK');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(100) NOT NULL,
  `product_price` decimal(10,2) NOT NULL,
  `product_description` text DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `product_image` varchar(255) NOT NULL,
  `product_stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `product_name`, `product_price`, `product_description`, `category_id`, `product_image`, `product_stock`) VALUES
(1, 'Antena Omni Vezatech 15 dbi 2.4 Ghz ( Connect )', 775000.00, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', 3, 'images/yy.jpg', 99),
(22, 'UBNT Edge Point Router 6 24 V EP-R6 ( Gloria )', 1500000.00, 'LorLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborumx ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', 1, 'images/ubiquiti.jpg', 22),
(28, 'UBNT Unifi Switch FLEX USW-FLEX ( Spectrum )', 1688865.00, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum', 4, 'images/ubiquitiswc.jpeg', 10),
(29, 'SFP to RJ45 S-RJ01', 460000.00, 'MikroTik S+RJ10 / SFP S RJ10 / SFP MikroTik S+RJ10 ini membuka seluruh dunia dengan kemungkinan konektivitas berkecepatan tinggi, menawarkan kecepatan hingga 10 Gbps', 5, 'images/S-RJ01_2.jpg', 10),
(30, 'Dlink DWR-M910 Wireless N300 4G LTE Router', 500000.00, 'Dlink DWR-M910 Wireless N300 4G LTE Router  2.4GHz (300Mbps)', 1, 'images/drou.png', 30),
(31, 'Antena Omni HG5812U-PRO Hyperlink 12 dbi', 1850000.00, 'Hyperlink Omni Directional 12db 5,8ghz', 3, 'images/ann 11.jpg', 8),
(32, 'Switch Dlink 24 Port DGS 1100-24 EasySmart Switch 12 10', 1614000.00, 'TEG1024F provides 24 10/100/1000 Mbps auto-negotiation RJ45 ports, 2 gigabit SFP slots and offers a data rate in full duplex of as high as 2000 Mbps.', 4, 'images/dgs1100.jpg', 13),
(33, 'Switch HUB 8 Port Gigabit 1420-8G JH329A', 671000.00, 'Switch Unmanaged, plug-n-play\r\n8 Port Gigabit Ethernet Support CAT5e', 4, 'images/hpJH3A.jpg', 18);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_stock_status`
-- (See below for the actual view)
--
CREATE TABLE `product_stock_status` (
`product_id` int(11)
,`product_name` varchar(100)
,`product_stock` int(11)
,`stock_status` varchar(12)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `sales_report`
-- (See below for the actual view)
--
CREATE TABLE `sales_report` (
`product_id` int(11)
,`product_name` varchar(100)
,`total_quantity_sold` decimal(32,0)
,`total_revenue` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `suplier`
--

CREATE TABLE `suplier` (
  `suplier_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_stock` int(100) DEFAULT NULL,
  `product_price` decimal(10,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suplier`
--

INSERT INTO `suplier` (`suplier_id`, `product_id`, `product_stock`, `product_price`) VALUES
(1, 31, 234, 700000),
(2, 1, 100, 1750000);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` int(11) NOT NULL,
  `transaction_date` datetime DEFAULT current_timestamp(),
  `customer_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`transaction_id`, `transaction_date`, `customer_id`, `admin_id`) VALUES
(1, '2024-12-01 00:00:00', 4, NULL),
(2, '2024-12-02 00:00:00', 5, NULL),
(3, '2024-12-03 00:00:00', 7, NULL),
(4, '2024-12-04 00:00:00', 8, NULL),
(5, '2024-12-05 00:00:00', 9, NULL),
(9, '2024-05-15 11:09:00', 8, NULL),
(10, '2024-04-21 12:00:00', 12, NULL),
(11, '2024-03-12 10:00:00', 9, NULL),
(12, '2024-02-10 13:00:00', 5, NULL),
(13, '2024-01-18 08:00:00', 7, NULL),
(14, '2024-04-30 10:12:25', 14, NULL),
(15, '2024-05-20 07:15:00', 11, NULL),
(16, '2024-03-01 06:21:00', 4, NULL),
(17, '2024-02-25 09:00:00', 13, NULL),
(18, '2024-01-05 05:12:00', 8, NULL),
(29, '2024-12-16 08:22:54', 7, 1),
(30, '2024-11-20 08:25:09', 7, NULL),
(31, '2024-08-21 08:25:09', 7, NULL),
(32, '2024-12-16 19:04:49', 7, NULL),
(33, '2024-12-17 18:40:53', 7, 1),
(35, '2024-04-08 00:00:00', 9, NULL),
(36, '2024-07-07 00:00:00', 12, NULL),
(37, '2024-12-22 00:00:00', 7, NULL),
(38, '2024-12-23 00:00:00', 8, NULL),
(39, '2024-12-24 00:00:00', 9, NULL),
(40, '2024-12-25 00:00:00', 11, NULL),
(41, '2024-12-26 00:00:00', 12, NULL),
(42, '2024-12-27 00:00:00', 13, NULL),
(43, '2024-12-28 00:00:00', 14, NULL),
(44, '2024-12-29 00:00:00', 5, NULL),
(45, '2024-12-01 00:00:00', 4, NULL),
(46, '2024-12-02 00:00:00', 7, NULL),
(47, '2024-12-03 00:00:00', 8, NULL),
(48, '2024-12-04 00:00:00', 9, NULL),
(49, '2024-12-05 00:00:00', 11, NULL),
(50, '2024-12-06 00:00:00', 12, NULL),
(51, '2024-12-07 00:00:00', 13, NULL),
(52, '2024-12-08 00:00:00', 14, NULL),
(53, '2024-12-09 00:00:00', 4, NULL),
(54, '2024-12-10 00:00:00', 5, NULL),
(55, '2023-12-01 00:00:00', 4, NULL),
(56, '2023-12-02 00:00:00', 5, NULL),
(57, '2023-12-03 00:00:00', 7, NULL),
(58, '2023-12-04 00:00:00', 8, NULL),
(59, '2023-12-05 00:00:00', 9, NULL),
(60, '2023-12-06 00:00:00', 11, NULL),
(61, '2023-12-07 00:00:00', 12, NULL),
(62, '2023-12-08 00:00:00', 13, NULL),
(63, '2023-12-09 00:00:00', 14, NULL),
(64, '2023-12-10 00:00:00', 4, NULL),
(65, '2023-01-15 00:00:00', 4, NULL),
(66, '2023-02-18 00:00:00', 5, NULL),
(67, '2023-03-22 00:00:00', 7, NULL),
(68, '2023-04-10 00:00:00', 8, NULL),
(69, '2023-05-14 00:00:00', 9, NULL),
(70, '2023-06-20 00:00:00', 11, NULL),
(71, '2023-07-02 00:00:00', 12, NULL),
(72, '2023-08-25 00:00:00', 13, NULL),
(73, '2023-09-09 00:00:00', 14, NULL),
(74, '2023-11-01 00:00:00', 4, NULL),
(75, '2023-01-25 00:00:00', 5, NULL),
(76, '2023-02-07 00:00:00', 8, NULL),
(77, '2023-03-12 00:00:00', 9, NULL),
(78, '2023-04-15 00:00:00', 11, NULL),
(79, '2023-05-19 00:00:00', 12, NULL),
(80, '2023-06-10 00:00:00', 14, NULL),
(81, '2023-07-13 00:00:00', 4, NULL),
(82, '2023-08-20 00:00:00', 7, NULL),
(83, '2023-10-05 00:00:00', 13, NULL),
(84, '2023-10-18 00:00:00', 5, NULL),
(85, '2024-06-03 00:00:00', 4, NULL),
(86, '2024-06-15 00:00:00', 5, NULL),
(87, '2024-06-25 00:00:00', 7, NULL),
(88, '2024-09-02 00:00:00', 8, NULL),
(89, '2024-09-11 00:00:00', 9, NULL),
(90, '2024-09-22 00:00:00', 11, NULL),
(91, '2024-10-01 00:00:00', 12, NULL),
(92, '2024-10-08 00:00:00', 13, NULL),
(93, '2024-10-18 00:00:00', 14, NULL),
(94, '2024-10-28 00:00:00', 4, NULL),
(95, '2024-06-05 00:00:00', 8, NULL),
(96, '2024-06-12 00:00:00', 9, NULL),
(97, '2024-06-20 00:00:00', 11, NULL),
(98, '2024-09-06 00:00:00', 4, NULL),
(99, '2024-09-15 00:00:00', 7, NULL),
(100, '2024-09-25 00:00:00', 5, NULL),
(101, '2024-10-03 00:00:00', 13, NULL),
(102, '2024-10-07 00:00:00', 14, NULL),
(103, '2024-10-12 00:00:00', 4, NULL),
(104, '2024-10-23 00:00:00', 12, NULL),
(105, '2024-06-07 00:00:00', 12, NULL),
(106, '2024-06-13 00:00:00', 13, NULL),
(107, '2024-06-18 00:00:00', 14, NULL),
(108, '2024-09-10 00:00:00', 4, NULL),
(109, '2024-09-13 00:00:00', 5, NULL),
(110, '2024-09-18 00:00:00', 7, NULL),
(111, '2024-10-02 00:00:00', 8, NULL),
(112, '2024-10-06 00:00:00', 9, NULL),
(113, '2024-10-14 00:00:00', 11, NULL),
(114, '2024-10-22 00:00:00', 12, NULL),
(134, '2024-06-17 00:00:00', 7, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_detail`
--

CREATE TABLE `transaction_detail` (
  `transaction_detail_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `status` enum('cancelled','pending','completed') NOT NULL DEFAULT 'pending',
  `payment_proof` varchar(255) NOT NULL,
  `transaction_description` varchar(255) DEFAULT 'sedang diproses'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_detail`
--

INSERT INTO `transaction_detail` (`transaction_detail_id`, `transaction_id`, `product_id`, `quantity`, `total_price`, `status`, `payment_proof`, `transaction_description`) VALUES
(1, 1, 1, 2, 1550000.00, 'completed', 'proof1.jpg', 'Pembelian antena omni'),
(2, 1, 22, 1, 1500000.00, 'completed', 'proof2.jpg', 'Pembelian router Edge Point'),
(3, 2, 28, 3, 5066595.00, 'pending', '', 'Switch Unifi Switch FLEX'),
(4, 3, 29, 1, 460000.00, 'cancelled', '', 'Pembelian MikroTik SFP'),
(5, 4, 30, 4, 2000000.00, 'completed', 'proof3.jpg', 'Dlink Wireless Router'),
(6, 5, 31, 1, 1850000.00, 'completed', 'proof4.jpg', 'Antena Omni Hyperlink'),
(7, 5, 32, 2, 3228000.00, 'pending', '', 'Dlink EasySmart Switch'),
(8, 5, 33, 3, 2013000.00, 'completed', 'proof5.jpg', 'Switch HUB Gigabit'),
(10, 9, 1, 3, 23250000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran Berhasil'),
(11, 10, 30, 1, 500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran Berhasil'),
(12, 11, 22, 2, 3000000.00, 'pending', 'uploads/proof.jpeg', ''),
(13, 12, 28, 1, 1688865.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran Berhasil'),
(14, 13, 31, 2, 3700000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran Berhasil'),
(15, 14, 33, 1, 6710000.00, 'pending', 'uploads/proof.jpeg', ''),
(16, 15, 32, 1, 1614000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran Berhasil'),
(17, 16, 29, 2, 920000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran Berhasil'),
(18, 17, 22, 1, 1500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran Berhasil'),
(19, 18, 28, 3, 5066595.00, 'pending', 'uploads/proof.jpeg', ''),
(29, 29, 22, 3, 4500000.00, 'completed', 'uploads/proof.jpeg', 'berhasil'),
(30, 30, 1, 1, 775000.00, 'pending', 'uploads/proof.jpeg', ''),
(31, 31, 28, 1, 1688865.00, 'pending', 'uploads/proof.jpeg', ''),
(32, 32, 22, 1, 1500000.00, 'pending', 'uploads/proof.jpeg', ''),
(33, 32, 1, 2, 1550000.00, 'pending', 'uploads/proof.jpeg', ''),
(34, 33, 29, 2, 920000.00, 'completed', 'uploads/proof.jpeg', 'selesai'),
(36, 36, 22, 1, 1500000.00, 'pending', 'proof_36.jpg', 'Pembayaran menunggu konfirmasi untuk UBNT Edge Point Router'),
(37, 37, 28, 3, 5066595.00, 'completed', 'proof_37.jpg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(38, 38, 29, 5, 2300000.00, 'cancelled', '', 'Pembayaran gagal untuk SFP to RJ45 S-RJ01 (Order dibatalkan)'),
(39, 39, 30, 2, 1000000.00, 'completed', 'proof_39.jpg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(40, 40, 31, 1, 1850000.00, 'pending', 'proof_40.jpg', 'Pembayaran menunggu konfirmasi untuk Antena Omni HG5812U-PRO'),
(41, 41, 32, 1, 1614000.00, 'completed', 'proof_41.jpg', 'Pembayaran berhasil untuk Dlink 24 Port Switch'),
(42, 42, 33, 4, 2684000.00, 'completed', 'proof_42.jpg', 'Pembayaran berhasil untuk Switch HUB 8 Port Gigabit'),
(43, 43, 1, 1, 775000.00, 'pending', 'proof_43.jpg', 'Pembayaran menunggu konfirmasi untuk Antena Omni Vezatech'),
(44, 44, 28, 2, 3377730.00, 'completed', 'proof_44.jpg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(45, 45, 1, 3, 2325000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni Vezatech'),
(46, 46, 22, 2, 3000000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk UBNT Edge Point Router'),
(47, 47, 28, 1, 1688865.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(48, 48, 29, 2, 920000.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk SFP to RJ45 S-RJ01 (Order dibatalkan)'),
(49, 49, 30, 4, 2000000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(50, 50, 31, 2, 3700000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Antena Omni HG5812U-PRO'),
(51, 51, 32, 1, 1614000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink 24 Port Switch'),
(52, 52, 33, 5, 3355000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Switch HUB 8 Port Gigabit'),
(53, 53, 1, 4, 3100000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Antena Omni Vezatech'),
(54, 54, 28, 3, 5066595.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(55, 55, 1, 3, 2325000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni Vezatech'),
(56, 56, 22, 2, 3000000.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk UBNT Edge Point Router (Order dibatalkan)'),
(57, 57, 28, 1, 1688865.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(58, 58, 29, 5, 2300000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk SFP to RJ45 S-RJ01'),
(59, 59, 30, 2, 1000000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(60, 60, 31, 2, 3700000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni HG5812U-PRO'),
(61, 61, 32, 1, 1614000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Dlink 24 Port Switch'),
(62, 62, 33, 3, 2013000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Switch HUB 8 Port Gigabit'),
(63, 63, 1, 1, 775000.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk Antena Omni Vezatech (Order dibatalkan)'),
(64, 64, 28, 2, 3377730.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(65, 65, 1, 2, 1550000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni Vezatech'),
(66, 66, 22, 1, 1500000.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk UBNT Edge Point Router (Order dibatalkan)'),
(67, 67, 28, 3, 5066595.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk UBNT Unifi Switch FLEX'),
(68, 68, 29, 4, 1840000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk SFP to RJ45 S-RJ01'),
(69, 69, 30, 1, 500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(70, 70, 31, 1, 1850000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni HG5812U-PRO'),
(71, 71, 32, 2, 3228000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Dlink 24 Port Switch'),
(72, 72, 33, 1, 671000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Switch HUB 8 Port Gigabit'),
(73, 73, 1, 1, 775000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni Vezatech'),
(74, 74, 28, 3, 5066595.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk UBNT Unifi Switch FLEX (Order dibatalkan)'),
(75, 75, 28, 2, 3377730.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(76, 76, 30, 1, 500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(77, 77, 29, 3, 1380000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk SFP to RJ45 S-RJ01'),
(78, 78, 32, 1, 1614000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink 24 Port Switch'),
(79, 79, 33, 2, 1342000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Switch HUB 8 Port Gigabit'),
(80, 80, 1, 3, 2325000.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk Antena Omni Vezatech (Order dibatalkan)'),
(81, 81, 22, 1, 1500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Edge Point Router'),
(82, 82, 31, 1, 1850000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni HG5812U-PRO'),
(83, 83, 28, 2, 3377730.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(84, 84, 32, 2, 3228000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Dlink 24 Port Switch'),
(85, 85, 29, 2, 920000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk SFP to RJ45 S-RJ01'),
(86, 86, 32, 1, 1614000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Dlink 24 Port Switch'),
(87, 87, 28, 1, 1688865.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Unifi Switch FLEX'),
(88, 88, 30, 1, 500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(89, 89, 33, 1, 671000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Switch HUB 8 Port Gigabit'),
(90, 90, 31, 1, 1850000.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk Antena Omni HG5812U-PRO (Order dibatalkan)'),
(91, 91, 1, 2, 1550000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni Vezatech'),
(92, 92, 29, 3, 1380000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk SFP to RJ45 S-RJ01'),
(93, 93, 22, 1, 1500000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk UBNT Edge Point Router'),
(94, 94, 32, 1, 1614000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink 24 Port Switch'),
(95, 95, 22, 1, 1500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Edge Point Router'),
(96, 96, 28, 1, 1688865.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk UBNT Unifi Switch FLEX'),
(97, 97, 29, 2, 920000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk SFP to RJ45 S-RJ01'),
(98, 98, 30, 1, 500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(99, 99, 31, 2, 3700000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni HG5812U-PRO'),
(100, 100, 33, 3, 2013000.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk Switch HUB 8 Port Gigabit (Order dibatalkan)'),
(101, 101, 1, 1, 775000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni Vezatech'),
(102, 102, 32, 1, 1614000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink 24 Port Switch'),
(103, 103, 28, 2, 3377730.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk UBNT Unifi Switch FLEX'),
(104, 104, 29, 1, 460000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk SFP to RJ45 S-RJ01'),
(105, 105, 29, 1, 460000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk SFP to RJ45 S-RJ01'),
(106, 106, 31, 1, 1850000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni HG5812U-PRO'),
(107, 107, 33, 2, 1342000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Switch HUB 8 Port Gigabit'),
(108, 108, 1, 3, 2325000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni Vezatech'),
(109, 109, 22, 1, 1500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk UBNT Edge Point Router'),
(110, 110, 28, 1, 1688865.00, 'cancelled', 'uploads/proof.jpeg', 'Pembayaran gagal untuk UBNT Unifi Switch FLEX (Order dibatalkan)'),
(111, 111, 30, 1, 500000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Dlink DWR-M910 Wireless Router'),
(112, 112, 32, 2, 3228000.00, 'pending', 'uploads/proof.jpeg', 'Pembayaran menunggu konfirmasi untuk Dlink 24 Port Switch'),
(113, 113, 29, 1, 460000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk SFP to RJ45 S-RJ01'),
(114, 114, 31, 1, 1850000.00, 'completed', 'uploads/proof.jpeg', 'Pembayaran berhasil untuk Antena Omni HG5812U-PRO');

-- --------------------------------------------------------

--
-- Structure for view `ccustomer_transaction_history`
--
DROP TABLE IF EXISTS `ccustomer_transaction_history`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ccustomer_transaction_history`  AS SELECT `c`.`customer_id` AS `customer_id`, concat(`c`.`first_name`,' ',`c`.`last_name`) AS `customer_name`, `t`.`transaction_id` AS `transaction_id`, `t`.`transaction_date` AS `transaction_date`, `td`.`product_id` AS `product_id`, `p`.`product_name` AS `product_name`, `td`.`quantity` AS `quantity`, `td`.`total_price` AS `total_price` FROM (((`customer` `c` join `transaction` `t` on(`c`.`customer_id` = `t`.`customer_id`)) join `transaction_detail` `td` on(`t`.`transaction_id` = `td`.`transaction_id`)) join `product` `p` on(`td`.`product_id` = `p`.`product_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `product_stock_status`
--
DROP TABLE IF EXISTS `product_stock_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `product_stock_status`  AS SELECT `p`.`product_id` AS `product_id`, `p`.`product_name` AS `product_name`, `p`.`product_stock` AS `product_stock`, CASE WHEN `p`.`product_stock` = 0 THEN 'Out of Stock' WHEN `p`.`product_stock` <= 10 THEN 'Low Stock' ELSE 'In Stock' END AS `stock_status` FROM `product` AS `p` ;

-- --------------------------------------------------------

--
-- Structure for view `sales_report`
--
DROP TABLE IF EXISTS `sales_report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sales_report`  AS SELECT `p`.`product_id` AS `product_id`, `p`.`product_name` AS `product_name`, sum(`td`.`quantity`) AS `total_quantity_sold`, sum(`td`.`total_price`) AS `total_revenue` FROM (`product` `p` join `transaction_detail` `td` on(`p`.`product_id` = `td`.`product_id`)) GROUP BY `p`.`product_id`, `p`.`product_name` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `fk_customer_id` (`customer_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`cart_item_id`),
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`login_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `suplier`
--
ALTER TABLE `suplier`
  ADD PRIMARY KEY (`suplier_id`),
  ADD KEY `fk_product` (`product_id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `fk_admin_id` (`admin_id`);

--
-- Indexes for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD PRIMARY KEY (`transaction_detail_id`),
  ADD KEY `transaction_id` (`transaction_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `cart_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `login_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `suplier`
--
ALTER TABLE `suplier`
  MODIFY `suplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  MODIFY `transaction_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `fk_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`cart_id`),
  ADD CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

--
-- Constraints for table `login`
--
ALTER TABLE `login`
  ADD CONSTRAINT `login_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`);

--
-- Constraints for table `suplier`
--
ALTER TABLE `suplier`
  ADD CONSTRAINT `fk_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `fk_admin_id` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`),
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);

--
-- Constraints for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD CONSTRAINT `transaction_detail_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`transaction_id`),
  ADD CONSTRAINT `transaction_detail_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
