SELECT  end_race_num race_num
,       end_race_year year
,       end_race_round round
,       end_race_name race_name
,       group_concat(case when position_order = 1 then driver_name else null end) as p1_driver
,       group_concat(case when position_order = 1 then points else null end) as p1_points
,       group_concat(case when position_order = 2 then driver_name else null end) as p2_driver
,       group_concat(case when position_order = 2 then points else null end) as p2_points
,       group_concat(case when position_order = 3 then driver_name else null end) as p3_driver
,       group_concat(case when position_order = 3 then points else null end) as p3_points
,       group_concat(case when position_order = 4 then driver_name else null end) as p4_driver
,       group_concat(case when position_order = 4 then points else null end) as p4_points
,       group_concat(case when position_order = 5 then driver_name else null end) as p5_driver
,       group_concat(case when position_order = 5 then points else null end) as p5_points
FROM    rolling_championship
GROUP BY end_race_num, end_race_year, end_race_round, end_race_name
ORDER BY end_race_num