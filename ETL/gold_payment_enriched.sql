select 
	product_id,
	SUM(volume) as totol_volume
from silver.payment_enriched 
group by product_id 
order by totol_volume desc
limit 3;



select 
	product_id,
	count(distinct team_own) as team_own_1
from silver.payment_enriched
where team_own is not null
group by product_id 
having count(distinct team_own) > 1



select 
	team_own,
	SUM(volume) as total_volume
from silver.payment_enriched
where report_month >= '2023-04-01'
group by team_own
order by total_volume asc
limit 1

select 
	category,
	SUM(volume) as total_volume
from silver.payment_enriched
where report_month >= '2023-04-01' and team_own = 'APS'
group by category
order by total_volume asc
limit 1



select 
	source_id,
	SUM(volume) as total_volume
from silver.payment_enriched
where payment_group = 'refund'
group by source_id
order by total_volume desc
limit 1


