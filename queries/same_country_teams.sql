WITH race_constructors_summary as (
    SELECT  raceid
    ,       constructorid
    ,       sum(case when constructor_nationality = driver_nationality then 1 else 0 end) as nat_match
    ,       sum(case when constructor_nationality != driver_nationality then 1 else 0 end) as nat_mismatch
    ,       min(driver_name) as driver_1
    ,       max(driver_name) as driver_2
    ,       constructor_name
    ,       constructor_nationality
    FROM    entries_flattened
    GROUP BY constructorid, raceid, constructor_name, constructor_nationality
)
, filtered_race_entries as (
    SELECT  ef.*
    FROM    entries_flattened ef
    JOIN    race_constructors_summary rcs
        ON  rcs.nat_mismatch = 0
        AND ef.raceid = rcs.raceid
        AND ef.constructorid = rcs.constructorid
)
, single_nationality_teams as (
    SELECT  d1.constructor_name
    ,       d1.driver_name as d1_name
    ,       d2.driver_name as d2_name
    ,       d1.driver_nationality as nationality
    ,       count(*) as num_races
    FROM    filtered_race_entries d1
    JOIN    filtered_race_entries d2
        ON  d1.constructorid = d2.constructorid
        AND d1.raceid = d2.raceid
        AND d1.driverid < d2.driverid
    GROUP BY d1.constructor_name, d1.driver_name, d2.driver_name, d1.driver_nationality
)
, single_nationality_two_driver_teams as (
    SELECT  constructor_name
    ,       driver_1
    ,       driver_2
    ,       constructor_nationality
    ,       count(*) as num_races
    FROM    race_constructors_summary rcs
    WHERE   rcs.nat_mismatch = 0
        AND rcs.nat_match = 2
    GROUP BY constructor_name, driver_1, driver_2, constructor_nationality
    ORDER BY count(*) DESC
)
SELECT * FROM single_nationality_teams ORDER BY num_races DESC
