# 📊 Exploratory Data Analysis (EDA) – Data Warehouse Project 

## 📌 Purpose
This directory contains modular SQL scripts for Exploratory Data Analysis (EDA) on the **Gold Layer**  
of the Data Warehouse project. These queries uncover key business insights, highlight trends,  
and validate data quality before BI/reporting or dashboarding.

## ✅ The Analysis Includes:
1️⃣ **Database Exploration**: List all tables and columns to understand the database structure.

2️⃣ **Dimensions Exploration**: Explore customer countries, genders, and product categories.

3️⃣ **Date Exploration**: Analyze order date ranges and customer age distribution.

4️⃣ **Measures Exploration**: Calculate core business metrics like total sales, quantity sold, average price, and total orders.

5️⃣ **Magnitude Analysis**: Group sales and customer counts by location, category, and demographics.

6️⃣ **Ranking Analysis**: Use window functions to identify top and bottom products and customers.

## 🗃️ Tables Used
- `gold.dim_customers`
- `gold.dim_products`  
- `gold.fact_sales`  

## ⚠️ Warnings
- This script is designed for data analysis only — it does not modify any tables.  
- Results may vary if source data is updated or transformed.  
- For best use, execute queries section-by-section in SQL Server Management Studio (SSMS)

---
