-- Doi kieu du lieu timeStamp sang date

create table silver.transaction as
select 
	* ,
	cast(TO_TIMESTAMP("timeStamp" / 1000.0) as DATE) AS date_timeStamp
from bronze."transaction" 


-- kiem tra missing data

select
	count(*) - count(transaction_id) AS missing_transaction,
	count(*) - count(merchant_id) as missing_merchan,
    count(*) - count("transType" ) AS missing_transType,
    count(*) - count("transStatus") as missing_transStatus,
    count(*) - count(volume) AS missing_volume,
    ((count(*) - count(sender_id)* 1.0) / count(*) * 100)AS missing_sender,
    ((count(*) - count(receiver_id)*1.0) / count(*) * 100) as missing_receive,
    ((count(*) - count(extra_info)*1.0) / count(*) * 100) as missing_extra,
    count(*) - count(date_timestamp) as missing_date_timeStamp
from silver."transaction"  


-- kiem tra va xoa du lieu trung lap

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


-- Kiem tra gia tri volume

select volume  
from bronze."transaction" 
where volume < 0


-- Xoa column 
ALTER TABLE silver."transaction" 
DROP COLUMN "timeStamp",
DROP COLUMN "extra_info",
DROP COLUMN ingestion_at


select * 
from silver."transaction"



