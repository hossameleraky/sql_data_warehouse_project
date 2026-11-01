create view gold.dim_customer as 
Select 
ROW_NUMBER() over(order by g1.cst_id) as customer_key,
g1.cst_id as customer_id,
g1.cst_key as customer_number,
g1.cst_firstname as first_name,
g1.cst_lastname as last_name,
case when g1.cst_gndr != 'n/a' then g1.cst_gndr
else coalesce (g2.GEN,'n/a')
end as Gender ,
g2.BDATE as birthdate,
g1.cst_marital_status  as marital_status ,
g1.cst_create_date as create_date,
g3.CNTRY as CNTRY
from silver.crm_cust_info g1
left join silver.erp_CUST_AZ12 g2 
on g1.cst_key = g2.CID
left join silver.erp_LOC_A101 g3
on g1.cst_key = g3.CID

-----------------------------------------------------------------
create view gold.dim_Products as 
select 
ROW_NUMBER()over(order by g1.prd_start_dt ,g1.prd_key ) as product_key,
g1.prd_id as product_id,
g1.prd_key as product_number,
g1.prd_nm as product_name, 
g1.cat_id as category_id,
g2.CAT as category,
g2.SUBCAT as subcategory,
g1.prd_cost as cost ,
g1.prd_line as prd_line,
g2.MAINTENANCE,
g1.prd_start_dt as start_dt 
from silver.crm_prd_info g1
left join silver.erp_PX_CAT_G1V2 g2 
on g1.cat_id = g2.ID

------------------------------------------------------------------
create view gold.fact_sales as 
select 
g1.sls_ord_num as order_number ,
g3.product_key ,
g2.customer_key,
g1.sls_order_dt as order_date,
g1.sls_ship_dt as shipping_date,
g1.sls_due_dt as due_date,
g1.sls_sales as sales_amount,
g1.sls_quantity as quantity,
g1.sls_price as price  
from silver.crm_sales_details g1
left join gold.dim_customer g2 
on g1.sls_cust_id = g2.customer_id
left join gold.dim_Products g3
on g1.sls_prd_key = g3.product_number
