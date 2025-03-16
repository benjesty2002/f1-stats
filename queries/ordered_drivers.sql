WITH driver_first_race as (
    SELECT  r.driverid
    ,       min(race_order) first_race
    FROM    results r
    JOIN    ordered_races rc
        ON  r.raceid = rc.raceid
    GROUP BY r.driverid
)
, driver_order as (
    SELECT  driverid
    ,       row_number() over (order by first_race, driverid) driver_order
    FROM    driver_first_race
)
SELECT  dio.driver_order
,       d.*
FROM    drivers d
JOIN    driver_order dio
    ON  d.driverid = dio.driverid