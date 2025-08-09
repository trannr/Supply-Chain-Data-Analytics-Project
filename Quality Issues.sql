SELECT *
FROM supply_chain_data;

-- QUALITY ISSUES
		-- Defect rate by product type (average of the metric in data)
SELECT `Product type`,  AVG(`Defect rates`) AS avg_defect_rate
FROM supply_chain_data
GROUP BY `Product type`
ORDER BY avg_defect_rate DESC;

		-- Suppliers above avergae defects but above average revenue (risk vs reward)
WITH supplier_rev AS 
	(SELECT `Supplier name`, SUM(`Revenue generated`) AS supplier_revenue
    FROM supply_chain_data
    GROUP BY `Supplier name`),
stats AS 
	(SELECT AVG(supplier_revenue) AS avg_supplier_revenue, 
        (SELECT AVG(`Defect rates`) FROM supply_chain_data) AS avg_defect
	FROM supplier_rev),
supplier_metrics AS 
	(SELECT
    `Supplier name` AS supplier_name, AVG(`Defect rates`) AS supplier_defect_rate, SUM(`Revenue generated`) AS supplier_revenue
	FROM supply_chain_data
  GROUP BY `Supplier name`)
SELECT
  sm.supplier_name,
  sm.supplier_defect_rate,
  sm.supplier_revenue
FROM supplier_metrics sm
CROSS JOIN stats t
WHERE sm.supplier_defect_rate > t.avg_defect
  AND sm.supplier_revenue > t.avg_supplier_revenue 
ORDER BY sm.supplier_revenue DESC;
