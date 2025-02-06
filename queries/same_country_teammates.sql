WITH driver_details as (
    SELECT  driverId 
    ,       forename || ' ' || surname as driver_name
    ,       nationality
    FROM    drivers
)
, driver_pairs as (
    SELECT DISTINCT
            d.driverId d1_id
    ,       tm.driverId d2_id
    ,       d.raceid
    ,       d.constructorid
    FROM    results d 
    JOIN    races r
        ON  d.raceid = r.raceid
        AND r.year >= 1900
    JOIN    results tm 
        ON  d.raceid = tm.raceid
        AND d.constructorid = tm.constructorid
    WHERE   d.driverId < tm.driverId
)
, same_nationality_pairs as (
    SELECT  d1.driver_name as driver_1
    ,       d2.driver_name as driver_2
    ,       d1.nationality
    ,       count(*) as num_races_as_teammates
    FROM    driver_pairs p
    JOIN    driver_details d1
        ON  p.d1_id = d1.driverId
    JOIN    driver_details d2
        ON  p.d2_id = d2.driverId
    WHERE   d1.nationality = d2.nationality
    GROUP BY d1.driver_name, d2.driver_name, d1.nationality
    ORDER BY count(*) DESC
)
SELECT * FROM same_nationality_pairs
