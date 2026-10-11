-- merge 2 table payment_report and product

create table silver.payment_enriched as 
select 
	pr.*,
	p.category,
	p.team_own 
from bronze.payment_report pr
left join bronze.product p 
on pr.product_id  = p.product_id 


-- check column missing data

select
	count(*) - count(report_month) AS missing_month,
	count(*) - count(payment_group) as missing_payment,
    count(*) - count(product_id) AS missing_product_id,
    count(*) - count(source_id) as missing_source,
    count(*) - count(volume) AS missing_volume,
    count(*) - count(category) AS missing_category,
    count(*) - count(team_own) as missing_team_oown
from silver.payment_enriched 


-- check duplicate data

with duplica as(
select 
	*,
	row_number() over(
		partition by report_month, payment_group, product_id, source_id, volume, category, team_own
		order by ingestion_at desc) as number
from silver.payment_enriched 
)
select * 
from duplica
where "number" > 1
 

-- replace column data type report_month -> DATE

ALTER TABLE silver.payment_enriched
ALTER COLUMN report_month TYPE DATE 
USING TO_DATE(report_month || '-01', 'YYYY-MM-DD')


-- check value volume > 0

select volume 
from silver.payment_enriched
where volume < 0


-- drop column 

ALTER TABLE silver.payment_enriched 
DROP column ingestion_at;


select *
from silver.payment_enriched 

