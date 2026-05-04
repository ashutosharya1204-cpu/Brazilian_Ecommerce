# Olist E-Commerce Data Analysis (SQL Project)

## Overview

This project analyzes a real-world Brazilian e-commerce dataset using SQL to uncover actionable business insights.

It simulates the workflow of a data analyst in an e-commerce company — from raw data ingestion to business reporting.

---

## Problem Statement

E-commerce businesses often face challenges such as:

* Low customer retention
* Delivery inefficiencies
* Uneven seller performance

This project answers:

* Why are customers not returning?
* What drives customer satisfaction?
* Which sellers generate the most revenue?

---

## Tech Stack

* SQL (MySQL)
* Data Cleaning and Transformation
* Analytical SQL (CTEs, Window Functions)
* Database Design (Keys, Relationships, Indexing)

---

## Project Structure

```id="y4x95t"
olist-ecommerce-sql-analysis/
│
├── sql/
│   ├── 01_schema.sql          → Raw table structures
│   ├── 02_data_loading.sql    → Data ingestion
│   ├── 03_data_cleaning.sql   → Data transformation
│   ├── 04_analysis.sql        → Business insights
│
├── insights/
│   └── business_insights.md
│
├── README.md
```

---

## Workflow

### 1. Data Ingestion

* Loaded raw CSV files into MySQL
* Maintained raw structure for flexibility

### 2. Data Cleaning

* Handled missing values using `NULLIF()`
* Preserved meaningful NULLs (e.g., undelivered orders)
* Fixed data types and inconsistencies
* Ensured referential integrity

### 3. Data Transformation

* Created structured tables from raw data
* Aggregated geolocation data
* Cleaned and standardized product and seller data

### 4. Data Analysis

* Customer segmentation
* Seller performance ranking
* Delivery impact analysis
* Revenue trend analysis

---

## Key Insights

### Customer Retention

* Only ~3% repeat customers
  Indicates a strong retention problem

---

### Customer Lifetime Value

* Loyal customers spend approximately 4x more
  Retention is more valuable than acquisition

---

### Delivery Impact

* Faster delivery leads to higher ratings
  Delivery speed is critical for satisfaction

---

### Seller Contribution

* Revenue is concentrated among top sellers
  Seller performance varies significantly

---

## Advanced SQL Concepts Used

* Common Table Expressions (CTEs)
* Window Functions (RANK, NTILE, LAG)
* Joins and Aggregations
* Data Cleaning Techniques
* Primary and Foreign Keys

---

## Business Impact

This project demonstrates how SQL can be used to:

* Identify revenue drivers
* Improve customer retention strategies
* Optimize logistics and delivery
* Support data-driven decision-making

---

## Future Improvements

* Build interactive dashboards using Power BI or Tableau
* Add predictive models (churn, delivery delay)
* Automate pipeline using ETL tools

---

## Author

Meraj Sheikh
Data Science and Analytics Enthusiast
Skilled in SQL, Python, Power BI, and Machine Learning
