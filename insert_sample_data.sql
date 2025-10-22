
SET time_zone = '+00:00';

-- Users
INSERT INTO users (email, first_name, last_name, created_at, signup_channel)
VALUES
('alice@example.com','Alice','K','2024-10-01 08:00:00','web'),
('bob@example.com','Bob','M','2024-10-05 09:30:00','mobile'),
('carol@example.com','Carol','N','2024-10-08 14:20:00','referral');

-- Categories
INSERT INTO categories (name, slug) VALUES
('Electronics','electronics'),
('Home Appliances','home-appliances'),
('Books','books');

-- Products
INSERT INTO products (sku, name, description, price, currency)
VALUES
('SKU-001','Smartphone X','High-end smartphone',699.00,'USD'),
('SKU-002','Blender Pro','Kitchen blender',89.99,'USD'),
('SKU-003','Mystery Novel','Page-turner mystery',12.50,'USD');

-- Product-Categories
INSERT INTO product_categories (product_id, category_id)
VALUES (1,1),(2,2),(3,3);

-- Suppliers
INSERT INTO suppliers (name,contact_email) VALUES ('Acme Electronics','sup@acme.com'),('Kitchen Corp','sup@kitchen.com');

-- Inventory
INSERT INTO inventory (product_id, supplier_id, quantity, reserved)
VALUES (1,1,150,2),(2,2,80,0),(3,NULL,500,5);

-- Orders & Order items
INSERT INTO orders (user_id, order_number, status, total_amount, placed_at)
VALUES (1,'ORD-10001','completed',711.50,'2024-10-10 12:15:00'),
       (2,'ORD-10002','completed',89.99,'2024-10-11 15:00:00');

INSERT INTO order_items (order_id, product_id, sku, product_name, unit_price, quantity, total_price)
VALUES (1,1,'SKU-001','Smartphone X',699.00,1,699.00),
       (1,3,'SKU-003','Mystery Novel',12.50,1,12.50),
       (2,2,'SKU-002','Blender Pro',89.99,1,89.99);

-- Payments
INSERT INTO payments (order_id, amount, payment_method, status, processed_at)
VALUES (1,711.50,'card','paid','2024-10-10 12:16:00'),
       (2,89.99,'paypal','paid','2024-10-11 15:01:00');

-- Reviews
INSERT INTO reviews (product_id, user_id, rating, title, body, is_verified_purchase)
VALUES (1,1,5,'Love it!','The phone is excellent',1),
       (3,1,4,'Good read','Kept me up all night',1);

-- Sessions & events
INSERT INTO sessions (session_id, user_id, started_at, device, browser, ip, utm_source)
VALUES ('sess-a1',1,'2024-10-10 11:55:00','desktop','chrome','203.0.113.1','newsletter');

INSERT INTO page_views (session_id, user_id, path, title, occurred_at)
VALUES ('sess-a1',1,'/product/1','Smartphone X','2024-10-10 11:57:00');

INSERT INTO product_views (session_id, user_id, product_id, occurred_at)
VALUES ('sess-a1',1,1,'2024-10-10 11:57:05');

INSERT INTO events (session_id, user_id, event_type, occurred_at, payload)
VALUES ('sess-a1',1,'add_to_cart','2024-10-10 12:00:00', JSON_OBJECT('product_id',1,'qty',1));
