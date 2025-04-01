/*
====================================================================================================
📥 Load Data into Silver Layer - Stored Procedure
====================================================================================================

📌 Purpose:
This script creates a stored procedure [silver.load_silver] that loads cleansed and standardized data into the Silver Layer of the data warehouse. 
It transforms raw data from the Bronze Layer into structured, analytics-ready data.

The procedure performs:
1. Truncation of existing silver tables.
2. Cleansing, normalization, and transformation of data from bronze tables.
3. Insertion of processed data into silver tables.

⚙️ Parameters:
- None.  
  This stored procedure does not accept any parameters or return any values.

▶️ Usage Example:
    EXEC silver.load_silver;

🔑 Key Features:
- Removes duplicates using `ROW_NUMBER()`.
- Normalizes values (e.g., gender, marital status, country).
- Validates and formats date fields.
- Derives fields such as product category, sales amount, and price.
- Cleans invalid or null data entries.
- Adds metadata via default `dwh_create_date`.

⚠️ Warnings:
- This procedure **truncates** all silver tables before loading — all existing data will be lost.
- Ensure bronze layer is fully loaded and validated before executing this procedure.
- This script is intended for development or test environments only.

🧑‍💻 How to Run:
1. Open SQL Server Management Studio (SSMS).
2. Connect to the 'DataWarehouse_Sales' database.
3. Execute this script to create or alter the stored procedure.
4. Run: EXEC silver.load_silver; to initiate the Silver Layer data load process.

====================================================================================================
*/

---------------------------------------------------------------------------------------------------------------
--Stored Procedure - Silver layer
---------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	BEGIN TRY
			PRINT '=================================================================================='
			PRINT 'Loading the Silver Layer'
			PRINT '=================================================================================='

			DECLARE @start_time DATETIME, @end_time DATETIME, @layer_start_time DATETIME, @layer_end_time DATETIME

			PRINT '----------------------------------------------------------------------------------'
			PRINT 'Loading CRM Tables'
			PRINT '----------------------------------------------------------------------------------'

			SET @layer_start_time = GETDATE()
			SET @start_time = GETDATE()
			PRINT '- Truncating the table: silver.crm_cust_info';
			TRUNCATE TABLE silver.crm_cust_info;
			PRINT '- Inserting Data into: silver.crm_cust_info';
			INSERT INTO silver.crm_cust_info (
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_marital_status,
				cst_gndr,
				cst_create_date)

			SELECT 
				cst_id,
				cst_key,
				TRIM(cst_firstname) AS cst_firstname, -- removing unwanted spaces
				TRIM(cst_lastname) As cst_lastname,
				CASE
					WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
					WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
					ELSE 'n/a' 
				END cst_marital_status, -- normalize marital status values to readable format 
				CASE
					WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
					WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
					ELSE 'n/a' 
				END cst_gndr,   -- normalize gender values to readable format 
				cst_create_date
			FROM (
				SELECT 
					*,
					ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS duplicate_row
				FROM bronze.crm_cust_info
				WHERE cst_id IS NOT NULL 
			)t                               -- removing duplicates
			WHERE duplicate_row = 1;
			SET @end_time = GETDATE();
			PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
			PRINT '---------------------------------'

			SET @start_time = GETDATE()
			PRINT '- Truncating the table: silver.crm_prd_info';
			TRUNCATE TABLE silver.crm_prd_info;
			PRINT '- Inserting Data into: silver.crm_prd_info';
			INSERT INTO silver.crm_prd_info(
				prd_id,
				cat_id,
				prd_key,
				prd_nm,
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
			)

			SELECT 
				prd_id,
				REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,   -- Extract category ID
				SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,        -- Extract product key
				prd_nm,
				ISNULL(prd_cost,0) AS prd_cost,
				CASE UPPER(TRIM(prd_line))
					WHEN 'M' THEN 'Mountain'
					WHEN 'R' THEN 'Road'
					WHEN 'S' THEN 'Other Sales'
					WHEN 'T' THEN 'Touring'
					ELSE 'n/a'
				END AS prd_line,  -- Map product line codes to descriptive values 
				CAST(prd_start_dt AS DATE) AS prd_start_dt,  --Type Casting
				CAST(
					LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 
					AS DATE
				) AS prd_end_dt   -- Calculate end date as one day before the start date
			FROM bronze.crm_prd_info;
			SET @end_time = GETDATE();
			PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
			PRINT '---------------------------------'

			SET @start_time = GETDATE()
			PRINT '- Truncating the table: silver.crm_sales_details';
			TRUNCATE TABLE silver.crm_sales_details;
			PRINT '- Inserting Data into: silver.crm_sales_details';
			INSERT INTO silver.crm_sales_details (
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price
			)

			SELECT 
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				CASE 
					WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL  -- Handling invalid values
					ElSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)           -- Type casting the dates
				END AS sls_order_dt, 
				CASE 
					WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
					ElSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
				END AS sls_ship_dt,
				CASE 
					WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
					ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
				END AS sls_due_dt,
				CASE 
					WHEN sls_sales <= 0 OR sls_sales IS NULL Or sls_sales!= sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
					ELSE sls_sales
				END AS sls_sales,           -- Recalculate the sales if the original value is missing or incorrect
				sls_quantity,
				CASE 
					WHEN sls_price <= 0 OR sls_price IS NULL  THEN sls_sales / NULLIF(sls_quantity,0)
					ELSE sls_price
				END AS sls_price              --Derive price if original value is invalid
			FROM bronze.crm_sales_details;
			SET @end_time = GETDATE();
			PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
			PRINT '---------------------------------'

			PRINT '----------------------------------------------------------------------------------'
			PRINT ' Loading ERP Tables'
			PRINT '----------------------------------------------------------------------------------'

			SET @start_time = GETDATE()
			PRINT '- Truncating the table: silver.erp_cust_az12';
			TRUNCATE TABLE silver.erp_cust_az12;
			PRINT '- Inserting Data into: silver.erp_cust_az12';
			INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)

			SELECT 
				CASE
					WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))     -- Remove 'NAS' prefix if present in cid
					ELSE cid
				END AS cid,
				CASE 
					WHEN bdate > GETDATE() THEN NULL
					ELSE bdate
				END AS bdate,   -- Set the future birth dates to NULL
				CASE
					WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
					WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
					ELSE 'n/a'
				END AS gen   -- Normalize the gender values and handle unknown values
			FROM bronze.erp_cust_az12;
			SET @end_time = GETDATE();
			PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
			PRINT '---------------------------------'

			SET @start_time = GETDATE()
			PRINT '- Truncating the table: silver.erp_loc_a101';
			TRUNCATE TABLE silver.erp_loc_a101;
			PRINT '- Inserting Data into: silver.erp_loc_a101';
			INSERT INTO silver.erp_loc_a101 (cid,cntry)

			SELECT 
				REPLACE(cid, '-','') AS cid,
				CASE 
					WHEN TRIM(cntry) = 'DE' THEN 'Germany'
					WHEN TRIM(cntry) IN ('US' , 'USA') THEN 'United States'
					WHEN TRIM(cntry) ='' OR cntry IS NULL THEN 'n/a'
					ELSE TRIM(cntry)
				END AS cntry          -- Normalize and Handle missing values in country
			FROM bronze.erp_loc_a101;
			SET @end_time = GETDATE();
			PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
			PRINT '---------------------------------'

			SET @start_time = GETDATE()
			PRINT '- Truncating the table: silver.erp_px_cat_g1v2';
			TRUNCATE TABLE silver.erp_px_cat_g1v2;
			PRINT '- Inserting Data into: silver.erp_px_cat_g1v2';
			INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)

			SELECT
				id,
				cat,
				subcat,
				maintenance
			FROM bronze.erp_px_cat_g1v2;
			SET @end_time = GETDATE();
			PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
			PRINT '---------------------------------'

			PRINT '=================================================================================='
			SET @layer_end_time = GETDATE();
			PRINT 'Loading Silver layer is completed'
			PRINT '- Time taken by Silver layer for loading data: ' + CAST(DATEDIFF(second, @layer_start_time, @layer_end_time) AS NVARCHAR) + ' seconds'
			PRINT '=================================================================================='
		END TRY
	
		BEGIN CATCH
			PRINT '============================================================================'
			PRINT 'ERROR OCCURED DURING LOADING Silver LAYER';
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
			PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
			PRINT '============================================================================'
		END CATCH
END



---------------------------------------------------------------------------------------------------------------
--execute the procedure of silver layer
---------------------------------------------------------------------------------------------------------------
EXEC silver.load_silver

