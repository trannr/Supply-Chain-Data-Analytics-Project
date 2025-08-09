SELECT *
FROM supply_chain_data;

-- TOP SELLING PRODUCTS
		-- Which SKUs/products generate the highest revenue?
SELECT SKU, `Product type`, `Revenue generated` AS Revenue
FROM supply_chain_data
ORDER BY Revenue DESC; 

		-- Which top 5 products generate the highest total revenue and what percentage of overall company revenue do they contribute?
SELECT SKU, `Product type`, `Revenue generated` AS Revenue, CONCAT(ROUND(SUM(`Revenue generated`)/SUM(SUM(`Revenue generated`)) OVER ()*100, 2), '%') AS revenue_pct
FROM supply_chain_data
GROUP BY SKU, `Product type`, Revenue
ORDER BY Revenue DESC
LIMIT 5;

		-- Top 10 SKUs by total revenue
SELECT SKU, `Product type`, SUM(`Revenue generated`) AS total_revenue
FROM supply_chain_data
GROUP BY SKU, `Product type`
ORDER BY total_revenue DESC
LIMIT 10;
        
        -- Revenue by product type (share of total)
SELECT `Product type`, SUM(`Revenue generated`) AS revenue, CONCAT(ROUND(SUM(`Revenue generated`)/SUM(SUM(`Revenue generated`)) OVER ()*100, 2), '%') AS revenue_pct
FROM supply_chain_data
GROUP BY `Product type`
ORDER BY revenue DESC;
