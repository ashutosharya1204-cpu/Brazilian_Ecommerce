use olist1;
-- data cleaning part of the project

-- cleaning null values from the customers table
SELECT 
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_unique_id,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS null_state
FROM customers;

SELECT 
    COUNT(customer_id) AS total_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- cleaning null values from orders tasble
SELECT 
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_approved,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_carrier,     SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivered
FROM orders;

-- understanding the null_values
SELECT order_status, COUNT(*) AS total,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_delivered
FROM orders GROUP BY order_status ORDER BY total DESC;

-- table products cleaning

SELECT 
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category
FROM products;

select* from products;
SELECT 
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS null_length,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS null_description,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS null_photos_qty,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END)      AS null_weight
FROM products;

-- Fixing null values from the products table which was an good for analysing/cleaning the garbage data
-- Step 1: See what the NULL products look like 
SELECT product_id, product_category_name, product_weight_g
FROM products 
WHERE product_category_name IS NULL
LIMIT 5;

-- Step 2: Replace NULL with 'unknown'
UPDATE products 
SET product_category_name = 'unknown'
WHERE product_category_name IS NULL;

UPDATE products 
SET product_name_lenght = 0
WHERE product_name_lenght IS NULL;

UPDATE products 
SET product_description_lenght = 0
WHERE product_description_lenght IS NULL;

UPDATE products 
SET product_photos_qty = 0
WHERE product_photos_qty IS NULL;

UPDATE products 
SET product_weight_g = 0
WHERE product_weight_g IS NULL;

UPDATE products 
SET product_length_cm = 0
WHERE product_length_cm IS NULL;

select* from products;
-- Step 3: Verify the fix
SELECT COUNT(*) AS remaining_nulls 
FROM products 
WHERE product_category_name IS NULL; 

-- removing null from payments table

SELECT payment_type, COUNT(*) AS cnt, SUM(payment_value) AS total
FROM payments GROUP BY payment_type ORDER BY total DESC;

DELETE FROM payments WHERE payment_type = 'not_defined';





