-- View for monthly revenue

CREATE VIEW monthly_revenue AS
SELECT
    FORMAT(o.order_date, 'yyyy-MM') AS month,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY FORMAT(o.order_date, 'yyyy-MM');
