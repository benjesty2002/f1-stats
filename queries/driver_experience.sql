WITH valid_results AS (
    SELECT  r.driverid
    ,       r.raceid
    ,       rc.year + (rc.round * 1.0 / rpy.races_in_year) AS race_index 
    ,       rpy.races_in_year
    ,       1.0 / rpy.races_in_year AS fraction_of_year
    FROM    results r
    JOIN    races rc
        ON  r.raceid = rc.raceid
    JOIN    races_per_year rpy
        ON  rc.year = rpy.year
    WHERE   r.positiontext NOT IN ('D', 'E', 'F', 'N', 'W')
)
SELECT  r.driverid
,       r.raceid
,       count(prior_races.driverid) AS prior_race_count
,       sum(prior_races.fraction_of_year) AS prior_season_count
FROM    valid_results r
LEFT JOIN valid_results prior_races
    ON  r.driverid = prior_races.driverid
    AND r.race_index > prior_races.race_index
GROUP BY r.driverid, r.raceid
