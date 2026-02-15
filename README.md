# indexes.sql
Проект моделирует базу данных интернет-магазина и анализирует продажи.
-- Indexes for performance optimization

CREATE INDEX idx_orders_user_id
ON orders(user_id);

CREATE INDEX idx_order_items_product_id
ON order_items(product_id);

CREATE INDEX idx_products_category_id
ON products(category_id);

CREATE INDEX idx_events_user_id
ON events(user_id);
