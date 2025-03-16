SELECT  d1.constructor_name
,       d1.driver_name as d1_name
,       d2.driver_name as d2_name
,       d1.driver_nationality as nationality
,       count(*) as num_races
FROM    entries_flattened d1
JOIN    entries_flattened d2
    ON  d1.constructorid = d2.constructorid
    AND d1.raceid = d2.raceid
    AND d1.driverid < d2.driverid
WHERE   d1.driver_nationality = d1.constructor_nationality
    AND d2.driver_nationality = d2.constructor_nationality
GROUP BY d1.constructor_name, d1.driver_name, d2.driver_name, d1.driver_nationality
ORDER BY count(*) DESC