WITH driver_pairings AS (
    SELECT  races.year
    ,       results.raceId
    ,       results.constructorId
    ,       count(distinct results.driverId) as num_drivers
    ,       min(results.driverId) as driver_1
    ,       max(results.driverId) as driver_2
    FROM    results
    JOIN    races
        ON  results.raceId = races.raceId
    GROUP BY races.year, results.raceId, results.constructorId
)
, pairings_with_points_positions AS (
    SELECT  dp.*
    ,       res_1.positionOrder as race_position_1
    ,       res_1.points as points_1
    ,       qly_1.position as qualy_position_1
    ,       res_2.positionOrder as race_position_2
    ,       res_2.points as points_2
    ,       qly_2.position as qualy_position_2
    FROM    driver_pairings dp
    JOIN    results res_1
        ON  dp.raceId = res_1.raceId
        AND dp.driver_1 = res_1.driverId
    LEFT JOIN qualifying qly_1
        ON  dp.raceId = qly_1.raceId
        AND dp.driver_1 = qly_1.driverId
    JOIN    results res_2
        ON  dp.raceId = res_2.raceId
        AND dp.driver_2 = res_2.driverId
    LEFT JOIN qualifying qly_2
        ON  dp.raceId = qly_2.raceId
        AND dp.driver_2 = qly_2.driverId
    WHERE   num_drivers = 2
)
, races_per_year AS (
    SELECT  year
    ,       count(*) as num_races
    FROM    races
    GROUP BY year
)
, grouped_by_pairing_year AS (
    SELECT  pwpp.year
    ,       constructorId
    ,       driver_1
    ,       driver_2
    ,       count(*) as num_races_together
    ,       num_races as num_races_in_season
    ,       sum(race_position_1) as total_race_position_1
    ,       sum(points_1) as total_points_1
    ,       sum(qualy_position_1) as total_qualy_position_1
    ,       sum(race_position_2) as total_race_position_2
    ,       sum(points_2) as total_points_2
    ,       sum(qualy_position_2) as total_qualy_position_2
    FROM    pairings_with_points_positions pwpp
    JOIN    races_per_year rpy
        ON  pwpp.year = rpy.year
    GROUP BY pwpp.year, num_races, constructorId, driver_1, driver_2
)
SELECT  year
,       constructorId
,       driver_1
,       d1.forename || ' ' || d1.surname as driver_1_name
,       driver_2
,       d2.forename || ' ' || d2.surname as driver_2_name
,       num_races_together
,       num_races_in_season
,       total_race_position_1
,       total_points_1
,       total_qualy_position_1
,       total_race_position_2
,       total_points_2
,       total_qualy_position_2
FROM    grouped_by_pairing_year gbpy
JOIN    drivers d1
    ON  gbpy.driver_1 = d1.driverId
JOIN    drivers d2
    ON  gbpy.driver_2 = d2.driverId
order by year desc, constructorId desc