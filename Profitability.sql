SELECT *
FROM supply_chain_data;

-- Profitability: 
		-- Profit & margin by SKU 
        -- Profit = Revenue - Manufacturing Costs -  Costs
SELECT SKU, `Product type`, 
	SUM(`Revenue generated`) AS revenue,
    SUM(`Manufacturing costs`) AS mfg_cost, 
    SUM(Costs) AS ship_cost,
    (SUM(`Revenue generated`) - SUM(`Manufacturing costs`) - SUM(Costs)) AS profit,
    CASE WHEN 
		SUM(`Revenue generated`) = 0 THEN NULL
        ELSE CONCAT(ROUND(((SUM(`Revenue generated`) - SUM(`Manufacturing costs`) - SUM(Costs))/SUM(`Revenue generated`)) * 100, 2), '%')
	END AS profit_margin_pct
FROM supply_chain_data
GROUP BY SKU, `Product type`
ORDER BY profit DESC;
     
		-- Top 10 most profitable SKUs 
SELECT SKU, `Product type`, (SUM(`Revenue generated`) - SUM(`Manufacturing costs`) - SUM(Costs)) AS profit
FROM supply_chain_data
GROUP BY SKU, `Product type`
ORDER BY profit DESC
LIMIT 10;

		-- Most profitable product types by average profit
SELECT `Product type`, COUNT(DISTINCT SKU) AS num_skus, AVG(`Revenue generated` - `Manufacturing costs` - `Shipping costs`) AS Avg_Profit
FROM supply_chain_data
GROUP BY `Product type`
HAVING Avg_Profit > 0
ORDER BY Avg_Profit DESC;
