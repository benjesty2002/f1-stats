SELECT  rc.year
,       rc.round
,       rc.name
,       rc.date
,       count(*) num_drivers_on_grid
,       sum(de.prior_race_count) total_race_experience
,       round(sum(de.prior_race_count) * 1.0 / count(*), 2) average_race_experience
,       sum(de.prior_season_count) total_seasons_experience
,       round(sum(de.prior_season_count) * 1.0 / count(*), 2) average_seasons_experience
FROM    results r
JOIN    races rc
    ON  r.raceid = rc.raceid
JOIN    driver_experience de
    ON  r.raceid = de.raceid
    AND r.driverid = de.driverid
WHERE   positionText != 'F'  -- 'F' == DNQ
GROUP BY r.raceid, rc.year, rc.round, rc.name, rc.date
ORDER BY rc.year desc, rc.round desc