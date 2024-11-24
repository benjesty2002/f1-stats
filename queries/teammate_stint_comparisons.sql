SELECT  year
,       constructorId
,       driver_1_name as d1
,       driver_2_name as d2
,       num_races_together
,       num_races_together = num_races_in_season as full_season_races
,       num_qualy_together
,       num_qualy_together = num_races_in_season as full_season_qualy
,       num_races_in_season
,       CASE 
            WHEN total_qualy_position_1 < total_qualy_position_2 THEN driver_1_name
            WHEN total_qualy_position_1 > total_qualy_position_2 THEN driver_2_name
            ELSE 'TIE'
        END AS qualy_position_winner
,       CASE 
            WHEN total_qualy_position_1 > total_qualy_position_2 THEN driver_1_name
            WHEN total_qualy_position_1 < total_qualy_position_2 THEN driver_2_name
            ELSE 'TIE'
        END AS qualy_position_loser
,       round(max(total_qualy_position_1, total_qualy_position_2) * 1.0 / num_qualy_together, 2) as q_loss
,       round(min(total_qualy_position_1, total_qualy_position_2) * 1.0 / num_qualy_together, 2) as q_win
,       round(max(total_qualy_position_1, total_qualy_position_2) * 1.0 / min(total_qualy_position_1, total_qualy_position_2), 2) as q_ratio
,       CASE 
            WHEN total_race_position_1 < total_race_position_2 THEN driver_1_name
            WHEN total_race_position_1 > total_race_position_2 THEN driver_2_name
            ELSE 'TIE'
        END AS race_position_winner
,       CASE 
            WHEN total_race_position_1 > total_race_position_2 THEN driver_1_name
            WHEN total_race_position_1 < total_race_position_2 THEN driver_2_name
            ELSE 'TIE'
        END AS race_position_loser
,       round(max(total_race_position_1, total_race_position_2) * 1.0 / num_races_together, 2) as r_loss
,       round(min(total_race_position_1, total_race_position_2) * 1.0 / num_races_together, 2) as r_win
,       round(max(total_race_position_1, total_race_position_2) * 1.0 / min(total_race_position_1, total_race_position_2), 2) as r_ratio
,       CASE 
            WHEN total_points_1 > total_points_2 THEN driver_1_name
            WHEN total_points_1 < total_points_2 THEN driver_2_name
            ELSE 'TIE'
        END AS points_winner
,       CASE 
            WHEN total_points_1 < total_points_2 THEN driver_1_name
            WHEN total_points_1 > total_points_2 THEN driver_2_name
            ELSE 'TIE'
        END AS points_loser
,       min(total_points_1, total_points_2) as p_loss
,       max(total_points_1, total_points_2) as p_win
,       round(max(total_points_1, total_points_2) * 1.0 / min(total_points_1, total_points_2), 2) as p_ratio
FROM    teammates_by_year