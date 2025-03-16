with raceid_order as (
    SELECT  raceid
    ,       rank() over (order by year, round) as race_order
    FROM    races
)
, driverid_first_race as (
    SELECT  r.driverid
    ,       min(race_order) first_race
    FROM    results r
    JOIN    raceid_order rc
        ON  r.raceid = rc.raceid
    GROUP BY r.driverid
)
, driverid_order as (
    SELECT  driverid
    ,       row_number() over (order by first_race, driverid) driver_order
    FROM    driverid_first_race
)
, combined as (
    SELECT  DISTINCT
            driver_order
    ,       race_order
    FROM    results r
    JOIN    raceid_order rc
        ON  r.raceid = rc.raceid
    JOIN    driverid_order d
        ON  r.driverid = d.driverid
    ORDER BY driver_order, race_order
)
SELECT  driver_order
,       group_concat(race_order, ',') races
FROM    combined
group by driver_order
order by driver_order