WITH ranked_leads AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY year, driver_1_id ORDER BY points_lead DESC) as rn
    FROM vw_driver_standings_leads
)
, top_leads AS (
    SELECT *
    FROM ranked_leads
    WHERE rn = 1
)
SELECT  l.year,
        l.round_num,
        l.race_name,
        l.forename_1 as fp_forename,
        l.surname_1 as fp_surname,
        l.forename_2 as sp_forename,
        l.surname_2 as sp_surname,
        l.points_1 as fp_points,
        l.points_2 as sp_points,
        l.points_lead,
        l.points_ratio,
        fds.points as final_season_points,
        fds.position as final_season_position,
        dc.forename as dc_forename,
        dc.surname as dc_surname,
        dcfs.points as dc_points

FROM top_leads l
JOIN final_standings dcfs 
    ON l.year = dcfs.year
    AND dcfs.position = 1
JOIN drivers dc
    ON dcfs.driverId = dc.driverId
JOIN final_standings fds
    ON l.year = fds.year
    AND fds.driverId = l.driver_1_id
WHERE dc.driverId != l.driver_1_id
ORDER BY l.year, l.points_lead DESC