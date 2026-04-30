use olist1;

--  DONE

-- here i do some practice of the olist_ecommerce dataset PDF to ensure and better understanding of the data that has been provided

SELECT customer_id, COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*) >1;

-- counting the customerid and distinct customer id and finding ho many customers repeated their order
SELECT 
    COUNT(customer_id) AS total_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    COUNT(customer_id) - COUNT(DISTINCT customer_unique_id) AS repeat_order_count
FROM customers;

-- checking for null values in orders table using sum aggregation and some cases.
SELECT 
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)     AS null_order_id,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)   AS null_customer_id,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END)   AS null_status,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END)  AS null_purchase,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END)    AS null_approved,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_carrier,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivered, 
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_estimated
FROM orders;

-- checking for the null values by adding total orders and their comparison how much null value delivered by its overall stats
SELECT  order_status,     COUNT(*) AS total_orders,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivered,
    ROUND(SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 1) AS null_pct
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- vrifying date range of orders table to understand its data type
SELECT 
    MIN(order_purchase_timestamp) AS earliest,
    MAX(order_purchase_timestamp) AS latest,
    TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp), 
        MAX(order_purchase_timestamp)) AS months_span
FROM orders;

-- validating price range of orders data
SELECT 
    COUNT(*) AS total_rows,
    MIN(price) AS min_price, MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price,
    MIN(freight_value) AS min_freight, MAX(freight_value) AS max_freight,
    ROUND(AVG(freight_value), 2) AS avg_freight,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS null_freight
FROM order_items;

-- finding Null/missing values in products table for each and every column of an product table 



-- PAYMENTS Table — Identify and Remove Bad Records
SELECT payment_type, 
    COUNT(*) AS cnt, 
    ROUND(SUM(payment_value), 2) AS total_value,
    ROUND(AVG(payment_value), 2) AS avg_value
FROM payments
GROUP BY payment_type
ORDER BY total_value DESC;

-- Removing the 3 bad records
DELETE FROM payments WHERE payment_type = 'not_defined'; 

-- Verify
SELECT COUNT(*) FROM payments WHERE payment_type = 'not_defined';

-- REVIEWS — Analyze Score Distribution
SELECT     review_score,
    COUNT(*) AS cnt,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reviews), 1) AS pct
FROM reviews
GROUP BY review_score
ORDER BY review_score;

-- here the analysis has begin in sql , the data cleaning part has been completed and now we begin the analysis part

-- Total Revenue (Basic Aggregation)
SELECT 
    ROUND(SUM(payment_value), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM payments;

-- Revenue by Category (JOIN + Aggregation)

SELECT 
    COALESCE(ct.product_category_name_english, 'unknown') AS category,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct 
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY revenue DESC LIMIT 10;

-- Monthly Revenue Trend (Date Functions)
SELECT     DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(p.payment_value), 2) AS revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp < '2018-09-01'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;

-- Delivery by State (CTE — Common Table Expression)

WITH delivery_calc AS (   
SELECT o.order_id, c.customer_state,         
        DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS actual_days, 
        CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END AS is_late 
        FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
)
SELECT customer_state, COUNT(*) AS delivered,
    ROUND(AVG(actual_days), 1) AS avg_days,
    ROUND(SUM(is_late)*100.0/COUNT(*), 1) AS late_pct
FROM delivery_calc
GROUP BY customer_state ORDER BY late_pct DESC LIMIT 10;

-- Customer Lifetime (Subquery + Window Function)

WITH customer_orders AS (
    SELECT c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        ROUND(SUM(p.payment_value), 2) AS total_spend,
        ROUND(AVG(r.review_score), 2) AS avg_review
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN payments p ON o.order_id = p.order_id
    LEFT JOIN reviews r ON o.order_id = r.order_id
    GROUP BY c.customer_unique_id
)
SELECT 
    CASE WHEN order_count = 1 THEN 'One-time'
         WHEN order_count = 2 THEN 'Returned once'
         ELSE 'Loyal (3+)' END AS segment,
    COUNT(*) AS customers,
    ROUND(AVG(total_spend), 2) AS avg_spend
FROM customer_orders GROUP BY segment ORDER BY customers DESC;

-- Seller Ranking (Window Functions — RANK, NTILE)

WITH seller_metrics AS (
    SELECT s.seller_id, s.seller_state,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS total_revenue,
        ROUND(AVG(r.review_score), 2) AS avg_review
    FROM sellers s
    JOIN order_items oi ON s.seller_id = oi.seller_id
    JOIN orders o ON oi.order_id = o.order_id
    LEFT JOIN reviews r ON o.order_id = r.order_id
    GROUP BY s.seller_id, s.seller_state
)
SELECT seller_id, seller_state, total_orders, total_revenue, avg_review,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    NTILE(4) OVER (ORDER BY total_revenue DESC) AS quartile
FROM seller_metrics ORDER BY total_revenue DESC LIMIT 10;

-- Review Score vs Delivery Time (The Key Insight)

WITH order_delivery_review AS (
    SELECT o.order_id, r.review_score,         DATEDIFF(o.order_delivered_customer_date, 
                 o.order_purchase_timestamp) AS delivery_days     FROM orders o
    JOIN reviews r ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)
SELECT review_score, COUNT(*) AS cnt,
    ROUND(AVG(delivery_days), 1) AS avg_delivery_days,
    ROUND(SUM(CASE WHEN delivery_days >         (SELECT AVG(DATEDIFF(order_estimated_delivery_date,          order_purchase_timestamp)) FROM orders) 
        THEN 1 ELSE 0 END)*100.0/COUNT(*), 1) AS pct_late
FROM order_delivery_review
GROUP BY review_score ORDER BY review_score;

-- Month-over-Month Growth (LAG Window Function)

WITH monthly AS (
    SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        ROUND(SUM(p.payment_value), 2) AS revenue
    FROM orders o JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT month, revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 
        / LAG(revenue) OVER (ORDER BY month), 1) AS growth_pct
FROM monthly ORDER BY month;


-- Running Total and Moving Average

SUM (revenue) OVER (ORDER BY month 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue,
AVG(revenue) OVER (ORDER BY month 
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS three_month_avg;






