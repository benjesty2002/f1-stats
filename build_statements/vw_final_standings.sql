CREATE VIEW vw_final_standings AS
WITH ranked_races AS (
    SELECT *, RANK() OVER (PARTITION BY year ORDER BY round DESC) as rn
    FROM races
)
, final_races AS (
    SELECT *
    FROM ranked_races
    WHERE rn = 1
)
SELECT  fr.year,
        s.position,
        s.driverId,
        s.points
FROM driver_standings s
JOIN final_races fr
    ON s.raceId = fr.raceId
    AND fr.rn = 1
-- WHERE s.position = 1
ORDER BY fr.year, s.position
;