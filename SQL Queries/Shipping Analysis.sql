SELECT *
FROM supply_chain_data;

-- SHIPPING ANALYSIS 
		-- Average shipping costs by carrier
SELECT `Shipping carriers`, AVG(`Shipping costs`) AS avg_cost_by_carrier
FROM supply_chain_data
GROUP BY `Shipping carriers`
ORDER BY avg_cost_by_carrier;

		-- Average shipping cost by transportation mode
SELECT `Transportation modes`, AVG(Costs) AS avg_costs
FROM supply_chain_data
GROUP BY `Transportation modes`
ORDER BY avg_costs ASC;

		-- Highest total shipping cost by route
SELECT Routes, SUM(Costs) AS total_cost
FROM supply_chain_data
GROUP BY Routes
ORDER BY total_cost DESC;
