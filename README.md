# online-retail-sales-analysis-sql
SQL analysis of online retail sales and customer data
# Online Retail Sales Analysis Using SQL

## 📌 Project Overview

This project analyzes online retail sales data using MySQL to understand
sales performance, customer behavior, product performance, and country-wise
revenue patterns.

The analysis focuses on extracting meaningful business insights using SQL
without using Power BI or Python.

---

## 🎯 Project Objectives

- Analyze overall sales and revenue performance
- Identify top-performing products
- Analyze customer purchasing behavior
- Identify high-value customers
- Compare sales performance across countries
- Analyze monthly revenue trends
- Measure repeat customer behavior
- Compare product sales volume with revenue
- Apply advanced SQL techniques for business analysis

---

## 🛠️ Tools Used

- MySQL
- MySQL Workbench
- SQL

---

## 📂 Dataset

The project uses the **Online Retail II** dataset.

The dataset contains information such as:

- Invoice
- Stock Code
- Product Description
- Quantity
- Invoice Date
- Price
- Customer ID
- Country

---

## 🧹 Data Cleaning

The following data-quality checks were performed:

- Checked for NULL values
- Checked for duplicate records
- Checked for negative quantities
- Identified zero-price records
- Removed test products
- Excluded non-product records from product-specific analysis where required

A separate cleaned table named `online_retail_clean` was created while
preserving the original dataset.

---

## 📊 Key Business Analysis

### 1. Overall Business KPIs

Calculated:

- Total Revenue
- Total Orders
- Total Quantity Sold
- Total Customers
- Average Order Value

### 2. Country Analysis

Analyzed:

- Country-wise revenue
- Revenue contribution
- Average order value by country
- Customer performance by country

### 3. Product Analysis

Analyzed:

- Top products by revenue
- Top products by quantity
- Product revenue vs quantity
- Top product by country

### 4. Customer Analysis

Analyzed:

- Top customers by revenue
- Customer order frequency
- Customer average order value
- Customer revenue contribution
- Repeat customers
- Customer value segmentation

### 5. Time Analysis

Analyzed:

- Monthly revenue
- Monthly revenue growth
- Monthly order volume

---

## 🧠 Advanced SQL Techniques

The project demonstrates practical use of:

- `GROUP BY`
- `HAVING`
- Aggregate Functions
- Subqueries
- CTEs
- `INNER JOIN`
- `RANK()`
- `DENSE_RANK()`
- `LAG()`
- `CASE WHEN`
- Date Functions
- `COUNT(DISTINCT)`
- Revenue and percentage calculations

---

## 🔍 Key Insights

- The United Kingdom generated the highest overall revenue.
- The White Hanging Heart T-Light Holder was one of the strongest
  revenue-generating products.
- High sales quantity does not always result in high revenue.
- A small group of high-value customers contributes a significant
  portion of total revenue.
- Denmark and the Netherlands showed higher average order values than
  the United Kingdom.
- Customer order frequency and customer revenue are not always directly
  related.
- Monthly revenue showed a declining trend across the available months.

---

## 💼 Business Recommendations

- Focus on retaining high-value customers.
- Develop strategies to increase the spending of medium-value customers.
- Identify opportunities to convert low-value customers into repeat buyers.
- Monitor high-volume products with relatively low revenue.
- Focus marketing efforts on countries with strong average order values.
- Investigate monthly sales patterns to identify opportunities for
  improving revenue consistency.

---

## 📁 Project Structure

```text
Online-Retail-SQL-Analysis/
│
├── README.md
│
├── SQL/
│   └── online_retail_analysis.sql
│
└── Dataset/
    └── online_retail_II.csv
