WITH ranked_leads AS 
(
    SELECT *, RANK() OVER (PARTITION BY year ORDER BY points_ratio DESC) as r
    FROM vw_driver_standings_leads
    -- WHERE year < 2023
)
SELECT *
FROM ranked_leads
WHERE r = 1
ORDER BY year