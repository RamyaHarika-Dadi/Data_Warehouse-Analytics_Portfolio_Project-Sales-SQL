# 📊 Exploratory Data Analysis (EDA) – SQL Data Warehouse Project

## 📌 Purpose
This directory contains modular SQL scripts for Exploratory Data Analysis (EDA) on the **Gold Layer**  
of the Data Warehouse project. These queries uncover key business insights, highlight trends,  
and validate data quality before BI/reporting or dashboarding.

## ✅ The analysis includes:
1. **Database Exploration** – Discover tables, columns, and schema structure  
2. **Dimensions Exploration** – Understand customers by country, gender, product categories  
3. **Date Exploration** – Examine sales timeline and customer age ranges  
4. **Measures Exploration** – Track total sales, units sold, prices, and order volume  
5. **Magnitude Analysis** – Break down data by region, category, or customer segment  
6. **Ranking Analysis** – Identify top/bottom customers and products using SQL window functions

## 🗃️ Tables Used
- `gold.dim_customers`  
- `gold.dim_products`  
- `gold.fact_sales`  

## ⚠️ Warnings
- This analysis is read-only (safe to run).  
- Results reflect current warehouse data and may change with updates.  
- Run scripts in **SQL Server Management Studio (SSMS)**, section-by-section as needed.

---
