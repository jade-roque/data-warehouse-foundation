/*
===============================================================================
Script: Load Bronze Layer
===============================================================================
Purpose:
    This script clears out the bronze table and reloads it with fresh data.
    The goal is to make sure the table stays clean and doesn’t end up 
    with duplicate rows.

Steps:
    1. Truncate the table (remove all existing rows).
    2. Load new data from the source (CSV or raw files) (BULK INSERT).

Notes:
    This is a full load, not incremental meaning it replaces everything 
    instead of adding new records.

Usage:
    EXEC bronze.load_bronze;
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;
	BEGIN TRY
		SET @batch_start = GETDATE();
		PRINT '==============================================';
		PRINT '			Loading Bronze Layer';
		PRINT '==============================================';

		PRINT '- - - - - - - - - - - - - - - - - - - - - - - ';
		PRINT '				Loading CRM Tables';
		PRINT '- - - - - - - - - - - - - - - - - - - - - - - ';

		--CRM--

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info...';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting data to: bronze.crm_cust_info...';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Downloads D\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ...';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info...';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting data to: bronze.crm_prd_info...';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Downloads D\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ...';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: crm_sales_details...';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting data to: bronze.crm_sales_details...';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Downloads D\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ...';

		PRINT '- - - - - - - - - - - - - - - - - - - - - - - ';
		PRINT '				Loading ERP Tables';
		PRINT '- - - - - - - - - - - - - - - - - - - - - - - ';

		--ERP--

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12...';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting data to: bronze.erp_cust_az12...';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Downloads D\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ...';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101...';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting data to: bronze.erp_loc_a101...';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Downloads D\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ...';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2...';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting data to: bronze.erp_px_cat_g1v2...';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Downloads D\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ...';

		SET @batch_end = GETDATE();
		PRINT '==============================================';
		PRINT '** Loading of Bronze Layer Complete **';
		PRINT 'Total Loading Duration of Bronze Layer: ' + CAST(DATEDIFF(second, @batch_start, @batch_end) AS NVARCHAR) + ' seconds';
		PRINT '==============================================';
	END TRY
	BEGIN CATCH
		
		PRINT '- - - - - - - - - - - - - - - - - - - - - - - -';
		PRINT '	  ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT '	  ERROR MSG: ' +  ERROR_MESSAGE();
		PRINT '	  ERROR NUM: ' +  CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '- - - - - - - - - - - - - - - - - - - - - - - -';
	END CATCH
END
