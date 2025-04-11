/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To analyze categorical dimensions including countries, product categories, and combinations.

SQL Functions Used:
    - DISTINCT
    - ORDER BY

Tables Used:
    - gold.dim_customers
    - gold.dim_products
===============================================================================
*/

-- Explore all countries our customers come from
SELECT DISTINCT country FROM gold.dim_customers;

-- Explore all Categories "The major Divisions"
SELECT DISTINCT category FROM gold.dim_products;

-- Explore category, subcategory, and product combinations
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1, 2, 3;
