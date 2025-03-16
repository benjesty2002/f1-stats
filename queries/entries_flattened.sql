WITH results_flattened as (
    SELECT  r.raceid
    ,       rc.year
    ,       rc.round
    ,       rc.name as race_name
    ,       r.driverid
    ,       d.forename || ' ' || d.surname as driver_name
    ,       d.nationality as driver_nationality
    ,       r.constructorid
    ,       c.name as constructor_name
    ,       c.nationality as constructor_nationality
    FROM    results r
    JOIN    drivers d
        ON  r.driverid = d.driverid
    JOIN    constructors c
        ON  r.constructorid = c.constructorid
    JOIN    races rc
        ON  r.raceid = rc.raceid
)
SELECT * FROM results_flattened
ORDER BY year, round