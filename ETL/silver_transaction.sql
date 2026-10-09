create table silver.transaction as
select 
	* ,
	cast(TO_TIMESTAMP("timeStamp" / 1000.0) as DATE) AS date_timeStamp
from bronze."transaction" 


select
	COUNT(*) - COUNT(transaction_id) AS missing_transaction,
	COUNT(*) - COUNT(merchant_id) as missing_merchan,
    COUNT(*) - COUNT("transType" ) AS missing_transType,
    count(*) - count("transStatus" ) as missing_transStatus,
    COUNT(*) - COUNT(volume) AS missing_volume,
    ((COUNT(*) - COUNT(sender_id)* 1.0) / COUNT(*) * 100)AS missing_sender,
    ((count(*) - count(receiver_id )*1.0) / COUNT(*) * 100) as missing_receive,
    ((count(*) - count(extra_info)*1.0) / COUNT(*) * 100) as missing_extra,
    count(*) - count(date_timestamp) as missing_date_timeStamp
from silver."transaction"  


with cte as(
	select 
		ctid,
		row_number() over(
			partition by transaction_id
			order by ctid asc
		) as row_num
	from silver."transaction"
)
delete from silver."transaction" 
where ctid in (
	select ctid
	from cte
	where row_num > 1
)

select volume  
from bronze."transaction" 
where volume < 0

ALTER TABLE silver."transaction" 
DROP COLUMN "timeStamp",
DROP COLUMN "extra_info",
DROP COLUMN ingestion_at;


select * 
from silver."transaction"

