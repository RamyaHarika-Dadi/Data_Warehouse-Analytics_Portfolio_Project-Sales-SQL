/*
====================================================================================================
Load Data into Bronze Layer - Stored Procedure
====================================================================================================

📌 Purpose:
This script creates a stored procedure [bronze.load_bronze] responsible for loading 
raw data from CSV files into the Bronze Layer of the data warehouse using BULK INSERT.
The data is sourced from ERP and CRM systems and loaded into staging tables.

📌 Parameters:
- None.  
  This stored procedure does not accept any parameters or return any values.

▶️ Usage Example:
EXEC bronze.load_bronze;

🔑 Key Features:
- Loads data into six bronze tables from source CSV files.
- Truncates existing table data before each load to prevent duplication.
- Measures and prints loading time for each table.
- Includes TRY...CATCH for error handling and logging.

Warnings:
⚠️ This procedure uses TRUNCATE TABLE — all existing data in the target tables 
   will be permanently deleted before loading new data.
⚠️ Ensure file paths to source CSVs are valid and accessible from the SQL Server.
⚠️ This script is intended for development and testing environments only.
⚠️ Requires appropriate file system permissions to execute BULK INSERT.

🧑‍💻 How to Run:
1. Open SQL Server Management Studio (SSMS).
2. Connect to the 'DataWarehouse_Sales' database.
3. Execute this script to create or alter the stored procedure.
4. Run: EXEC bronze.load_bronze;  to initiate the data load process.

*/



-- BULK INSERTING the data from source to database tables ---STORED PROCEDURE -------
CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	BEGIN TRY
		PRINT '=================================================================================='
		PRINT 'Loading the Bronze Layer'
		PRINT '=================================================================================='

		DECLARE @start_time DATETIME, @end_time DATETIME, @layer_start_time DATETIME, @layer_end_time DATETIME

		PRINT '----------------------------------------------------------------------------------'
		PRINT 'Loading CRM Tables'
		PRINT '----------------------------------------------------------------------------------'

		SET @layer_start_time = GETDATE()
		SET @start_time = GETDATE()
		PRINT '- Truncating the table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '- Inserting Data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\kalya\Documents\datasets\source_crm\cust_info.csv'
		WITH ( 
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------'

		SET @start_time = GETDATE()
		PRINT '- Truncating the table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '- Inserting Data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\kalya\Documents\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------'

		SET @start_time = GETDATE()
		PRINT '- Truncating the table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '- Inserting Data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\kalya\Documents\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------'

		PRINT '----------------------------------------------------------------------------------'
		PRINT ' Loading ERP Tables'
		PRINT '----------------------------------------------------------------------------------'


		SET @start_time = GETDATE()
		PRINT '- Truncating the table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
	
		PRINT '- Inserting Data into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\kalya\Documents\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------'


		SET @start_time = GETDATE()
		PRINT '- Truncating the table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
	
		PRINT '- Inserting Data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\kalya\Documents\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------'

		SET @start_time = GETDATE()
		PRINT '- Truncating the table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '- Inserting Data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\kalya\Documents\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '- Loading time: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------------------'

		PRINT '=================================================================================='
		SET @layer_end_time = GETDATE();
		PRINT 'Loading Bronze layer is completed'
		PRINT '- Time taken by Bronze layer for loading data: ' + CAST(DATEDIFF(second, @layer_start_time, @layer_end_time) AS NVARCHAR) + ' seconds'
		PRINT '=================================================================================='
	END TRY
	
	BEGIN CATCH
		PRINT '============================================================================'
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '============================================================================'
	END CATCH
END

