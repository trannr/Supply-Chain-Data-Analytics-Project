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

-- Supplier lead time vs overall average (with % difference and label)
WITH overall AS (
  SELECT AVG(`Lead time`) AS avg_lead_time_overall
  FROM supply_chain_data
),
per_supplier AS (
  SELECT
    `Supplier name`,
    AVG(`Lead time`) AS avg_lead_time
  FROM supply_chain_data
  GROUP BY `Supplier name`
)
SELECT
  p.`Supplier name`,
  p.avg_lead_time,
  o.avg_lead_time_overall,
  (p.avg_lead_time - o.avg_lead_time_overall) AS diff_days,
  CASE
    WHEN o.avg_lead_time_overall = 0 THEN NULL
    ELSE ((p.avg_lead_time - o.avg_lead_time_overall) / o.avg_lead_time_overall) * 100.0
  END AS pct_diff_from_overall,
  CASE
    WHEN p.avg_lead_time <= o.avg_lead_time_overall THEN 'Faster than average'
    ELSE 'Slower than average'
  END AS performance_bucket
FROM per_supplier p
CROSS JOIN overall o
ORDER BY p.avg_lead_time ASC;

