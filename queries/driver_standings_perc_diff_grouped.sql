SELECT  year,
        forename_1 as forename,
        surname_1 as surname,
        min(round_num) as first_matching_race,
        max(round_num) as last_matching_race,
        max(points_ratio) as max_points_ratio,
        count(*) as num_matching_races
FROM vw_driver_standings_leads
WHERE points_ratio >= 2
GROUP BY year, forename_1, surname_1
ORDER BY year