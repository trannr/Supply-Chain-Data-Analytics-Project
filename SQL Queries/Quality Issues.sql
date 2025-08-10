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

-- Supplier quality vs profitability: combined ranking score
WITH supplier_metrics AS (
  SELECT
    `Supplier name`,
    AVG(`Defect rates`) AS avg_defect_rate,
    SUM(`Revenue generated`) AS revenue,
    SUM(`Manufacturing costs`) AS mfg_cost,
    SUM(`Costs`) AS ship_cost,
    CASE
      WHEN SUM(`Revenue generated`) = 0 THEN NULL
      ELSE ( (SUM(`Revenue generated`) - SUM(`Manufacturing costs`) - SUM(`Costs`))
             / SUM(`Revenue generated`) ) * 100.0
    END AS profit_margin_pct,
    SUM(`Number of products sold`) AS total_units
  FROM supply_chain_data
  GROUP BY `Supplier name`
),
ranked AS (
  SELECT
    *,
    RANK() OVER (ORDER BY avg_defect_rate ASC)   AS r_defect   -- lower is better
  , RANK() OVER (ORDER BY profit_margin_pct DESC) AS r_margin   -- higher is better
  FROM supplier_metrics
)
SELECT
  `Supplier name`,
  avg_defect_rate,
  profit_margin_pct,
  total_units,
  (r_defect + r_margin) AS combined_rank
FROM ranked
-- Optional: focus on meaningful suppliers
WHERE total_units IS NULL OR total_units >= 1
ORDER BY combined_rank ASC, profit_margin_pct DESC;

