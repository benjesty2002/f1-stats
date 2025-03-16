-- select year, count(raceid) as races, sum(includes_qualy) as qualys
-- from (  
--         select r.raceid, r.year, sign(count(q.raceid)) as includes_qualy
--         from races r
--         left join qualifying q on q.raceid = r.raceid
--         group by r.raceid, r.year
--     )
-- group by year

-- SELECT  tsc.year
-- ,       c.name as constructor
-- ,       full_season_races as full_season
-- ,       num_races_together >= (num_races_in_season - 2) as less_than_3_missed
-- ,       points_winner
-- ,       p_win
-- ,       coalesce(wc.first_win_year, 3000) < tsc.year as w_former_champion
-- ,       points_winner = wcy.driver_name as w_year_champion
-- ,       coalesce(wc.last_win_year, 0) > tsc.year as w_future_champion
-- ,       points_loser
-- ,       p_loss
-- ,       coalesce(lc.first_win_year, 3000) < tsc.year as l_former_champion
-- ,       coalesce(lc.last_win_year, 0) > tsc.year as l_future_champion
-- ,       p_ratio
-- FROM    teammate_stint_comparisons tsc
-- LEFT JOIN drivers_champions lc
--     ON  points_loser = lc.driver_name
-- LEFT JOIN drivers_champions wc
--     ON  points_winner = wc.driver_name
-- LEFT JOIN champion_by_year wcy
--     ON  tsc.year = wcy.year
-- JOIN    constructors c
--     ON  tsc.constructorId = c.constructorId

-- select distinct positiontext from results

-- D Disqualified
-- E Excluded
-- F DNQ
-- N Not Classified
-- R Retired
-- W DNS

-- 'D', 'E', 'F', 'N', 'W'


-- SELECT * FROM ordered_drivers where driver_order in (1
-- -- ,6
-- -- ,38
-- -- ,235
-- -- ,276
-- -- ,293
-- -- ,480
-- -- ,598
-- -- ,649
-- -- ,715
-- -- ,816)
-- ,762
-- ,795
-- ,814
-- ,821)
-- order by driver_order


select  end_race_num, position_order, count(*)
from rolling_championship
group by end_race_num, position_order
having count(*) > 1