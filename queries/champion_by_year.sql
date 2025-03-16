SELECT  d.driverId
,       d.forename || ' ' || d.surname as driver_name
,       fs.year
FROM    vw_final_standings fs
JOIN    drivers d
    ON  d.driverId = fs.driverId
WHERE   fs.position = 1