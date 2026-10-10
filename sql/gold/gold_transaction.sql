with transaction_analysis as(
	select 
		*,
		case 
			when "transType" = 2 and merchant_id = 1205 then 'Bank Transfer Transaction'
			when "transType" = 2 and merchant_id = 2260 then 'Withdraw Money Transaction'
			when "transType" = 2 and merchant_id = 2270 then 'Top Up Money Transaction'
			when "transType" = 2 then 'Payment Transaction'
			when "transType" = 8 and merchant_id = 2250 then 'Transfer Money Transaction'
			when "transType" = 8 then 'Split Bill Transaction'
			else 'invalid transactions'
		end as transaction_type
	from silver."transaction" 
)
select 
	transaction_type,
	count(distinct transaction_id) as total_transaction,
	sum(volume) as total_volume,
	count(distinct sender_id) as total_sender,
	count(distinct receiver_id) as total_recevier
from each_transaction 
where transaction_type != 'invalid transactions'
group by transaction_type
 
