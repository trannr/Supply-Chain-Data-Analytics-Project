SELECT *
FROM supply_chain_data;

-- INVENTORY OPTIMIZATION 
		-- Products that are understocked yet have high demand (below avg stock, above avg sold)
WITH avgs AS (
  SELECT
    AVG(`Stock levels`)             AS avg_stock,
    AVG(`Number of products sold`)  AS avg_sold
  FROM supply_chain_data
)
SELECT
  s.SKU,
  s.`Product type`,
  s.`Stock levels`,
  s.`Number of products sold`
FROM supply_chain_data s
CROSS JOIN avgs a
WHERE s.`Stock levels` < a.avg_stock
  AND s.`Number of products sold` > a.avg_sold
ORDER BY s.`Number of products sold` DESC;

		-- What categories are understocked and in high demand
SELECT `Product type`, SUM(`Stock levels`) AS total_stock, COUNT(*) AS num_products, SUM(`Number of products sold`) AS total_sold
FROM supply_chain_data
WHERE `Stock levels` < 
		(SELECT AVG(`Stock levels`) 
		FROM supply_chain_data
        )
AND 
		`Number of products sold` > 
        (SELECT AVG(`Number of products sold`) 
        FROM supply_chain_data
       )
GROUP BY `Product type`
ORDER BY total_sold DESC;

		-- Simple stock coverage ratio (lower = higher risk)
			-- Using sold vs stock since no date granularity is present
SELECT SKU, `Product type`, `Stock levels`, `Number of products sold`,
	CASE WHEN `Number of products sold` = 0 THEN NULL
    ELSE `Stock levels` * 1.0 / `Number of products sold`
    END AS stock_to_sales_ratio
FROM supply_chain_data
ORDER BY stock_to_sales_ratio IS NULL, stock_to_sales_ratio ASC, `Number of products sold` DESC;
