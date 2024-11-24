CREATE VIEW IF NOT EXISTS vw_driver_standings_leads AS
SELECT  r.year,
        r.round as round_num,
        r.name as race_name,
        d1.forename as forename_1,
        d1.surname as surname_1,
        s1.points as points_1,
        d2.forename as forename_2,
        d2.surname as surname_2,
        s2.points as points_2,
        ROUND(s1.points / s2.points, 2) as points_ratio,
        s1.points - s2.points as points_lead,
        r.raceId,
        d1.driverId as driver_1_id,
        d2.driverId as driver_2_id
FROM driver_standings s1
JOIN driver_standings s2 
    ON s1.raceId = s2.raceId
    AND s1.position = 1
    AND s2.position = 2
JOIN races r
    ON s1.raceId = r.raceId
JOIN drivers d1
    ON s1.driverId = d1.driverId
JOIN drivers d2
    ON s2.driverId = d2.driverId
ORDER BY points_ratio DESC, r.year ASC, r.round ASC