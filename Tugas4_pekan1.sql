S
4.1 Pembayaran favorit all time
SELECT pay.payment_type as payment_type, 
	count(1) as total_payment
FROM order_payments_dataset as pay
	JOIN orders_dataset as o ON o.order_id = pay.order_id
	WHERE o.order_status != 'canceled' --Payment selain cancel dihitung sebagai payment valid, sedangkan cancel tidak dihitung
	GROUP BY 1
	ORDER BY 2 DESC

=====================================================================================
4.2. Perhitungan setiap tahun
select
    pay.payment_type,
    count(case when extract(year from o.order_purchase_timestamp)=2016 then pay.order_id end) as year_2016,
    count(case when extract(year from o.order_purchase_timestamp)=2017 then pay.order_id end) as year_2017,
    count(case when extract(year from o.order_purchase_timestamp)=2018 then pay.order_id end) as year_2018,
    count(pay.order_id) as total_all_time
from order_payments_dataset as pay
join orders_dataset as o
    on pay.order_id = o.order_id
--WHERE o.order_status != 'canceled' --Payment selain cancel dihitung sebagai payment valid, sedangkan cancel tidak dihitung
group by 1
order by 5 desc;

