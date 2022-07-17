--3.1. Revenue total per tahun --DONE
SELECT YEAR, sum(revenue) as total_revenue
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) as YEAR,
		o.order_id,
		oi.price,
		oi.freight_value,
		oi.price + oi.freight_value as revenue,
		o.order_status
	FROM orders_dataset as o
	JOIN order_payments_dataset as pay on o.order_id = pay.order_id
	JOIN order_items_dataset as oi on o.order_id = oi.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY 1,2,3,4
	) as subq
GROUP BY 1
ORDER BY 1
================================================================
--3.2. Jumlah cancel order per tahun --DONE
SELECT YEAR,sum(jumlah_cancel) as total_cancel
FROM (
	SELECT 
			date_part('year', o.order_purchase_timestamp) as YEAR,
			o.order_id,
			o.order_status,
			count(2) as jumlah_cancel
	FROM orders_dataset as o
	JOIN order_payments_dataset as pay on o.order_id = pay.order_id
	WHERE o.order_status = 'canceled'
	GROUP BY 1,2,3
	ORDER BY jumlah_cancel DESC
	) as subq
GROUP BY YEAR;
================================================================
3.3 Top kategori yang menghasilkan revenue terbesar per tahun 
SELECT a.YEAR, a.revenue, category as top_revenue_category
FROM (
	SELECT 
		YEAR, max(revenue) as revenue
	FROM(
		SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
			p.product_category_name as category,
			oi.price,
			oi.freight_value,
			oi.price + oi.freight_value as revenue,
			o.order_status
			FROM product_dataset as p
			JOIN order_items_dataset as oi on oi.product_id = p.product_id
			JOIN orders_dataset as o on oi.order_id = o.order_id
			WHERE o.order_status = 'delivered'
			GROUP BY 1,2,3,4,6
			ORDER BY REVENUE DESC) as SUBQ
	GROUP BY 1
	ORDER BY YEAR, revenue desc 
	) as subq2

INNER JOIN 
	(SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
		p.product_category_name as category,
		oi.price,
		oi.freight_value,
		oi.price + oi.freight_value as revenue,
		o.order_status
		FROM product_dataset as p
		JOIN order_items_dataset as oi on oi.product_id = p.product_id
		JOIN orders_dataset as o on oi.order_id = o.order_id
		WHERE o.order_status = 'delivered'
		GROUP BY 1,2,3,4,6
		ORDER BY REVENUE DESC) as a
ON a.revenue = subq2.revenue AND a.year = subq2.year
ORDER BY YEAR
=====================================================================

3.4. Kategori yang mengalami cancel order terbanyak per tahun
SELECT a.YEAR, a.jumlah_cancel as max_cancel, category as top_cancel_category
FROM (
	SELECT year, max(jumlah_cancel) as max_cancel
	FROM (
		SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
			p.product_category_name as category,
			o.order_status, 
			count(2) as jumlah_cancel
		FROM product_dataset as p
		JOIN order_items_dataset as oi on oi.product_id = p.product_id
		JOIN orders_dataset as o on oi.order_id = o.order_id
		WHERE o.order_status = 'canceled'
		GROUP BY 1,2,3
		order by jumlah_cancel desc
		) as subq
	Group by 1
	ORDER BY YEAR
) as subq2

INNER JOIN (SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
			p.product_category_name as category,
			o.order_status, 
			count(2) as jumlah_cancel
		FROM product_dataset as p
		JOIN order_items_dataset as oi on oi.product_id = p.product_id
		JOIN orders_dataset as o on oi.order_id = o.order_id
		WHERE o.order_status = 'canceled'
		GROUP BY 1,2,3
		order by jumlah_cancel desc
		) as a
ON subq2.max_cancel = a.jumlah_cancel AND subq2.year =a.year
ORDER BY YEAR
---
3.5. Master
SELECT 
	satu.year,
	satu.total_revenue,
	dua.total_cancel,
	tiga.top_revenue_category,
	empat.top_cancel_category
		
FROM (SELECT YEAR, sum(revenue) as total_revenue
FROM (
	SELECT 
		date_part('year', o.order_purchase_timestamp) as YEAR,
		o.order_id,
		oi.price,
		oi.freight_value,
		oi.price + oi.freight_value as revenue,
		o.order_status
	FROM orders_dataset as o
	JOIN order_payments_dataset as pay on o.order_id = pay.order_id
	JOIN order_items_dataset as oi on o.order_id = oi.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY 1,2,3,4
	) as subq
GROUP BY 1
ORDER BY 1
	  ) as satu
	  
INNER JOIN (
	SELECT YEAR,sum(jumlah_cancel) as total_cancel
FROM (
	SELECT 
			date_part('year', o.order_purchase_timestamp) as YEAR,
			o.order_id,
			o.order_status,
			count(2) as jumlah_cancel
	FROM orders_dataset as o
	JOIN order_payments_dataset as pay on o.order_id = pay.order_id
	WHERE o.order_status = 'canceled'
	GROUP BY 1,2,3
	ORDER BY jumlah_cancel DESC
	) as subq
GROUP BY YEAR) as dua
ON satu.year = dua.year

INNER JOIN (
	SELECT a.YEAR, a.revenue, category as top_revenue_category
FROM (
	SELECT 
		YEAR, max(revenue) as revenue
	FROM(
		SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
			p.product_category_name as category,
			oi.price,
			oi.freight_value,
			oi.price + oi.freight_value as revenue,
			o.order_status
			FROM product_dataset as p
			JOIN order_items_dataset as oi on oi.product_id = p.product_id
			JOIN orders_dataset as o on oi.order_id = o.order_id
			WHERE o.order_status = 'delivered'
			GROUP BY 1,2,3,4,6
			ORDER BY REVENUE DESC) as SUBQ
	GROUP BY 1
	ORDER BY YEAR, revenue desc 
	) as subq2

INNER JOIN 
	(SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
		p.product_category_name as category,
		oi.price,
		oi.freight_value,
		oi.price + oi.freight_value as revenue,
		o.order_status
		FROM product_dataset as p
		JOIN order_items_dataset as oi on oi.product_id = p.product_id
		JOIN orders_dataset as o on oi.order_id = o.order_id
		WHERE o.order_status = 'delivered'
		GROUP BY 1,2,3,4,6
		ORDER BY REVENUE DESC) as a
ON a.revenue = subq2.revenue AND a.year = subq2.year
ORDER BY YEAR) as tiga
ON dua.year=tiga.year

INNER JOIN (
SELECT a.YEAR, a.jumlah_cancel as max_cancel, category as top_cancel_category
FROM (
	SELECT year, max(jumlah_cancel) as max_cancel
	FROM (
		SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
			p.product_category_name as category,
			o.order_status, 
			count(2) as jumlah_cancel
		FROM product_dataset as p
		JOIN order_items_dataset as oi on oi.product_id = p.product_id
		JOIN orders_dataset as o on oi.order_id = o.order_id
		WHERE o.order_status = 'canceled'
		GROUP BY 1,2,3
		order by jumlah_cancel desc
		) as subq
	Group by 1
	ORDER BY YEAR
) as subq2

INNER JOIN (SELECT date_part('year', o.order_purchase_timestamp) as YEAR,
			p.product_category_name as category,
			o.order_status, 
			count(2) as jumlah_cancel
		FROM product_dataset as p
		JOIN order_items_dataset as oi on oi.product_id = p.product_id
		JOIN orders_dataset as o on oi.order_id = o.order_id
		WHERE o.order_status = 'canceled'
		GROUP BY 1,2,3
		order by jumlah_cancel desc
		) as a
ON subq2.max_cancel = a.jumlah_cancel AND subq2.year =a.year
ORDER BY YEAR) as empat
ON tiga.year = empat.year


===========================================================
--TOOLS
SELECT * FROM order_items_dataset price, freight_value 
SELECT * FROM customers_dataset
SELECT * FROM geolocation_dataset
SELECT * FROM order_payments_dataset
SELECT * FROM order_reviews_dataset
SELECT * FROM orders_dataset
SELECT * FROM product_dataset
SELECT * FROM sellers_dataset