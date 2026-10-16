create or alter procedure bronze.load_bronze as
begin
		begin try 
			truncate table bronze.crm_cust_info;
			bulk insert bronze.crm_cust_info  
			from 'C:\Users\Hossam Eleraky\Downloads\sql-data-warehouse-project\
			sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
			with ( 
				firstrow = 2 ,
				fieldterminator = ',',
				tablock
			);
			truncate table bronze.crm_sales_details;
			bulk insert bronze.crm_sales_details 
			from 'C:\Users\Hossam Eleraky\Downloads\sql-data-warehouse-project\
			sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
			with ( 
				firstrow = 2 ,
				fieldterminator = ',',
				tablock
			);
			truncate table bronze.crm_prd_info ;
			bulk insert bronze.crm_prd_info 
			from 'C:\Users\Hossam Eleraky\Downloads\sql-data-warehouse-project\
			sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
			with ( 
				firstrow = 2 ,
				fieldterminator = ',',
				tablock
			);
			truncate table bronze.erp_CUST_AZ12;
			bulk insert bronze.erp_CUST_AZ12 
			from 'C:\Users\Hossam Eleraky\Downloads\sql-data-warehouse-project\
			sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
			with ( 
				firstrow = 2 ,
				fieldterminator = ',',
				tablock
			);
			truncate table bronze.erp_LOC_A101;
			bulk insert bronze.erp_LOC_A101 
			from 'C:\Users\Hossam Eleraky\Downloads\sql-data-warehouse-project\
			sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
			with ( 
				firstrow = 2 ,
				fieldterminator = ',',
				tablock
			);
			truncate table bronze.erp_PX_CAT_G1V2;
			bulk insert bronze.erp_PX_CAT_G1V2
			from 'C:\Users\Hossam Eleraky\Downloads\sql-data-warehouse-project\
			sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
			with ( 
				firstrow = 2 ,
				fieldterminator = ',',
				tablock
			);
	end try 
	begin catch
		print '========================================================'
		print 'Error Occured During Loading Bronze Layer '
		print '========================================================'
	end catch 
end
