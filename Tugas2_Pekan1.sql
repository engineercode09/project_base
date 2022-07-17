-- 1. Rata-rata aktif bulanan
SELECT 
	year, 
	round(avg(mau), 2) as average_mau
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) as year,
		date_part('month', o.order_purchase_timestamp) as month,
		count(distinct c.customer_unique_id) as mau 
	FROM orders_dataset as o 
	JOIN customers_dataset as c on o.customer_id = c.customer_id
	GROUP BY 1,2 
) SUBQ
GROUP BY 1;
=================================================
-- 2. Menampilkan jumlah customer baru pada masing-masing tahun
SELECT
	YEAR,
	COUNT(DISTINCT pelanggan) as total_pelanggan_baru
FROM(SELECT 
	 MIN(date_part('year', o.order_purchase_timestamp)) as YEAR,
	   c.customer_unique_id AS pelanggan
	 FROM orders_dataset as o
	 JOIN customers_dataset AS c ON o.customer_id = c.customer_id
	 GROUP BY 2) as SUBQ
GROUP BY 1;

=================================================
-- 3. Menampilkan jumlah customer yang melakukan pembelian (repeat order) pada masing-masing tahun
SELECT YEAR, 
	   COUNT(subq) as Pelanggan_Repeat_order
FROM (SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
	   		c.customer_unique_id AS pelanggan,
			COUNT(2) AS jumlah_pembelian
		FROM orders_dataset as o
		JOIN customers_dataset AS c ON o.customer_id = c.customer_id
		GROUP BY 1,2	 
		HAVING COUNT(2)>1
	  	ORDER BY 1
	 ) as SUBQ
GROUP BY YEAR
ORDER BY YEAR
--
=================================================
--4. Menampilkan rata-rata jumlah order yang dilakukan customer untuk masing-masing tahun (Hint: Hitung frekuensi order (berapa kali order) untuk masing-masing customer terlebih dahulu)

SELECT YEAR, 
		round(AVG(jumlah_pembelian), 3)as AVG_order_customer
FROM( 
		SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
					c.customer_unique_id AS pelanggan,
					COUNT(2) AS jumlah_pembelian
		FROM orders_dataset as o
		JOIN customers_dataset AS c ON o.customer_id = c.customer_id
		GROUP BY 1,2	 
	 )as SUBQ
GROUP BY YEAR
ORDER BY YEAR
===

-------------
SELECT 
FROM 
-------------
SELECT *
from customers_dataset;
-------------
SELECT *
from orders_dataset;
--------------
SELECT *
from order_items_dataset;
--------------
