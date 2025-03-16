WITH periods AS (
    SELECT  race_order as end_race
    ,       race_order - 9 as start_race
    FROM    ordered_races
)
, by_driver_period AS (
    SELECT  p.start_race
    ,       p.end_race
    ,       res.driverid
    ,       sum(res.points) as points
    FROM    periods p
    JOIN    ordered_races ord
        ON  ord.race_order <= end_race
        AND ord.race_order >= start_race
    JOIN    results res
        ON  ord.raceid = res.raceid
    GROUP BY p.start_race, p.end_race, res.driverid
)
, periods_ranked AS (
    SELECT  start_race
    ,       end_race
    ,       driverid
    ,       points
    ,       row_number() over (partition by start_race, end_race order by points desc) as position_order
    ,       rank() over (partition by start_race, end_race order by points desc) as position
    FROM    by_driver_period
)
, expanded AS (
    SELECT  sr.race_order start_race_num
    ,       sr.raceid start_race_id
    ,       sr.year start_race_year
    ,       sr.round start_race_round
    ,       sr.name start_race_name
    ,       er.race_order end_race_num
    ,       er.raceid end_race_id
    ,       er.year end_race_year
    ,       er.round end_race_round
    ,       er.name end_race_name
    ,       d.driver_order
    ,       d.forename || ' ' || d.surname driver_name
    ,       pr.points
    ,       pr.position
    ,       pr.position_order
    FROM    periods_ranked pr
    LEFT JOIN ordered_races sr
        ON  sr.race_order = pr.start_race
    JOIN    ordered_races er
        ON  er.race_order = pr.end_race
    JOIN    ordered_drivers d
        ON  pr.driverid = d.driverid
)
select * 
from expanded
order by end_race_num desc, position_order asc