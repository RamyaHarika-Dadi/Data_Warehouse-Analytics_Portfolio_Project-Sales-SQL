/*
====================================================================================================
📥 Load Data into Silver Layer - Stored Procedure
====================================================================================================

📌 Purpose:
This script creates a stored procedure [silver.load_silver] that loads cleansed and 
standardized data into the Silver Layer of the data warehouse. It transforms raw data 
from the Bronze Layer into structured, analytics-ready data.

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
