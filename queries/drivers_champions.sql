SELECT  d.driverId
,       d.forename || ' ' || d.surname as driver_name
,       min(fs.year) as first_win_year
,       max(fs.year) as last_win_year
,       count(fs.year) as num_championships
FROM    vw_final_standings fs
JOIN    drivers d
    ON  d.driverId = fs.driverId
WHERE   fs.position = 1
GROUP BY fs.driverId