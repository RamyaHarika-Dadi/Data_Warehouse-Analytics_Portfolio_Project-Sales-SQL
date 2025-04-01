/*
====================================================================================================
🧪 Data Quality Checks - Silver Layer
====================================================================================================

📌 Purpose:
This script performs data quality validations on the Silver Layer of the data warehouse.  
It helps ensure that the data is clean, reliable, and ready for analytics by checking:

✔️ Nulls or duplicates in primary or foreign key columns  
✔️ Unwanted leading/trailing spaces in string fields  
✔️ Data standardization across low-cardinality columns  
✔️ Invalid or out-of-order date values  
✔️ Data consistency between related fields  
✔️ Logical mismatches such as sales ≠ quantity × price

⚙️ Tables Checked:
- silver.crm_cust_info
- silver.crm_prd_info
- silver.crm_sales_details
- silver.erp_cust_az12
- silver.erp_loc_a101
- silver.erp_px_cat_g1v2

⚠️ Usage Notes:
- Run this script after loading the Silver Layer.
- Any rows returned by these queries should be investigated.
- Fixes should be applied upstream in transformation logic or cleansing steps.

🧑‍💻 How to Run:
1. Open SQL Server Management Studio (SSMS).
2. Connect to your `DataWarehouse_Sales` database.
3. Execute the script section-by-section or all at once.

====================================================================================================
*/


-- =========================================================================================
-- silver.crm_cust_info
-- =========================================================================================

-- Primary Key Check: Ensure cst_id is unique and not null
-- Type: Data Consistency
SELECT cst_id, COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Whitespace Check: Unwanted spaces in first and last name
-- Type: Data Standardization
SELECT cst_firstname FROM silver.crm_cust_info WHERE cst_firstname != TRIM(cst_firstname);
SELECT cst_lastname FROM silver.crm_cust_info WHERE cst_lastname != TRIM(cst_lastname);

-- Value Check: Normalization of marital status values
-- Type: Data Normalization
SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info;

-- Value Check: Normalization of gender values
-- Type: Data Normalization
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;

-- Table Preview
SELECT * FROM silver.crm_cust_info;

-- =========================================================================================
-- silver.crm_prd_info
-- =========================================================================================

-- Primary Key Check: Ensure prd_id is unique and not null
-- Type: Data Consistency
SELECT prd_id, COUNT(prd_id) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1 AND prd_id IS NULL;

-- Whitespace Check: Product name cleanup
-- Type: Data Standardization
SELECT prd_nm FROM silver.crm_prd_info WHERE prd_nm != TRIM(prd_nm);

-- Value Validation: Check for negative or null product cost
-- Type: Data Validation
SELECT prd_cost FROM silver.crm_prd_info WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Value Check: Product line normalization
-- Type: Data Normalization
SELECT DISTINCT prd_line FROM silver.crm_prd_info;

-- Date Validation: Ensure start date is before end date
-- Type: Data Consistency
SELECT * FROM silver.crm_prd_info WHERE prd_end_dt < prd_start_dt;

-- Table Preview
SELECT * FROM silver.crm_prd_info;

-- =========================================================================================
-- silver.crm_sales_details
-- =========================================================================================

-- Foreign Key Check: Product key should exist in product info table
-- Type: Referential Integrity
SELECT sls_prd_key 
FROM silver.crm_sales_details 
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

-- Foreign Key Check: Customer ID should exist in customer info table
-- Type: Referential Integrity
SELECT * 
FROM silver.crm_sales_details 
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

-- Date Validation: Order date should be before shipping and due dates
-- Type: Data Consistency
SELECT * 
FROM silver.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Business Rule Check: sales = quantity * price, and values must be valid
-- Type: Data Consistency & Validation
SELECT DISTINCT sls_sales, sls_quantity, sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
   OR sls_sales <= 0 OR sls_sales IS NULL 
   OR sls_quantity <= 0 OR sls_quantity IS NULL 
   OR sls_price <= 0 OR sls_price IS NULL;

-- Derived Calculation: Recompute sales and price if values are invalid
-- Type: Data Enrichment
SELECT DISTINCT
    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,
    CASE 
        WHEN sls_sales <= 0 OR sls_sales IS NULL 
             OR sls_sales != sls_quantity * ABS(sls_price) 
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE 
        WHEN sls_price <= 0 OR sls_price IS NULL  
        THEN sls_sales / NULLIF(sls_quantity,0)
        ELSE sls_price
    END AS sls_price
FROM silver.crm_sales_details;

-- Table Preview
SELECT * FROM silver.crm_sales_details;

-- =========================================================================================
-- silver.erp_cust_az12
-- =========================================================================================

-- Foreign Key Check: Extracted CID should exist in CRM customer info
-- Type: Referential Integrity & Enrichment
SELECT 
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
    END AS cid
FROM silver.erp_cust_az12
WHERE CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
      END NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Date Validation: Birthdates should not be in the future
-- Type: Data Validation
SELECT bdate FROM silver.erp_cust_az12 WHERE bdate > GETDATE();

-- Value Check: Gender normalization
-- Type: Data Normalization
SELECT DISTINCT gen FROM silver.erp_cust_az12;

-- Table Preview
SELECT * FROM silver.erp_cust_az12;

-- =========================================================================================
-- silver.erp_loc_a101
-- =========================================================================================

-- Foreign Key Check: CID should match CRM customer info
-- Type: Referential Integrity
SELECT cid 
FROM silver.erp_loc_a101 
WHERE cid NOT IN (SELECT cst_key FROM silver.crm_cust_info);

-- Country Normalization: Convert codes to readable country names
-- Type: Data Standardization
SELECT DISTINCT cntry AS old_cntry,
       CASE 
           WHEN TRIM(cntry) = 'DE' THEN 'Germany'
           WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
           WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
           ELSE TRIM(cntry)
       END AS cntry
FROM silver.erp_loc_a101;

-- Table Preview
SELECT * FROM silver.erp_loc_a101;

-- =========================================================================================
-- silver.erp_px_cat_g1v2
-- =========================================================================================

-- Whitespace Check: Clean up in category-related fields
-- Type: Data Standardization
SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Value Check: List of distinct values for verification
-- Type: Data Normalization
SELECT DISTINCT cat FROM silver.erp_px_cat_g1v2;
SELECT DISTINCT subcat FROM silver.erp_px_cat_g1v2;
SELECT DISTINCT maintenance FROM silver.erp_px_cat_g1v2;

-- Table Preview
SELECT * FROM silver.erp_px_cat_g1v2;


