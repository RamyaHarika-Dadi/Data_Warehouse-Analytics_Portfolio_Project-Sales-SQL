
=======================================================================================
📊 Advanced SQL Analysis – SQL Data Warehouse Project
=======================================================================================

📌 Purpose:
This script contains a set of advanced SQL queries that dive deeper into analyzing sales, customer, and product data in the **Gold Layer** of the Data Warehouse. These analyses help uncover performance trends, cumulative metrics, proportional contributions, and strategic reporting insights.

✅ The analysis includes:
1️⃣ Change Over Time: Examine how metrics such as sales, quantity, and customers evolve over months and years.  
2️⃣ Cumulative Metrics: Calculate running totals and moving averages over time.  
3️⃣ Performance Analysis: Compare product performance against averages and prior years.  
4️⃣ Part-to-Whole Contribution: Analyze the proportion of sales by category.  
5️⃣ Data Segmentation: Categorize customers and products for targeted insights.  
6️⃣ Reporting Views: Build reusable views for customer and product performance summaries.

🗃️ Tables Used:
- gold.fact_sales  
- gold.dim_customers  
- gold.dim_products

⚠️ Warnings:
- All queries are read-only and safe to execute.
- Query results may change as data is updated.
- Best executed in SQL Server Management Studio (SSMS).
