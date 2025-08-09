SELECT *
FROM supply_chain_data;

-- SUPPLIER PERFORMANCE
		-- Supplier with the fastest or slowest lead times
SELECT `Supplier name`, MIN(`Lead time`) AS Fastest_lead_time, MAX(`Lead time`) AS Slowest_lead_time
FROM supply_chain_data
GROUP BY `Supplier name`
ORDER BY Average_Time;

		-- Average lead time per supplier
SELECT `Supplier name`, AVG(`Lead time`) AS avg_lead_time
FROM supply_chain_data
GROUP BY `Supplier name`
ORDER BY avg_lead_time ASC;

		-- Consistency of lead time
SELECT `Supplier name`, AVG(`Lead time`) AS avg_lead_time, STDDEV(`Lead time`) AS stdev_lead_time
FROM supply_chain_data
GROUP BY `Supplier name`
ORDER BY stdev_lead_time ASC, avg_lead_time ASC;	-- Low stdev = more predictability
