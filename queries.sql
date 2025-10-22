-- 1) Top 10 best selling products by quantity
SELECT p.product_id, p.name, SUM(oi.quantity) AS qty_sold, SUM(oi.total_price) AS revenue
FROM order_items oi
JOIN products p USING(product_id)
GROUP BY p.product_id, p.name
ORDER BY qty_sold DESC
LIMIT 10;

-- 2) Daily revenue (last 30 days)
SELECT DATE(placed_at) AS day, COUNT(*) AS orders, SUM(total_amount) AS revenue
FROM orders
WHERE placed_at >= CURDATE() - INTERVAL 30 DAY
GROUP BY day
ORDER BY day;

-- 3) Conversion funnel: visitors -> add_to_cart -> checkout -> purchase (basic)
-- Visitors: unique sessions in period
WITH visitors AS (
  SELECT COUNT(DISTINCT session_id) visitors
  FROM sessions
  WHERE started_at >= '2024-10-01'
), added AS (
  SELECT COUNT(DISTINCT session_id) add_to_cart
  FROM events
  WHERE event_type = 'add_to_cart' AND occurred_at >= '2024-10-01'
), checkout AS (
  SELECT COUNT(DISTINCT session_id) checkout_start
  FROM events
  WHERE event_type = 'checkout_start' AND occurred_at >= '2024-10-01'
), purchases AS (
  SELECT COUNT(DISTINCT order_id) purchases
  FROM orders
  WHERE placed_at >= '2024-10-01'
)
SELECT v.visitors, a.add_to_cart, c.checkout_start, p.purchases
FROM visitors v CROSS JOIN added a CROSS JOIN checkout c CROSS JOIN purchases p;

-- 4) Cohort retention (week of signup -> retention by week)
-- Note: simple version using signup week & orders
SELECT
  signup_week,
  purchase_week,
  COUNT(DISTINCT user_id) users
FROM (
  SELECT u.user_id,
    YEARWEEK(u.created_at,1) AS signup_week,
    YEARWEEK(o.placed_at,1) AS purchase_week
  FROM users u
  LEFT JOIN orders o ON o.user_id = u.user_id
  WHERE u.created_at >= '2024-01-01'
) t
GROUP BY signup_week, purchase_week
ORDER BY signup_week, purchase_week;

-- 5) LTV (simplified): revenue per cohort at 30 days
SELECT YEAR(u.created_at) AS yr, MONTH(u.created_at) AS mon,
       COUNT(DISTINCT u.user_id) AS users,
       SUM(o.total_amount) AS revenue,
       SUM(o.total_amount)/COUNT(DISTINCT u.user_id) AS avg_ltv
FROM users u
LEFT JOIN orders o ON o.user_id = u.user_id AND o.placed_at <= u.created_at + INTERVAL 30 DAY
WHERE u.created_at BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY yr, mon
ORDER BY yr, mon;

-- 6) Repeat purchase rate (last 90 days)
SELECT
  COUNT(DISTINCT user_id) AS buyers,
  SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END) AS repeat_buyers,
  SUM(CASE WHEN orders_count > 1 THEN 1 ELSE 0 END)/COUNT(DISTINCT user_id) AS repeat_rate
FROM (
  SELECT user_id, COUNT(*) AS orders_count
  FROM orders
  WHERE placed_at >= CURDATE() - INTERVAL 90 DAY
  GROUP BY user_id
) t;

-- 7) RFM segmentation (last 365 days)
SELECT
  user_id,
  DATEDIFF(CURDATE(), MAX(placed_at)) AS recency_days,
  COUNT(*) AS frequency,
  SUM(total_amount) AS monetary
FROM orders
WHERE placed_at >= CURDATE() - INTERVAL 365 DAY
GROUP BY user_id
ORDER BY monetary DESC
LIMIT 100;

-- 8) Most viewed products with conversion (views -> purchases)
SELECT
  p.product_id, p.name,
  COALESCE(pv.views,0) AS views,
  COALESCE(sales.qty_sold,0) AS qty_sold,
  CASE WHEN COALESCE(pv.views,0)=0 THEN 0 ELSE ROUND(sales.qty_sold/pv.views,4) END AS conversion_per_view
FROM products p
LEFT JOIN (
  SELECT product_id, COUNT(*) AS views
  FROM product_views
  WHERE occurred_at >= CURDATE() - INTERVAL 30 DAY
  GROUP BY product_id
) pv ON pv.product_id = p.product_id
LEFT JOIN (
  SELECT product_id, SUM(quantity) AS qty_sold
  FROM order_items oi
  JOIN orders o ON o.order_id = oi.order_id
  WHERE o.placed_at >= CURDATE() - INTERVAL 30 DAY
  GROUP BY product_id
) sales ON sales.product_id = p.product_id
ORDER BY conversion_per_view DESC
LIMIT 50;
