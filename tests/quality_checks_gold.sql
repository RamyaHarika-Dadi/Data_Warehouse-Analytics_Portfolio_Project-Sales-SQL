/*
====================================================================================================
🧪 Data Quality Checks - Gold Layer
====================================================================================================

📌 Purpose:
This script performs data quality validations on the Gold Layer of the data warehouse.  
It ensures that the star schema views created for analytical reporting are correctly formed by checking:

✔️ Surrogate key uniqueness in dimension views  
✔️ Referential integrity between fact and dimension views  
✔️ Proper join relationships (no null keys in fact view)  
✔️ Logical completeness of the dimensional model

⚙️ Views Checked:
- gold.dim_customers
- gold.dim_products
- gold.fact_sales

⚠️ Usage Notes:
- Run this script after Gold Layer views are created.
- Any rows returned indicate data quality or relationship issues that should be investigated.
- Issues may require fixing upstream in the Silver Layer or source logic.

🧑‍💻 How to Run:
1. Open SQL Server Management Studio (SSMS).
2. Connect to your 'DataWarehouse_Sales' database.
3. Execute this script section-by-section or all at once.

====================================================================================================
*/

-- =========================================================================================
-- gold.dim_customers
-- =========================================================================================

-- Primary Key Check: Ensure customer_key is unique
-- Type: Data Consistency
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- =========================================================================================
-- gold.dim_products
-- =========================================================================================

-- Primary Key Check: Ensure product_key is unique
-- Type: Data Consistency
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- =========================================================================================
-- gold.fact_sales
-- =========================================================================================

-- Foreign Key Check: Ensure fact table is properly joined with dimensions
-- Type: Referential Integrity
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
