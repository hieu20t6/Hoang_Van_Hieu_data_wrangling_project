create table silver.payment_enriched as 
select 
	pr.*,
	p.category,
	p.team_own 
from bronze.payment_report pr
left join bronze.product p 
on pr.product_id  = p.product_id 

select
	COUNT(*) - COUNT(report_month) AS missing_month,
	COUNT(*) - COUNT(payment_group) as missing_payment,
    COUNT(*) - COUNT(product_id) AS missing_product_id,
    count(*) - count(source_id) as missing_source,
    COUNT(*) - COUNT(volume) AS missing_volume,
    COUNT(*) - COUNT(category) AS missing_category,
    count(*) - count(team_own) as missing_team_oown
from silver.payment_enriched 

with dulica as(
select 
	*,
	row_number() over(
		partition by report_month, payment_group, product_id, source_id, volume, category, team_own
		order by ingestion_at desc) as number
from silver.payment_enriched 
)
select * 
from dulica
where "number" > 1
 

ALTER TABLE silver.payment_enriched
ALTER COLUMN report_month TYPE DATE 
USING TO_DATE(report_month || '-01', 'YYYY-MM-DD')

select volume 
from silver.payment_enriched
where volume < 0

select *
from silver.payment_enriched 

ALTER TABLE silver.payment_enriched 
DROP column ingestion_at;

