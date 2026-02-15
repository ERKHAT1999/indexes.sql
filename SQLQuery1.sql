CREATE DATABASE Ecommerce;
GO

USE Ecommerce;
GO
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    created_at DATE NOT NULL
);
CREATE TABLE categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);
CREATE TABLE products (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);
CREATE TABLE orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE order_items (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
INSERT INTO users (name, email, created_at) VALUES
('Ali', 'ali@mail.com', '2024-01-01'),
('Daniyar', 'dan@mail.com', '2024-01-05'),
('Aruzhan', 'aru@mail.com', '2024-02-01'),
('Timur', 'tim@mail.com', '2024-02-10');
INSERT INTO categories (name) VALUES
('Electronics'),
('Clothes'),
('Books');
INSERT INTO products (name, price, category_id) VALUES
('Phone', 300000, 1),
('Laptop', 700000, 1),
('T-shirt', 15000, 2),
('SQL Book', 12000, 3);
INSERT INTO orders (user_id, order_date) VALUES
(1, '2024-02-01'),
(1, '2024-03-01'),
(2, '2024-03-05'),
(3, '2024-03-10');
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 4, 2),
(2, 2, 1),
(3, 3, 3),
(4, 4, 1);
SELECT
    p.name,
    SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.name
ORDER BY total_sold DESC;
SELECT
    FORMAT(o.order_date, 'yyyy-MM') AS month,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
ORDER BY month;
SELECT
    AVG(order_total) AS avg_order_value
FROM (
    SELECT
        o.id,
        SUM(oi.quantity * p.price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
    GROUP BY o.id
) t;
SELECT u.name
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL;
SELECT
    user_id,
    COUNT(*) AS orders_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1;




