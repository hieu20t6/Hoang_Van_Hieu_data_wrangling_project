--1. Top 3 product_ids with the highest volume.

create table gold.top_3_produc_highest_volume as 
select 
	product_id,
	SUM(volume) as totol_volume
from silver.payment_enriched 
group by product_id 
order by totol_volume desc
limit 3;


--2. Given that 1 product_id is only owed by 1 team, are there any abnormal products against this rule?

create table gold.product_team_check as 
select 
	product_id,
	count(distinct team_own) as team_own_1
from silver.payment_enriched
where team_own is not null
group by product_id 
having count(distinct team_own) > 1


--3.1. Find the team has had the lowest performance (lowest volume) since Q2.2023. 

create table gold.team_performance as 
select 
	team_own,
	SUM(volume) as total_volume
from silver.payment_enriched
where report_month >= '2023-04-01'
group by team_own
order by total_volume asc
limit 1

--3.2. Find the category that contributes the least to that team.

create table gold.team_performance as 
select 
	category,
	SUM(volume) as total_volume
from silver.payment_enriched
where report_month >= '2023-04-01' and team_own = 'APS'
group by category
order by total_volume asc
limit 1


-- 4. Find the contribution of source_ids of refund transactions (payment_group = ‘refund’), what is the source_id with the highest contribution?
create table gold.refund_contribution 
select 
	source_id,
	SUM(volume) as total_volume
from silver.payment_enriched
where payment_group = 'refund'
group by source_id
order by total_volume desc
limit 1


