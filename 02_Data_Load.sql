-- in this file we insert/Import the multiple table using load data function in the table which we have alreeady creaed earlier

-- importing the customers table

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- importing orders table

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- identifying null values from orders table
UPDATE orders
SET
order_approved_at = NULLIF(order_approved_at, ''),
order_delivered_carrier_date = NULLIF(order_delivered_carrier_date, ''),
order_delivered_customer_date = NULLIF(order_delivered_customer_date, '');

-- changing data_type of orders table
ALTER TABLE orders
MODIFY order_id VARCHAR(50) PRIMARY KEY,
MODIFY customer_id VARCHAR(50),
MODIFY order_status VARCHAR(50),
MODIFY order_purchase_timestamp DATETIME,
MODIFY order_approved_at DATETIME,
MODIFY order_delivered_carrier_date DATETIME,
MODIFY order_delivered_customer_date DATETIME,
MODIFY order_estimated_delivery_date DATETIME;


-- importing products table

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- identifying the null values of the products table

UPDATE products
SET
product_category_name = NULLIF(product_category_name, ''),
product_name_lenght = NULLIF(product_name_lenght, ''),
product_description_lenght = NULLIF(product_description_lenght, ''),
product_photos_qty = NULLIF(product_photos_qty, ''),
product_weight_g = NULLIF(product_weight_g, ''),
product_length_cm = NULLIF(product_length_cm, ''),
product_height_cm = NULLIF(product_height_cm, ''),
product_width_cm = NULLIF(product_width_cm, '');

-- changing data_type of products table
ALTER TABLE products
MODIFY product_id VARCHAR(50) PRIMARY KEY,
MODIFY product_category_name VARCHAR(100),
MODIFY product_name_lenght INT,
MODIFY product_description_lenght INT,
MODIFY product_photos_qty INT,
MODIFY product_weight_g INT,
MODIFY product_length_cm INT,
MODIFY product_height_cm INT,
MODIFY product_width_cm INT;

-- importing order_items table

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- changing the data type of shipping_limit_date column
ALTER TABLE order_items
MODIFY shipping_limit_date DATETIME;

ALTER TABLE order_items
ADD PRIMARY KEY (order_id, order_item_id);

-- importing sellers table 

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- updating sellers table state column using trim function and its type
UPDATE sellers
SET seller_state = TRIM(REPLACE(REPLACE(seller_state, '\r', ''), '\n', ''));

DELETE FROM sellers
WHERE LENGTH(seller_state) != 2;

drop table sellers;

ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

-- importing payments table

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_order_payments_dataset.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- updating data format for better undestanding of data

UPDATE payments
SET order_id = REPLACE(order_id, '"', '');

-- inserting primary key in table
ALTER TABLE payments
ADD PRIMARY KEY (order_id, payment_sequential);

-- importing reviews_raw table 

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_order_reviews_dataset.csv'
INTO TABLE reviews_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- creating child table ofreview_raw as reviews for better analysis

CREATE TABLE reviews AS
SELECT
review_id,
order_id,
review_score,
review_comment_title,
review_comment_message,
NULLIF(review_creation_date, '0000-00-00 00:00:00') AS review_creation_date,
NULLIF(review_answer_timestamp, '0000-00-00 00:00:00') AS review_answer_timestamp
FROM reviews_raw;

-- changing datea nd time format of few columns

select*from reviews_raw;                      
ALTER TABLE reviews
MODIFY review_creation_date DATETIME,
MODIFY review_answer_timestamp DATETIME;

-- inserting primary key in a reviews table

ALTER TABLE reviews
ADD PRIMARY KEY (review_id, order_id);

-- importing geolocation raw table

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/olist_geolocation_dataset.csv'
INTO TABLE geolocation_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- creating child table geolocation for better analysis of geolocation_raw table

CREATE TABLE geolocation AS
SELECT
geolocation_zip_code_prefix AS zip_code_prefix,
AVG(CAST(geolocation_lat AS DECIMAL(10,6))) AS lat,
AVG(CAST(geolocation_lng AS DECIMAL(10,6))) AS lng,
MIN(geolocation_city) AS city,
MIN(geolocation_state) AS state
FROM geolocation_raw
GROUP BY geolocation_zip_code_prefix;

ALTER TABLE geolocation
MODIFY zip_code_prefix VARCHAR(10);

ALTER TABLE geolocation
ADD PRIMARY KEY (zip_code_prefix);
desc geolocation;

-- importing category_location table

LOAD DATA LOCAL INFILE 'C:/Users/91895/Desktop/archive/product_category_name_translation.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Applying primary/ foreign key to tables for modeling the data/tables

ALTER TABLE category_translation
ADD PRIMARY KEY (product_category_name);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_items_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_items_products
FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_items_sellers
FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id) REFERENCES orders(order_id);


-- FINAL CHECK for each and every table for undersatnding the data , that the tables/data imporyed correctly or not

SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'category_translation', COUNT(*) FROM category_translation;
