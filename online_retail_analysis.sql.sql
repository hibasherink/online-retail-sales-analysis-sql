create database online_rtail_db;

use online_rtail_db;

CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    CustomerID INT,
    Country VARCHAR(100)
);
SELECT *
FROM online_retail_ii
LIMIT 10;
-- STEP 1: DATA UNDERSTANDING
-- =========================================

SELECT COUNT(*) AS total_records
FROM online_retail_ii;
-- =========================================
-- STEP 2: DATA CLEANING
DESCRIBE online_retail_ii;
-- Check NULL values in Customer ID

SELECT
    COUNT(*) AS total_rows,
    SUM(`Customer ID` IS NULL) AS null_customer
FROM online_retail_ii;
-- =========================================
-- DATA CLEANING: NULL VALUE CHECK
-- =========================================

SELECT
    COUNT(*) AS total_rows,
    SUM(Quantity IS NULL) AS null_quantity,
    SUM(InvoiceDate IS NULL) AS null_invoice_date,
    SUM(Price IS NULL) AS null_price,
    SUM(`Customer ID` IS NULL) AS null_customer,
    SUM(Country IS NULL) AS null_country
FROM online_retail_ii;


-- STEP 6: DUPLICATE RECORD CHECK
-- =========================================

SELECT
   Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    `Customer ID`,
    Country,
    COUNT(*) AS duplicate_count
FROM online_retail_ii
GROUP BY
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    `Customer ID`,
    Country
HAVING COUNT(*) > 1;
-- =========================================
-- STEP 7: NEGATIVE QUANTITY CHECK
-- =========================================

SELECT
    COUNT(*) AS negative_quantity_records
FROM online_retail_ii
WHERE Quantity < 0;
describe online_retail_ii;
SHOW COLUMNS FROM online_retail_ii;
SHOW CREATE TABLE online_retail_ii;
ALTER TABLE online_retail_ii
CHANGE COLUMN `ï»¿Invoice` Invoice INT;
select * from online_retail_ii;
-- =========================================
-- STEP 7: NEGATIVE QUANTITY CHECK
-- =========================================

SELECT
    COUNT(*) AS negative_quantity_records
FROM online_retail_ii
WHERE Quantity < 0;
-- =========================================
-- STEP 8: PRICE VALIDATION
-- =========================================

SELECT
    COUNT(*) AS zero_price_records
FROM online_retail_ii
WHERE Price = 0;
SELECT
    COUNT(*) AS negative_price_records
FROM online_retail_ii
WHERE Price < 0;
-- =========================================
-- STEP 8.1: CHECK ZERO PRICE RECORDS
-- =========================================

SELECT *
FROM online_retail_ii
WHERE Price = 0;
-- =========================================
-- STEP 8.3: CREATE CLEAN DATASET
-- =========================================

CREATE TABLE online_retail_clean AS
SELECT *
FROM online_retail_ii
WHERE Price > 0;
SELECT COUNT(*) AS clean_records
FROM online_retail_clean;
SELECT COUNT(*) AS zero_price_records
FROM online_retail_clean
WHERE Price = 0;
-- =========================================
-- STEP 9: TEST RECORD CHECK
-- =========================================

SELECT
    COUNT(*) AS test_records
FROM online_retail_clean
WHERE StockCode LIKE 'TEST%';
SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    Price,
    `Customer ID`
FROM online_retail_clean
WHERE StockCode LIKE 'TEST%';
SELECT *
FROM online_retail_clean
WHERE StockCode LIKE 'TEST%';
SELECT COUNT(*) AS total_clean_records
FROM online_retail_clean;

-- =========================================
-- STEP 2: BASIC BUSINESS METRICS
-- =========================================

SELECT
    SUM(Quantity * Price) AS total_revenue,
    SUM(Quantity) AS total_quantity_sold,
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT `Customer ID`) AS total_customers
FROM online_retail_clean;
-- =========================================
-- STEP 3: COUNTRY-WISE REVENUE ANALYSIS
-- =========================================

SELECT
    Country,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue
FROM online_retail_clean
GROUP BY Country
ORDER BY total_revenue DESC;
-- =========================================
-- STEP 4: TOP 10 PRODUCTS BY REVENUE
-- =========================================

SELECT
    StockCode,
    Description,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue,
    SUM(Quantity) AS total_quantity_sold
FROM online_retail_clean
GROUP BY
    StockCode,
    Description
ORDER BY total_revenue DESC
LIMIT 10;
-- =========================================
-- STEP 5: TOP 10 ACTUAL PRODUCTS BY REVENUE
-- =========================================

SELECT
    StockCode,
    Description,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue,
    SUM(Quantity) AS total_quantity_sold
FROM online_retail_clean
WHERE StockCode <> 'M'
GROUP BY
    StockCode,
    Description
ORDER BY total_revenue DESC
LIMIT 10;
-- =========================================
-- STEP 6: TOP 10 CUSTOMERS BY REVENUE
-- =========================================

SELECT
    `Customer ID`,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue,
    SUM(Quantity) AS total_quantity_purchased,
    COUNT(*) AS total_transactions
FROM online_retail_clean
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`
ORDER BY total_revenue DESC
LIMIT 10;
-- =========================================
-- STEP 7: AVERAGE ORDER VALUE
-- =========================================

SELECT
    ROUND(SUM(Quantity * Price), 2) AS total_revenue,
    COUNT(*) AS total_transactions,
    ROUND(SUM(Quantity * Price) / COUNT(*), 2) AS average_order_value
FROM online_retail_clean;
-- =========================================
-- STEP 8: MONTHLY REVENUE ANALYSIS
-- =========================================

SELECT
    DATE_FORMAT(
        STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'),
        '%Y-%m'
    ) AS sales_month,
    ROUND(SUM(Quantity * Price), 2) AS monthly_revenue
FROM online_retail_clean
GROUP BY sales_month
ORDER BY sales_month;
-- =========================================
-- STEP 9: YEAR-MONTH SALES PERFORMANCE
-- =========================================

SELECT
    YEAR(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS sales_year,
    MONTH(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i')) AS sales_month,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue
FROM online_retail_clean
GROUP BY
    sales_year,
    sales_month
ORDER BY
    sales_year,
    sales_month;
    -- =========================================
-- STEP 10: REPEAT CUSTOMER ANALYSIS
-- =========================================

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        `Customer ID`,
        COUNT(*) AS transaction_count
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
    HAVING COUNT(*) > 1
) AS customer_transactions;
-- =========================================
-- STEP 11: REPEAT CUSTOMER PERCENTAGE
-- =========================================

SELECT
    COUNT(*) AS total_customers,
    SUM(transaction_count > 1) AS repeat_customers,
    ROUND(
        SUM(transaction_count > 1) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        `Customer ID`,
        COUNT(*) AS transaction_count
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
) AS customer_transactions;
-- =========================================
-- STEP 12: CUSTOMER REVENUE RANKING
-- CTE + WINDOW FUNCTION
-- =========================================

WITH customer_revenue AS (
    SELECT
        `Customer ID`,
        ROUND(SUM(Quantity * Price), 2) AS total_revenue
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
)

SELECT
    `Customer ID`,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_revenue
ORDER BY revenue_rank
LIMIT 10;
-- =========================================
-- STEP 13: PRODUCT REVENUE RANKING
-- CTE + DENSE_RANK()
-- =========================================

WITH product_revenue AS (
    SELECT
        StockCode,
        Description,
        ROUND(SUM(Quantity * Price), 2) AS total_revenue
    FROM online_retail_clean
    WHERE StockCode <> 'M'
    GROUP BY
        StockCode,
        Description
)

SELECT
    StockCode,
    Description,
    total_revenue,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank
LIMIT 10;
-- =========================================
-- STEP 14: CUSTOMER SPENDING ANALYSIS
-- =========================================

SELECT
    `Customer ID`,
    ROUND(SUM(Quantity * Price), 2) AS total_spending
FROM online_retail_clean
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`
HAVING SUM(Quantity * Price) >
(
    SELECT AVG(customer_revenue)
    FROM
    (
        SELECT
            `Customer ID`,
            SUM(Quantity * Price) AS customer_revenue
        FROM online_retail_clean
        WHERE `Customer ID` IS NOT NULL
        GROUP BY `Customer ID`
    ) AS customer_totals
)
ORDER BY total_spending DESC;
-- =========================================
-- STEP 15: CUSTOMER VALUE SEGMENTATION
-- =========================================

WITH customer_spending AS (
    SELECT
        `Customer ID`,
        SUM(Quantity * Price) AS total_spending
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
)

SELECT
    `Customer ID`,
    ROUND(total_spending, 2) AS total_spending,
    CASE
        WHEN total_spending >= 10000 THEN 'High Value'
        WHEN total_spending >= 3000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spending DESC;
-- =========================================
-- STEP 15B: CUSTOMER SEGMENT SUMMARY
-- =========================================

WITH customer_spending AS (
    SELECT
        `Customer ID`,
        SUM(Quantity * Price) AS total_spending
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
),

customer_segments AS (
    SELECT
        `Customer ID`,
        total_spending,
        CASE
            WHEN total_spending >= 10000 THEN 'High Value'
            WHEN total_spending >= 3000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_spending
)

SELECT
    customer_segment,
    COUNT(*) AS number_of_customers,
    ROUND(SUM(total_spending), 2) AS segment_revenue
FROM customer_segments
GROUP BY customer_segment
ORDER BY segment_revenue DESC;
-- =========================================
-- STEP 16: TOP 10 PRODUCTS BY QUANTITY SOLD
-- =========================================

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue
FROM online_retail_clean
WHERE StockCode <> 'M'
GROUP BY
    StockCode,
    Description
ORDER BY total_quantity_sold DESC
LIMIT 10;
-- =========================================
-- STEP 19: TOP CUSTOMERS BY NUMBER OF ORDERS
-- =========================================

SELECT
    `Customer ID`,
    COUNT(DISTINCT Invoice) AS total_orders,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue
FROM online_retail_clean
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`
ORDER BY total_orders DESC
LIMIT 10;
-- =========================================
-- STEP 20: AVERAGE ORDER VALUE BY COUNTRY
-- =========================================

SELECT
    Country,
    COUNT(DISTINCT Invoice) AS total_orders,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue,
    ROUND(
        SUM(Quantity * Price) / COUNT(DISTINCT Invoice),
        2
    ) AS average_order_value
FROM online_retail_clean
GROUP BY Country
ORDER BY average_order_value DESC;
-- =========================================
-- STEP 29: FINAL BUSINESS KPIs
-- =========================================

SELECT
    ROUND(SUM(Quantity * Price), 2) AS total_revenue,
    COUNT(DISTINCT Invoice) AS total_orders,
    SUM(Quantity) AS total_quantity_sold,
    COUNT(DISTINCT `Customer ID`) AS total_customers,
    ROUND(
        SUM(Quantity * Price) / COUNT(DISTINCT Invoice),
        2
    ) AS average_order_value
FROM online_retail_clean
WHERE `Customer ID` IS NOT NULL;
-- =========================================
-- STEP 30: FINAL REPEAT CUSTOMER ANALYSIS
-- =========================================

WITH customer_orders AS (
    SELECT
        `Customer ID`,
        COUNT(DISTINCT Invoice) AS total_orders
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
)
-- =========================================
-- STEP 28: COUNTRY CUSTOMER PERFORMANCE
-- =========================================

SELECT
    o.Country,
    COUNT(DISTINCT c.`Customer ID`) AS total_customers,
    ROUND(SUM(DISTINCT c.total_revenue), 2) AS total_revenue
FROM (
    SELECT DISTINCT
        `Customer ID`,
        Country
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
) AS o
INNER JOIN customer_summary AS c
    ON o.`Customer ID` = c.`Customer ID`
GROUP BY o.Country
ORDER BY total_revenue DESC;-- =========================================
-- STEP 26: CREATE CUSTOMER SUMMARY
-- =========================================

CREATE TABLE customer_summary AS
SELECT
    `Customer ID`,
    COUNT(DISTINCT Invoice) AS total_orders,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Quantity * Price), 2) AS total_revenue
FROM online_retail_clean
WHERE `Customer ID` IS NOT NULL
GROUP BY `Customer ID`;
-- =========================================
-- STEP 28: COUNTRY CUSTOMER PERFORMANCE
-- =========================================

SELECT
    o.Country,
    COUNT(DISTINCT c.`Customer ID`) AS total_customers,
    ROUND(SUM(c.total_revenue), 2) AS total_revenue
FROM (
    SELECT DISTINCT
        `Customer ID`,
        Country
    FROM online_retail_clean
    WHERE `Customer ID` IS NOT NULL
) AS o
INNER JOIN customer_summary AS c
    ON o.`Customer ID` = c.`Customer ID`
GROUP BY o.Country
ORDER BY total_revenue DESC;
SELECT
    COUNT(*) AS total_customers,
    SUM(total_orders > 1) AS repeat_customers,
    SUM(total_orders = 1) AS one_time_customers,
    ROUND(
        SUM(total_orders > 1) * 100.0 / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM customer_orders;
