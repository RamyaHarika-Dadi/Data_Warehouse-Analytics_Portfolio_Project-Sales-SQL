/*
=======================================================================================
📊 Exploratory Data Analysis (EDA) Script - SQL Data Warehouse Project
=======================================================================================

📌 Purpose:
This script performs Exploratory Data Analysis on the Gold Layer of the Data Warehouse.  
It is designed to help understand the data better, extract key insights, and validate  
data quality across customer, product, and sales dimensions.

✅ The analysis includes:

1️⃣ Database Exploration  
   - Explore available tables, views, and columns

2️⃣ Dimensions Exploration  
   - Analyze attributes such as country, gender, and product categories

3️⃣ Date Exploration  
   - Identify order ranges, customer birthdates, and overall time span

4️⃣ Measures Exploration  
   - Summarize key metrics like total sales, quantity sold, prices, and order counts

5️⃣ Magnitude Analysis  
   - Break down data by category, country, and customer segments

6️⃣ Ranking Analysis  
   - Use window functions to identify top and bottom performers

🗃️ Tables Used:
- gold.dim_customers  
- gold.dim_products  
- gold.fact_sales

⚠️ Notes:
- Ensure the Gold Layer views are built before running this script  
- Run section-by-section to explore and analyze specific insights  
- Designed for SQL Server and compatible with SSMS

=======================================================================================
*/
