-- Here we have to create  database and use it after that we have to create multiple tables to do some analysis

-- Creating Database 

CREATE DATABASE olist1;

USE olist1;

SET GLOBAL local_infile = 1;

-- 1. CUSTOMERS table
CREATE TABLE customers (
customer_id VARCHAR(50) PRIMARY KEY,
customer_unique_id VARCHAR(50),
customer_zip_code_prefix VARCHAR(10),
customer_city VARCHAR(100),
customer_state VARCHAR(5)
);


-- 2. ORDERS table

CREATE TABLE orders (
order_id VARCHAR(50),
customer_id VARCHAR(50),
order_status VARCHAR(50),
order_purchase_timestamp TEXT,
order_approved_at TEXT,
order_delivered_carrier_date TEXT,
order_delivered_customer_date TEXT,
order_estimated_delivery_date TEXT
);


-- 3. PRODUCTS table

CREATE TABLE products (
product_id VARCHAR(50),
product_category_name TEXT,
product_name_lenght TEXT,
product_description_lenght TEXT,
product_photos_qty TEXT,
product_weight_g TEXT,
product_length_cm TEXT,
product_height_cm TEXT,
product_width_cm TEXT
);

-- 4. ORDER ITEMS table

CREATE TABLE order_items (
order_id VARCHAR(50),
order_item_id INT,
product_id VARCHAR(50),
seller_id VARCHAR(50),
shipping_limit_date TEXT,
price DOUBLE,
freight_value DOUBLE
);

-- 5. SELLERS

CREATE TABLE sellers (
seller_id VARCHAR(50),
seller_zip_code_prefix VARCHAR(10),
seller_city VARCHAR(100),
seller_state varchar(10)
);


-- 6. PAYMENTS table

CREATE TABLE payments (
order_id VARCHAR(50),
payment_sequential INT,
payment_type VARCHAR(50),
payment_installments INT,
payment_value DOUBLE
);


-- 7. REVIEWS (RAW → CLEAN) table

CREATE TABLE reviews_raw (
review_id VARCHAR(50),
order_id VARCHAR(50),
review_score INT,
review_comment_title TEXT,
review_comment_message TEXT,
review_creation_date TEXT,
review_answer_timestamp TEXT
);



-- 8. GEOLOCATION table

CREATE TABLE geolocation_raw (
geolocation_zip_code_prefix TEXT,
geolocation_lat TEXT,
geolocation_lng TEXT,
geolocation_city TEXT,
geolocation_state TEXT
);



-- 9. CATEGORY TRANSLATION table

CREATE TABLE category_translation (
product_category_name VARCHAR(100),
product_category_name_english VARCHAR(100)
);




