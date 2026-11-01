
create or alter procedure silver.load_silver as
begin
	truncate table silver.crm_cust_info ;
	insert into silver.crm_cust_info (
		cst_id	,			      
		cst_key	,			
		cst_firstname ,      
		cst_lastname	,	
		cst_marital_status , 
		cst_gndr,			
		cst_create_date	
		)
	select cst_id , cst_key ,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lasttname,
	case when trim(upper(cst_marital_status)) = 'S' then 'Single'
		 when trim(upper(cst_marital_status)) = 'M' then 'Married'	
		 else 'n/a'
	end cst_marital_status,
	case when trim(upper(cst_gndr)) = 'F' then 'Female'
		 when trim(upper(cst_gndr)) = 'M' then 'Male'	
		 else 'n/a'
	end cst_gndr,
	cst_create_date
	from (
	select 
	*,
	row_number() over (partition by cst_id order by cst_create_date desc )as flag
	 from bronze.crm_cust_info
	 where cst_id is not null) t 
	 where flag = 1 
	---------------------------------------------------
	truncate table silver.crm_prd_info;
	insert into silver.crm_prd_info(    
		prd_id	,
		cat_id ,
		prd_key	,		
		prd_nm	,		
		prd_cost ,		
		prd_line ,	
		prd_start_dt , 	  
		prd_end_dt )
	select 	
		prd_id	,
		replace(SUBSTRING  (prd_key,1,5),'-','_' )AS cat_id ,	
		SUBSTRING  (prd_key,7,len(prd_key))AS prd_key ,	
		prd_nm	,		
		isnull (prd_cost,0) as prd_cost ,		
		case upper(trim(prd_line)) 
			 when 'm' then 'Mountain'
			 when 'r' then 'Road'
			 when 's' then 'Other Sales'
			 when 't' then 'Touring'
		else 'n/a'
		end prd_line ,	
		cast( prd_start_dt as date) as prd_start_dt , 	  
		cast( lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt  
	from bronze.crm_prd_info


	---------------------------------------------------
	truncate table silver.crm_sales_details;
	insert into silver.crm_sales_details 
	(
		sls_ord_num		,
		sls_prd_key		 ,
		sls_cust_id		,
		sls_order_dt	,
		sls_ship_dt		,
		sls_due_dt		,
		sls_sales		,
		sls_price	,
		sls_quantity	
	)
	select 
		sls_ord_num		,
		sls_prd_key		,
		sls_cust_id		,
		case when sls_order_dt = 0 or len(sls_order_dt)!= 8 then null
		else cast(cast(sls_order_dt as varchar )as date)
		end sls_order_dt,
		case when sls_ship_dt	 = 0 or len(sls_ship_dt	)!= 8 then null
		else cast(cast(sls_ship_dt	 as varchar )as date)
		end sls_ship_dt,
		case when sls_due_dt = 0 or len(sls_due_dt)!= 8 then null
		else cast(cast(sls_due_dt as varchar )as date)
		end sls_due_dt,
	

	case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price)
		else sls_sales
		end as sls_sales,


	case when sls_price is null or sls_sales <=0 
		then sls_sales / nullif(sls_quantity,0)
		else sls_price
		end as sls_price ,
	

		sls_quantity	
	from bronze.crm_sales_details

	---------------------------------------------------
	truncate table silver.erp_CUST_AZ12;
	INSERT INTO silver.erp_CUST_AZ12 (CID,BDATE,GEN)
	select 
	case when CID like 'NAS%' then substring(CID,4,len(CID))
	else CID
	end CID,
	case when BDATE > GETDATE() then null
	else BDATE
	END BDATE,
	CASE
	WHEN UPPER(TRIM(GEN)) IN ('M','Male')then 'Male'
	WHEN UPPER(TRIM(GEN)) IN ('F','Female')then 'Female'
	end GEN
	from bronze.erp_CUST_AZ12 
	select * from silver.erp_CUST_AZ12 
	-----------------------------------------------
	truncate table silver.erp_LOC_A101;
	INSERT into silver.erp_LOC_A101 (CID,CNTRY)
	select 
	REPLACE(CID,'-','') as CID  ,
	CASE 
	When CNTRY = 'DE' then 'Germany'
	When CNTRY in ('USA','US') then 'United States'
	when CNTRY in (null , '') then 'n/a'
	else trim (CNTRY)
	END CNTRY 
	from  bronze.erp_LOC_A101
	-----------------------------------------------
	truncate table silver.erp_PX_CAT_G1V2;
	INSERT INTO silver.erp_PX_CAT_G1V2(
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE)
	select
	ID,
	CAT,
	SUBCAT,
	MAINTENANCE
	from bronze.erp_PX_CAT_G1V2
end


