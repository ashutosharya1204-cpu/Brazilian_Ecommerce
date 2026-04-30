# Brazilian_Ecommerce

@-> Olist E-Commerce — End-to-End SQL Data Analysis

>>= A complete MySQL analysis pipeline on 100,000+ real Brazilian e-commerce orders — covering schema design, data import, 
    cleaning, and business intelligence queries.

-> Problem Statement

Olist is a Brazilian marketplace connecting small businesses to major e-commerce platforms. The business needs clear answers to:

- Which product categories generate the most revenue?
- Why are customers leaving negative reviews — is it delivery speed?
- Who are the highest-performing sellers, and how are they distributed?
- Are customers returning to buy again, or is Olist a one-time platform?
- Which states suffer from the worst delivery delays, and why does it matter?

This project answers all of the above using pure MySQL — no BI tool required at the analysis stage.

@ Dataset

->Source: [Olist Brazilian E-Commerce Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

- Table | Description | ~Rows |

- `customers` = Customer ID, city, state, ZIP = 99,441 
- `orders` = Order lifecycle with timestamps = 99,441 
- `order_items` = Products per order, prices, freight = 112,650 
- `products` = Product dimensions, category, photos = 32,951 
- `sellers` = Seller city, state, ZIP = 3,095 
- `payments` = Payment type, value, installments = 103,886 
- `reviews` = Customer scores and comments = 99,224 
- `geolocation` = ZIP-to-lat/lng mapping (deduplicated) =19,015 
- `category_translation` = Portuguese → English category names = 71 

Time range: September 2016 – August 2018 (24 months)

@ Tools & Technologies

- Tool | Purpose |
- MySQL 8.0 | All SQL: schema, import, cleaning, analysis |
- MySQL Workbench | Query execution, ERD export |
- Git & GitHub | Version control and project sharing |
- Kaggle | Dataset source |


-> Repository Structure


olist-ecommerce-sql-analysis/
│
├── sql/
│   ├── 01_Table_creation.sql      ← Schema design, 9 tables
│   ├── 02_Data_Load.sql           ← CSV import, type casting, PKs/FKs
│   ├── 03_Data_cleaning.sql       ← NULL audits, bad record removal
│   └── 04_Analysis_part.sql       ← Business analysis + Advanced SQL objects
│
├── data/
│   └── README_data.md             ← Kaggle download instructions 
│
├── screenshots/
│   ├── ERD_schema.png
│   ├── revenue_by_category.png
│   ├── monthly_trend.png
│   ├── review_vs_delivery.png
│   └── customer_segments.png
│
├── .gitignore
└── README.md



-> Steps Performed

@ 1 — Database & Table Creation (\`01_Table_creation.sql\`)
- Created the \`olist1\` database with 9 tables
- Used TEXT columns intentionally for raw import flexibility
- Planned raw-to-clean table strategy (reviews_raw → reviews, geolocation_raw → geolocation)

@ 2 — Data Import & Modelling (\`02_Data_Load.sql\`)
- Loaded all 9 CSVs using \`LOAD DATA LOCAL INFILE\`
- Converted TEXT columns to proper types: DATETIME, INT, VARCHAR using ALTER TABLE
- Used \`NULLIF()\` to convert empty strings to true NULLs
- Created deduplicated child tables: \`reviews\` and \`geolocation\` (averaged coordinates by ZIP)
- Applied Primary Keys and Foreign Key constraints for proper relational modelling
- Final UNION ALL count check across all 9 tables

@ 3 — Data Cleaning (\`03_Data_cleaning.sql\`)
- Audited every column for NULLs using \`SUM(CASE WHEN ... IS NULL THEN 1 ELSE 0 END)\`
- Fixed product NULLs: category → \`'unknown'\`, numeric fields → \`0\`
- Removed 3 invalid payment records (\`payment_type = 'not_defined'\`)
- Cleaned seller state with \`TRIM()\` + \`REPLACE()\` for hidden \\r\\n characters

@ 4 — Analysis & Advanced SQL (\`04_Analysis_part.sql\`)
- Exploratory validation, duplicate checks, date range and price distribution
- Revenue by category, monthly trends, Month-over-Month growth using \`LAG()\`
- Delivery performance by state using \`DATEDIFF()\` and CTEs
- Customer segmentation: one-time vs returning vs loyal
- Seller ranking using \`RANK()\` and \`NTILE(4)\`
- Review score vs delivery time correlation — the core business insight
- Advanced objects: Views, Stored Procedures, UDFs, Triggers, Indexes



@ Key Business Insights

 #  Insight (Business Impact )

 1. 96% of customers buy only once** | Retention strategy is the top priority |
 2. Delivery time drives review scores** | 1-star orders average 20+ days; 5-star average 10 days |
 3. health_beauty, watches_gifts lead revenue** | Top 3 categories drive ~30% of total revenue |
 4. Northern states have highest late-delivery rates** | Logistics investment needed in AM, RR, AP |
 5. November 2017 (Black Friday) = peak month** | 40%+ MoM growth — strong seasonal signal |
 6. Credit card + installments dominate payments** | Installment-friendly pricing can reduce abandonment |

---

@SQL Concepts Demonstrated

`JOINs` · `CTEs` · `Window Functions (RANK, LAG, NTILE, SUM OVER)` · `Subqueries` · `Stored Procedures` ·
`User Defined Functions` · `Triggers` · `Views` · `Indexes` · `Date Functions` · `CASE WHEN` · `NULLIF`
· `COALESCE` · `LOAD DATA LOCAL INFILE`

---

@ How to Run

1. Install MySQL 8.0+ and MySQL Workbench
2. Download dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
3. Update file paths in \`02_Data_Load.sql\` to match your local CSV folder
4. Run files in order: 01 → 02 → 03 → 04

---

@Future Improvements

-  Power BI / Tableau dashboard connecting to these query outputs
-  RFM segmentation (Recency, Frequency, Monetary) for customer targeting
-  Cohort retention analysis by customer acquisition month
-  Freight cost vs distance analysis using geolocation data
-  Seller health score combining revenue, reviews and delivery metrics

