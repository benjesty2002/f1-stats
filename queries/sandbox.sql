-- select year, count(raceid) as races, sum(includes_qualy) as qualys
-- from (  
--         select r.raceid, r.year, sign(count(q.raceid)) as includes_qualy
--         from races r
--         left join qualifying q on q.raceid = r.raceid
--         group by r.raceid, r.year
--     )
-- group by year

SELECT  year
,       c.name as constructor
,       full_season_races as full_season
,       points_winner
,       p_win
,       points_loser
,       p_loss
,       coalesce(first_win_year, 3000) < year as former_champion
,       coalesce(last_win_year, 0) > year as future_champion
,       p_ratio
FROM    teammate_stint_comparisons tsc
LEFT JOIN drivers_champions
    ON  points_loser = driver_name
JOIN    constructors c
    ON  tsc.constructorId = c.constructorId
